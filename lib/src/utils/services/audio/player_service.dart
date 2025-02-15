import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/services.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/utils/helper/mediaitem_converter.dart';
import 'package:zmare/src/presentation/player/pages/audioplayer.dart';
import 'package:zmare/src/service_locator.dart';
import 'package:logging/logging.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';

class PlayerInvoke {
  static final AudioPlayerHandler audioHandler = locator<AudioPlayerHandler>();

  static Future<void> init({
    required List songsList,
    required int index,
    bool fromMiniplayer = false,
    bool? isOffline,
    bool recommend = true,
    bool fromDownloads = false,
    bool shuffle = false,
    String? playlistBox,
  }) async {
    final int globalIndex = index < 0 ? 0 : index;
    bool? offline = isOffline;
    final List finalList = songsList.toList();
    if (shuffle) finalList.shuffle();
    if (offline == null) {
      if (audioHandler.mediaItem.value?.extras!['url'].startsWith('http')
          as bool) {
        offline = false;
      } else {
        offline = true;
      }
    } else {
      offline = offline;
    }

    if (!fromMiniplayer) {
      if (!Platform.isIOS) {
        audioHandler.stop();
      }
      if (offline) {
        fromDownloads
            ? setDownValues(finalList, globalIndex)
            : setOffValues(finalList, globalIndex);
      } else {
        setValues(finalList, globalIndex, recommend: recommend);
      }
    }
  }

  static Future<MediaItem> setTags(
    SongModel response,
    Directory tempDir,
  ) async {
    String playTitle = response.title;
    playTitle == ''
        ? playTitle = response.displayNameWOExt
        : playTitle = response.title;
    String playArtist = response.artist ?? '<unknown>';
    playArtist == '<unknown>'
        ? playArtist = 'Unknown'
        : playArtist = response.artist!;

    final String playAlbum = response.album ?? 'Unknown';
    final int playDuration = response.duration ?? 180000;
    final String imagePath = '${tempDir.path}/${response.displayNameWOExt}.png';

    final MediaItem tempDict = MediaItem(
      id: response.id.toString(),
      album: playAlbum,
      duration: Duration(milliseconds: playDuration),
      title: playTitle.split('(')[0],
      artist: playArtist,
      genre: response.genre,
      artUri: Uri.file(imagePath),
      extras: {
        'url': response.data,
        'date_added': response.dateAdded,
        'date_modified': response.dateModified,
        'size': response.size,
        'year': response.getMap['year'],
      },
    );
    return tempDict;
  }

  static void setOffValues(List response, int index) {
    getTemporaryDirectory().then((tempDir) async {
      final File file = File('${tempDir.path}/cover.png');
      if (!await file.exists()) {
        final byteData = await rootBundle.load(Images.defalutCover);
        await file.writeAsBytes(
          byteData.buffer
              .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
        );
      }
      final List<MediaItem> queue = [];
      for (int i = 0; i < response.length; i++) {
        queue.add(
          await setTags(response[i] as SongModel, tempDir),
        );
      }
      updateNplay(queue, index);
    });
  }

  static void setDownValues(List response, int index) {
    final List<MediaItem> queue = [];
    queue.addAll(
      response.map(
        (song) => MediaItemConverter.downMapToMediaItem(song as Map),
      ),
    );
    updateNplay(queue, index);
  }

  static void setValues(List response, int index,
      {bool recommend = true}) async {
    final List<MediaItem> queue = [];
    queue.addAll(
      response.map(
        (song) =>
            MediaItemConverter.mapToMediaItem(song as Map, autoplay: recommend),
      ),
    );
    await updateNplay(queue, index);
  }

  static Future<void> updateNplay(List<MediaItem> queue, int index) async {
    await audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    // await audioHandler.updateQueue(queue);
    await audioHandler
        .customAction('setTracksAndPlay', {'id': index, 'playlist': queue});
    // await audioHandler.play();
    final String repeatMode = Hive.box(BoxType.player.name)
        .get('repeatMode', defaultValue: 'None')
        .toString();
    final bool enforceRepeat = Hive.box(BoxType.player.name)
        .get('enforceRepeat', defaultValue: false) as bool;
    if (enforceRepeat) {
      Logger.root.info('enforceRepeat');
      switch (repeatMode) {
        case 'None':
          audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
          break;
        case 'All':
          audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
          break;
        case 'One':
          audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
          break;
        default:
          break;
      }
    } else {
      audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
      Hive.box(BoxType.player.name).put('repeatMode', 'None');
    }
  }
}
