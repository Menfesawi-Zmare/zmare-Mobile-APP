import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
// ignore: depend_on_referenced_packages
import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/utils/helper/mediaitem_converter.dart';
import 'package:zmare/src/utils/helper/playlist.dart';
import 'package:zmare/src/presentation/login/bloc/auth_bloc.dart';
import 'package:zmare/src/presentation/player/pages/audioplayer.dart';
import 'package:zmare/src/service_locator.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerHandlerImpl extends BaseAudioHandler
    with QueueHandler, SeekHandler
    implements AudioPlayerHandler {
  int? count;
  Timer? _sleepTimer;
  bool recommend = true;
  bool loadStart = false;
  bool useDown = true;
  AndroidEqualizerParameters? _equalizerParams;

  late AudioPlayer? _player;
  late String preferredQuality;
  late bool resetOnSkip;
  late bool cacheSong;
  late bool isSetTrackAndPlay = false;
  final _equalizer = AndroidEqualizer();

  Box downloadsBox = Hive.box(BoxType.downloads.name);
  final BehaviorSubject<List<MediaItem>> _recentSubject =
      BehaviorSubject.seeded(<MediaItem>[]);
  final _playlist = ConcatenatingAudioSource(children: []);
  @override
  final BehaviorSubject<double> volume = BehaviorSubject.seeded(1.0);
  @override
  final BehaviorSubject<double> speed = BehaviorSubject.seeded(1.0);
  final _mediaItemExpando = Expando<MediaItem>();
  late List<int> preferredCompactNotificationButtons = [1, 2, 3];
  Stream<List<IndexedAudioSource>> get _effectiveSequence => Rx.combineLatest3<
              List<IndexedAudioSource>?,
              List<int>?,
              bool,
              List<IndexedAudioSource>?>(_player!.sequenceStream,
          _player!.shuffleIndicesStream, _player!.shuffleModeEnabledStream,
          (sequence, shuffleIndices, shuffleModeEnabled) {
        if (sequence == null) return [];
        if (!shuffleModeEnabled) return sequence;
        if (shuffleIndices == null) return null;
        if (shuffleIndices.length != sequence.length) return null;
        return shuffleIndices.map((i) => sequence[i]).toList();
      }).whereType<List<IndexedAudioSource>>();

  int? getQueueIndex(
    int? currentIndex,
    List<int>? shuffleIndices, {
    bool shuffleModeEnabled = false,
  }) {
    final effectiveIndices = _player!.effectiveIndices ?? [];
    final shuffleIndicesInv = List.filled(effectiveIndices.length, 0);
    for (var i = 0; i < effectiveIndices.length; i++) {
      shuffleIndicesInv[effectiveIndices[i]] = i;
    }
    return (shuffleModeEnabled &&
            ((currentIndex ?? 0) < shuffleIndicesInv.length))
        ? shuffleIndicesInv[currentIndex ?? 0]
        : currentIndex;
  }

  @override
  Stream<QueueState> get queueState =>
      Rx.combineLatest3<List<MediaItem>, PlaybackState, List<int>, QueueState>(
        queue,
        playbackState,
        _player!.shuffleIndicesStream.whereType<List<int>>(),
        (queue, playbackState, shuffleIndices) => QueueState(
          queue,
          playbackState.queueIndex,
          playbackState.shuffleMode == AudioServiceShuffleMode.all
              ? shuffleIndices
              : null,
          playbackState.repeatMode,
        ),
      ).where(
        (state) =>
            state.shuffleIndices == null ||
            state.queue.length == state.shuffleIndices!.length,
      );

  AudioPlayerHandlerImpl() {
    _init();
  }

  Future<void> _init() async {
    Logger.root.info('starting audio service');
    preferredCompactNotificationButtons = Hive.box(BoxType.player.name)
            .get('preferredCompactNotificationButtons', defaultValue: [1, 2, 3])
        as List<int>;
    if (preferredCompactNotificationButtons.length > 3) {
      preferredCompactNotificationButtons = [1, 2, 3];
    }
    preferredCompactNotificationButtons = [1, 2, 3];
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    await startService();

    speed.debounceTime(const Duration(milliseconds: 250)).listen((speed) {
      playbackState.add(playbackState.value.copyWith(speed: speed));
    });
    resetOnSkip = Hive.box(BoxType.player.name)
        .get('resetOnSkip', defaultValue: false) as bool;
    cacheSong = Hive.box(BoxType.player.name)
        .get('cacheSong', defaultValue: false) as bool;
    loadStart = Hive.box(BoxType.player.name)
        .get('loadStart', defaultValue: true) as bool;
    mediaItem.whereType<MediaItem>().listen((item) {
      if (count != null) {
        count = count! - 1;
        if (count! <= 0) {
          count = null;
          stop();
        }
      }
    });
    _listenForCurrentSongIndexChanges();
    _listenForDurationChanges();
    _player!.shuffleModeEnabledStream.listen((event) {
      _listenForDurationChanges();
    });
    Rx.combineLatest4<int?, List<MediaItem>, bool, List<int>?, MediaItem?>(
        _player!.currentIndexStream,
        queue,
        _player!.shuffleModeEnabledStream,
        _player!.shuffleIndicesStream,
        (index, queue, shuffleModeEnabled, shuffleIndices) {
      final queueIndex = getQueueIndex(
        index,
        shuffleIndices,
        shuffleModeEnabled: shuffleModeEnabled,
      );
      return (queueIndex != null && queueIndex < queue.length)
          ? queue[queueIndex]
          : null;
    }).whereType<MediaItem>().distinct().listen(mediaItem.add);

    // Propagate all events from the audio player to AudioService clients.
    _player!.playbackEventStream.listen(_broadcastState);

    _player!.shuffleModeEnabledStream
        .listen((enabled) => _broadcastState(_player!.playbackEvent));

    _player!.loopModeStream
        .listen((event) => _broadcastState(_player!.playbackEvent));

    _player!.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        stop();
        _player!.seek(Duration.zero, index: 0);
      }
    });
    // Broadcast the current queue.
    _effectiveSequence
        .map(
          (sequence) =>
              sequence.map((source) => _mediaItemExpando[source]!).toList(),
        )
        .pipe(queue);
    try {
      if (loadStart) {
        Logger.root.info('loadStart');
        final List lastQueueList = await Hive.box(BoxType.cache.name)
            .get('lastQueue', defaultValue: [])?.toList() as List;
        Logger.root.info('Total Last Queue -${lastQueueList.length}');
        final int lastIndex = await Hive.box(BoxType.cache.name)
            .get('lastIndex', defaultValue: 0) as int;

        final int lastPos = await Hive.box(BoxType.cache.name)
            .get('lastPos', defaultValue: 0) as int;

        if (lastQueueList.isNotEmpty) {
          final List<MediaItem> lastQueue = lastQueueList
              .map((e) => MediaItemConverter.mapToMediaItem(e as Map))
              .toList();
          if (lastQueue.isEmpty) {
            await _player!.setAudioSource(_playlist, preload: false);
          } else {
            await _playlist.addAll(_itemsToSources(lastQueue));
            try {
              if (lastIndex != 0 || lastPos > 0) {
                await _player!.setAudioSource(
                  _playlist,
                  initialIndex: lastIndex,
                  initialPosition: Duration(seconds: lastPos),
                );
              } else {
                await _player!.setAudioSource(
                  _playlist,
                );
              }
            } catch (e) {
              Logger.root.severe('Error while setting last audiosource', e);
              await _player!.setAudioSource(_playlist, preload: false);
            }
          }
        } else {
          Logger.root.severe('setAudioSource-0');
          await _player!.setAudioSource(_playlist, preload: false);
        }
      } else {
        Logger.root.severe('setAudioSource');
        await _player!.setAudioSource(_playlist, preload: false);
      }
    } catch (e) {
      Logger.root.severe('Error while loading last queue', e);
      await _player!.setAudioSource(_playlist, preload: false);
    }
  }

  void _listenForCurrentSongIndexChanges() {
    _player!.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      if (_player!.shuffleModeEnabled) {
        index = getQueueIndex(
          _player!.currentIndex,
          _player!.shuffleIndices,
          shuffleModeEnabled: true,
        );
      }
      if (playlist[index!].artUri.toString().startsWith('http')) {
        addRecentlyPlayed(playlist[index]);
        _recentSubject.add([playlist[index]]);
      }
    });
  }

  void _listenForDurationChanges() {
    _player!.durationStream.listen((duration) {
      var index = _player!.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      if (_player!.shuffleModeEnabled) {
        index = getQueueIndex(
          _player!.currentIndex,
          _player!.shuffleIndices,
          shuffleModeEnabled: true,
        );
      }
      final oldMediaItem = newQueue[index!];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      mediaItem.add(newMediaItem);
    });
  }

  AudioSource _itemToSource(MediaItem mediaItem) {
    AudioSource audioSource;
    if (mediaItem.artUri.toString().startsWith('file:')) {
      audioSource =
          AudioSource.uri(Uri.file(mediaItem.extras!['url'].toString()));
    } else {
      if (downloadsBox.containsKey(mediaItem.id) && useDown) {
        audioSource = AudioSource.uri(
          Uri.file(
            (downloadsBox.get(mediaItem.id) as Map)['path'].toString(),
          ),
          tag: mediaItem.id,
        );
      } else {
        if (cacheSong) {
          audioSource = LockCachingAudioSource(
            Uri.parse(
              mediaItem.extras!['url'],
            ),
          );
        } else {
          audioSource = AudioSource.uri(
            Uri.parse(mediaItem.extras!['url']),
          );
        }
      }
    }
    _mediaItemExpando[audioSource] = mediaItem;
    return audioSource;
  }

  List<AudioSource> _itemsToSources(List<MediaItem> mediaItems) {
    cacheSong = Hive.box(BoxType.player.name)
        .get('cacheSong', defaultValue: false) as bool;
    useDown = Hive.box(BoxType.player.name).get('useDown', defaultValue: true)
        as bool;
    return mediaItems.map(_itemToSource).whereType<AudioSource>().toList();
  }

  @override
  Future<void> onTaskRemoved() async {
    final bool stopForegroundService = Hive.box(BoxType.player.name)
        .get('stopForegroundService', defaultValue: true) as bool;
    if (stopForegroundService) {
      await stop();
    }
  }

  @override
  Future<List<MediaItem>> getChildren(
    String parentMediaId, [
    Map<String, dynamic>? options,
  ]) async {
    switch (parentMediaId) {
      case AudioService.recentRootId:
        return _recentSubject.value;
      default:
        return queue.value;
    }
  }

  @override
  ValueStream<Map<String, dynamic>> subscribeToChildren(String parentMediaId) {
    switch (parentMediaId) {
      case AudioService.recentRootId:
        final stream = _recentSubject.map((_) => <String, dynamic>{});
        return _recentSubject.hasValue
            ? stream.shareValueSeeded(<String, dynamic>{})
            : stream.shareValue();
      default:
        return Stream.value(queue.value)
            .map((_) => <String, dynamic>{})
            .shareValue();
    }
  }

  Future<void> startService() async {
    final bool withPipeline = Hive.box(BoxType.player.name)
        .get('supportEq', defaultValue: false) as bool;
    if (withPipeline && Platform.isAndroid) {
      Logger.root.info('starting with eq pipeline');
      final AudioPipeline pipeline = AudioPipeline(
        androidAudioEffects: [
          _equalizer,
        ],
      );
      _player = AudioPlayer(audioPipeline: pipeline);
    } else {
      Logger.root.info('starting without eq pipeline');
      _player = AudioPlayer();
    }
  }

  Future<void> addRecentlyPlayed(MediaItem mediaitem) async {
    AuthBloc authBloc = locator.get<AuthBloc>();
    Logger.root.info('adding ${mediaitem.title} to recently played');
    List recentList = await Hive.box(BoxType.cache.name)
        .get('recentSongs', defaultValue: [])?.toList() as List;
    authBloc.add(AddViewEvent(mediaitem.id));
    Logger.root.info('adding ${mediaitem.id} data to stats');
    final Map item = MediaItemConverter.mediaItemToMap(mediaitem);
    recentList.insert(0, item);
    final jsonList = recentList.map((item) => jsonEncode(item)).toList();
    final uniqueJsonList = jsonList.toSet().toList();
    recentList = uniqueJsonList.map((item) => jsonDecode(item)).toList();
    if (recentList.length > 50) {
      recentList = recentList.sublist(0, 50);
    }
    Hive.box(BoxType.cache.name).put('recentSongs', recentList);
  }

  Future<void> addLastQueue(List<MediaItem> queue) async {
    final lastQueue =
        queue.map((item) => MediaItemConverter.mediaItemToMap(item)).toList();
    Hive.box(BoxType.cache.name).put('lastQueue', lastQueue);
  }

  Future<void> skipToMediaItem(String id) async {
    final index = queue.value.indexWhere((item) => item.id == id);
    _player!.seek(
      Duration.zero,
      index:
          _player!.shuffleModeEnabled ? _player!.shuffleIndices![index] : index,
    );
  }

  Future<void> setTracksAndPlay(int id, List<MediaItem> newQueue) async {
    isSetTrackAndPlay = true;
    await _playlist.clear();
    await _playlist.addAll(_itemsToSources(newQueue));
    addLastQueue(newQueue);
    try {
      await _player!.setAudioSource(_playlist, initialIndex: id);
      await _player!.play();
    } catch (e) {
      if (e is PlayerInterruptedException ||
          e is PlatformException && e.code == 'abort') {
        // Do nothing
        Logger.root.info("abort");
      } else if (e is PlayerException) {
        Logger.root.info("PlayerException");
        skipToNext();
      } else {
        // Other exceptions are not expected, rethrow.
        rethrow;
      }
    }
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    final res = _itemToSource(mediaItem);
    await _playlist.add(res);
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    await _playlist.addAll(_itemsToSources(mediaItems));
  }

  @override
  Future<void> insertQueueItem(int index, MediaItem mediaItem) async {
    await _playlist.insert(index, _itemToSource(mediaItem));
  }

  @override
  Future<void> updateQueue(List<MediaItem> newQueue) async {
    await _playlist.clear();
    await _playlist.addAll(_itemsToSources(newQueue));
    // addLastQueue(newQueue);
  }

  @override
  Future<void> updateMediaItem(MediaItem mediaItem) async {
    final index = queue.value.indexWhere((item) => item.id == mediaItem.id);
    _mediaItemExpando[_player!.sequence![index]] = mediaItem;
  }

  @override
  Future<void> removeQueueItem(MediaItem mediaItem) async {
    final index = queue.value.indexOf(mediaItem);
    await _playlist.removeAt(index);
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    await _playlist.removeAt(index);
  }

  @override
  Future<void> moveQueueItem(int currentIndex, int newIndex) async {
    await _playlist.move(currentIndex, newIndex);
  }

  @override
  Future<void> skipToNext() => _player!.seekToNext();

  /// This is called when the user presses the "like" button.
  @override
  Future<void> fastForward() async {
    if (mediaItem.value?.id != null) {
      addItemToPlaylist(BoxType.favorite.name, mediaItem.value!);
      _broadcastState(_player!.playbackEvent);
    }
  }

  @override
  Future<void> rewind() async {
    if (mediaItem.value?.id != null) {
      removeLiked(mediaItem.value!.id);
      _broadcastState(_player!.playbackEvent);
    }
  }

  @override
  Future<void> skipToPrevious() async {
    resetOnSkip = Hive.box(BoxType.player.name)
        .get('resetOnSkip', defaultValue: false) as bool;
    if (resetOnSkip) {
      if ((_player?.position.inSeconds ?? 5) <= 5) {
        _player!.seekToPrevious();
      } else {
        _player!.seek(Duration.zero);
      }
    } else {
      _player!.seekToPrevious();
    }
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= _playlist.children.length) return;
    _player!.seek(
      Duration.zero,
      index:
          _player!.shuffleModeEnabled ? _player!.shuffleIndices![index] : index,
    );
  }

  @override
  Future<void> play() => _player!.play();

  @override
  Future<void> pause() async {
    _player!.pause();
    final queueIndex = getQueueIndex(
      _player!.currentIndex,
      _player!.shuffleIndices,
      shuffleModeEnabled: _player!.shuffleModeEnabled,
    );
    await Hive.box(BoxType.cache.name).put('lastIndex', queueIndex);
    await Hive.box(BoxType.cache.name)
        .put('lastPos', _player!.position.inSeconds);
    await addLastQueue(queue.value);
  }

  @override
  Future<void> seek(Duration position) => _player!.seek(position);

  @override
  Future<void> stop() async {
    await _player!.stop();
    await playbackState.firstWhere(
      (state) => state.processingState == AudioProcessingState.idle,
    );
    final queueIndex = getQueueIndex(
      _player!.currentIndex,
      _player!.shuffleIndices,
      shuffleModeEnabled: _player!.shuffleModeEnabled,
    );
    await Hive.box(BoxType.cache.name).put('lastIndex', queueIndex);
    await Hive.box(BoxType.cache.name)
        .put('lastPos', _player!.position.inSeconds);
    await addLastQueue(queue.value);
  }

  @override
  Future customAction(String name, [Map<String, dynamic>? extras]) {
    if (name == 'sleepTimer') {
      _sleepTimer?.cancel();
      if (extras?['time'] != null &&
          extras!['time'].runtimeType == int &&
          extras['time'] > 0 as bool) {
        _sleepTimer = Timer(Duration(minutes: extras['time'] as int), () {
          stop();
        });
      }
    }
    if (name == 'sleepCounter') {
      if (extras?['count'] != null &&
          extras!['count'].runtimeType == int &&
          extras['count'] > 0 as bool) {
        count = extras['count'] as int;
      }
    }

    if (name == 'setBandGain') {
      final bandIdx = extras!['band'] as int;
      final gain = extras['gain'] as double;
      _equalizerParams!.bands[bandIdx].setGain(gain);
    }

    if (name == 'setEqualizer') {
      _equalizer.setEnabled(extras!['value'] as bool);
    }

    if (name == 'fastForward') {
      try {
        const stepInterval = Duration(seconds: 10);
        Duration newPosition = _player!.position + stepInterval;
        if (newPosition < Duration.zero) newPosition = Duration.zero;
        if (newPosition > _player!.duration!) newPosition = _player!.duration!;
        _player!.seek(newPosition);
      } catch (e) {
        Logger.root.severe('Error in fastForward', e);
      }
    }

    if (name == 'rewind') {
      try {
        const stepInterval = Duration(seconds: 10);
        Duration newPosition = _player!.position - stepInterval;
        if (newPosition < Duration.zero) newPosition = Duration.zero;
        if (newPosition > _player!.duration!) newPosition = _player!.duration!;
        _player!.seek(newPosition);
      } catch (e) {
        Logger.root.severe('Error in rewind', e);
      }
    }

    if (name == 'getEqualizerParams') {
      return getEqParms();
    }
    if (name == 'skipToMediaItem') {
      skipToMediaItem(extras!['id'].toString());
    }
    if (name == 'setTracksAndPlay') {
      setTracksAndPlay(extras!['id'], extras['playlist'] as List<MediaItem>);
    }
    return super.customAction(name, extras);
  }

  Future<Duration> getDuration() async {
    return _player?.duration ?? Duration.zero;
  }

  Future<Map> getEqParms() async {
    _equalizerParams ??= await _equalizer.parameters;
    final List<AndroidEqualizerBand> bands = _equalizerParams!.bands;
    final List<Map> bandList = bands
        .map(
          (e) => {
            'centerFrequency': e.centerFrequency,
            'gain': e.gain,
            'index': e.index
          },
        )
        .toList();

    return {
      'maxDecibels': _equalizerParams!.maxDecibels,
      'minDecibels': _equalizerParams!.minDecibels,
      'bands': bandList
    };
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    final enabled = shuffleMode == AudioServiceShuffleMode.all;
    if (enabled) {
      await _player!.shuffle();
    }
    playbackState.add(playbackState.value.copyWith(shuffleMode: shuffleMode));
    await _player!.setShuffleModeEnabled(enabled);
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    playbackState.add(playbackState.value.copyWith(repeatMode: repeatMode));
    await _player!.setLoopMode(LoopMode.values[repeatMode.index]);
  }

  @override
  Future<void> setSpeed(double speed) async {
    this.speed.add(speed);
    await _player!.setSpeed(speed);
  }

  @override
  Future<void> setVolume(double volume) async {
    this.volume.add(volume);
    await _player!.setVolume(volume);
  }

  @override
  Future<void> click([MediaButton button = MediaButton.media]) async {
    switch (button) {
      case MediaButton.media:
        _handleMediaActionPressed();
        break;
      case MediaButton.next:
        await skipToNext();
        break;
      case MediaButton.previous:
        await skipToPrevious();
        break;
    }
  }

  late BehaviorSubject<int> _tappedMediaActionNumber;
  Timer? _timer;

  void _handleMediaActionPressed() {
    if (_timer == null) {
      _tappedMediaActionNumber = BehaviorSubject.seeded(1);
      _timer = Timer(const Duration(milliseconds: 800), () {
        final tappedNumber = _tappedMediaActionNumber.value;
        switch (tappedNumber) {
          case 1:
            if (playbackState.value.playing) {
              pause();
            } else {
              play();
            }
            break;
          case 2:
            skipToNext();
            break;
          case 3:
            skipToPrevious();
            break;
          default:
            break;
        }
        _tappedMediaActionNumber.close();
        _timer!.cancel();
        _timer = null;
      });
    } else {
      final current = _tappedMediaActionNumber.value;
      _tappedMediaActionNumber.add(current + 1);
    }
  }

  /// Broadcasts the current state to all clients.
  void _broadcastState(PlaybackEvent event) {
    final playing = _player!.playing;
    final queueIndex = getQueueIndex(
      event.currentIndex,
      _player!.shuffleIndices,
      shuffleModeEnabled: _player!.shuffleModeEnabled,
    );
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          const MediaControl(
            androidIcon: 'drawable/ic_skip_previous',
            label: 'Previous',
            action: MediaAction.skipToPrevious,
          ),
          if (playing)
            const MediaControl(
              androidIcon: 'drawable/ic_pause',
              label: 'Pause',
              action: MediaAction.pause,
            )
          else
            const MediaControl(
              androidIcon: 'drawable/ic_play',
              label: 'Play',
              action: MediaAction.play,
            ),
          const MediaControl(
            androidIcon: 'drawable/ic_skip_next',
            label: 'Previous',
            action: MediaAction.skipToNext,
          ),
        ],
        systemActions: {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: [0, 1, 2],
        processingState: {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player!.processingState]!,
        playing: playing,
        updatePosition: _player!.position,
        bufferedPosition: _player!.bufferedPosition,
        speed: _player!.speed,
        queueIndex: queueIndex,
      ),
    );
  }

  Future<void> playMediaItem(MediaItem mediaItem) async {
    await _playlist.clear();
    await _playlist.add(_itemToSource(mediaItem));
    await _player!.setAudioSource(_playlist);
    await _player!.play();
  }

  @override
  Stream<Duration?> get durationState => _player!.durationStream;
}
