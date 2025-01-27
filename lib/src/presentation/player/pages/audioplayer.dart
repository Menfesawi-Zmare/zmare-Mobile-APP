import 'dart:io';
import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/presentation/widgets/next_song.dart';
import 'package:flutter_music_pro/src/presentation/widgets/report_button.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/core/enum/box_types.dart';
import 'package:flutter_music_pro/src/utils/helper/dominant_color.dart';
import 'package:flutter_music_pro/src/utils/helper/mediaitem_converter.dart';
import 'package:flutter_music_pro/src/utils/helper/zoom_tap_animation.dart';
import 'package:flutter_music_pro/src/presentation/player/pages/name_and_control.dart';
import 'package:flutter_music_pro/src/presentation/widgets/download_button.dart';
import 'package:flutter_music_pro/src/presentation/widgets/like_button.dart';
import 'package:flutter_music_pro/src/service_locator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rxdart/rxdart.dart';

import '../widget/artwork_widget.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});
  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  final ValueNotifier<List<Color?>?> gradientColor =
      ValueNotifier(defaultGradientColor);
  final AudioPlayerHandler audioHandler = locator<AudioPlayerHandler>();
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  void updateBackgroundColors(List<Color?> value) {
    gradientColor.value = value;
    return;
  }

  String format(String msg) {
    return '${msg[0].toUpperCase()}${msg.substring(1)}: '.replaceAll('_', ' ');
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.down,
      background: const ColoredBox(color: Colors.transparent),
      key: const Key('playScreen'),
      onDismissed: (direction) {
        Navigator.pop(context);
      },
      child: StreamBuilder<MediaItem?>(
        stream: audioHandler.mediaItem,
        builder: (context, snapshot) {
          final MediaItem? mediaItem = snapshot.data;
          if (mediaItem == null) return const SizedBox();
          final offline =
              !mediaItem.extras!['url'].toString().startsWith('http');
          mediaItem.artUri.toString().startsWith('file')
              ? getColors(
                  imageProvider: FileImage(
                    File(
                      mediaItem.artUri!.toFilePath(),
                    ),
                  ),
                ).then((value) => updateBackgroundColors(value))
              : getColors(
                  imageProvider: CachedNetworkImageProvider(
                    mediaItem.artUri.toString(),
                  ),
                ).then((value) => updateBackgroundColors(value));
          return ValueListenableBuilder(
            valueListenable: gradientColor,
            child: SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  title: NextSong(audioHandler: audioHandler),
                  leading: IconButton(
                    icon: const Icon(FluentIcons.chevron_down_48_regular),
                    tooltip: context.loc.back,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  actions: [if (!offline) ReportButton(mediaItem: mediaItem)],
                ),
                body: LayoutBuilder(
                  builder: (
                    BuildContext context,
                    BoxConstraints constraints,
                  ) {
                    if (constraints.maxWidth > constraints.maxHeight) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Artwork
                          ArtWorkWidget(
                            cardKey: cardKey,
                            mediaItem: mediaItem,
                            width: min(
                              constraints.maxHeight / 0.9,
                              constraints.maxWidth / 1.8,
                            ),
                            audioHandler: audioHandler,
                            offline: offline,
                          ),

                          // title and controls
                          NameNControls(
                            cardKey: cardKey,
                            mediaItem: mediaItem,
                            offline: offline,
                            width: constraints.maxWidth / 2,
                            height: constraints.maxHeight,
                            audioHandler: audioHandler,
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        // Artwork
                        ArtWorkWidget(
                          cardKey: cardKey,
                          mediaItem: mediaItem,
                          width: constraints.maxWidth,
                          audioHandler: audioHandler,
                          offline: offline,
                        ),

                        // title and controls
                        NameNControls(
                          cardKey: cardKey,
                          mediaItem: mediaItem,
                          offline: offline,
                          width: constraints.maxWidth,
                          height: constraints.maxHeight -
                              (constraints.maxWidth * 0.95),
                          audioHandler: audioHandler,
                        ),
                      ],
                    );
                  },
                ),
                // }
              ),
            ),
            builder:
                (BuildContext context, List<Color?>? value, Widget? child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: Theme.of(context).brightness == Brightness.dark
                            ? [
                                value?[0] ?? const Color(0xff2e2a33),
                                value?[1] ?? const Color(0xff141216)
                              ]
                            : [
                                value?[0] ?? const Color(0xff2e2a33),
                                Colors.white,
                              ])),
                child: child,
              );
            },
          );
        },
      ),
    );
  }
}

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

class QueueState {
  static const QueueState empty =
      QueueState([], 0, [], AudioServiceRepeatMode.none);

  final List<MediaItem> queue;
  final int? queueIndex;
  final List<int>? shuffleIndices;
  final AudioServiceRepeatMode repeatMode;

  const QueueState(
    this.queue,
    this.queueIndex,
    this.shuffleIndices,
    this.repeatMode,
  );

  bool get hasPrevious =>
      repeatMode != AudioServiceRepeatMode.none || (queueIndex ?? 0) > 0;
  bool get hasNext =>
      repeatMode != AudioServiceRepeatMode.none ||
      (queueIndex ?? 0) + 1 < queue.length;

  List<int> get indices =>
      shuffleIndices ?? List.generate(queue.length, (i) => i);
}

class ControlButtons extends StatelessWidget {
  final AudioPlayerHandler audioHandler;
  final bool shuffle;
  final bool miniplayer;
  final List buttons;
  final Color? dominantColor;

  const ControlButtons(
    this.audioHandler, {
    super.key,
    this.shuffle = false,
    this.miniplayer = false,
    this.buttons = const ['Previous', 'Play/Pause', 'Next'],
    this.dominantColor,
  });
  Stream<Duration> get _bufferedPositionStream => audioHandler.playbackState
      .map((state) => state.bufferedPosition)
      .distinct();
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        AudioService.position,
        _bufferedPositionStream,
        audioHandler.durationState,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  @override
  Widget build(BuildContext context) {
    final MediaItem mediaItem = audioHandler.mediaItem.value!;
    final bool online = mediaItem.extras!['url'].toString().startsWith('http');
    const min = 0.001;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: buttons.map((e) {
        switch (e) {
          case 'Like':
            return !online
                ? const SizedBox()
                : LikeButton(
                    mediaItem: mediaItem,
                    size: 24.0,
                  );
          case 'Previous':
            return StreamBuilder<QueueState>(
              stream: audioHandler.queueState,
              builder: (context, snapshot) {
                final queueState = snapshot.data;
                return Padding(
                  padding: EdgeInsets.only(right: miniplayer ? 0.0 : 16.0),
                  child: IconButton(
                    icon: const Icon(Icons.skip_previous_rounded),
                    iconSize: miniplayer ? 32.0 : 36.0,
                    tooltip: context.loc.skipPrevious,
                    color: Theme.of(context).colorScheme.onSurface,
                    onPressed: queueState?.hasPrevious ?? true
                        ? audioHandler.skipToPrevious
                        : null,
                  ),
                );
              },
            );
          case 'Play/Pause':
            return SizedBox(
              height: miniplayer ? 65.0 : 65.0,
              width: miniplayer ? 40.0 : 65.0,
              child: StreamBuilder<PlaybackState>(
                stream: audioHandler.playbackState,
                builder: (context, snapshot) {
                  final playbackState = snapshot.data;
                  final processingState = playbackState?.processingState;
                  final playing = playbackState?.playing ?? true;
                  return Stack(
                    children: [
                      if (processingState == AudioProcessingState.loading ||
                          processingState == AudioProcessingState.buffering)
                        Center(
                          child: SizedBox(
                            height: miniplayer ? 40.0 : 65.0,
                            width: miniplayer ? 40.0 : 65.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      if (miniplayer)
                        StreamBuilder<PositionData>(
                            stream: _positionDataStream,
                            builder: (context, snapshot) {
                              final positionData = snapshot.data ??
                                  PositionData(Duration.zero, Duration.zero,
                                      Duration.zero);
                              return Center(
                                child: CircularPercentIndicator(
                                  percent: (positionData.position.inSeconds /
                                          positionData.duration.inSeconds)
                                      .clamp(min, 1.0),
                                  animation: true,
                                  animationDuration: 200,
                                  curve: Curves.easeOutCubic,
                                  animateFromLastPercent: true,
                                  radius: 20,
                                  lineWidth: 4.0,
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor:
                                      Theme.of(context).colorScheme.primary,
                                  backgroundColor: Colors.transparent,
                                  center: playing
                                      ? IconButton(
                                          tooltip: context.loc.pause,
                                          onPressed: audioHandler.pause,
                                          icon: const Icon(
                                            Icons.pause_rounded,
                                          ),
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        )
                                      : IconButton(
                                          tooltip: context.loc.play,
                                          onPressed: audioHandler.play,
                                          icon: const Icon(
                                              Icons.play_arrow_rounded),
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        ),
                                ),
                              );
                            })
                      else
                        ValueListenableBuilder<Box<dynamic>>(
                            valueListenable: locator
                                .get<Box<dynamic>>(
                                    instanceName: BoxType.settings.name)
                                .listenable(keys: [circularPlayButtonKey]),
                            builder: (context, value, child) {
                              final isCircularButton = value.get(
                                  circularPlayButtonKey,
                                  defaultValue: false);
                              if (isCircularButton) {
                                return ZoomTapAnimation(
                                  begin: 1.0,
                                  end: 0.9,
                                  beginDuration:
                                      const Duration(milliseconds: 20),
                                  endDuration:
                                      const Duration(milliseconds: 120),
                                  beginCurve: Curves.decelerate,
                                  endCurve: Curves.fastOutSlowIn,
                                  child: Center(
                                    child: SizedBox(
                                      height: 59,
                                      width: 59,
                                      child: Center(
                                        child: playing
                                            ? FloatingActionButton(
                                                shape: const CircleBorder(),
                                                elevation: 10,
                                                tooltip: context.loc.pause,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                onPressed: audioHandler.pause,
                                                child: Icon(
                                                  Icons.pause_rounded,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                ),
                                              )
                                            : FloatingActionButton(
                                                shape: const CircleBorder(),
                                                elevation: 10,
                                                tooltip: context.loc.play,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                onPressed: audioHandler.play,
                                                child: Icon(
                                                  Icons.play_arrow_rounded,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return ZoomTapAnimation(
                                  begin: 1.0,
                                  end: 0.9,
                                  beginDuration:
                                      const Duration(milliseconds: 20),
                                  endDuration:
                                      const Duration(milliseconds: 120),
                                  beginCurve: Curves.decelerate,
                                  endCurve: Curves.fastOutSlowIn,
                                  child: Center(
                                    child: SizedBox(
                                      height: 59,
                                      width: 59,
                                      child: Center(
                                        child: playing
                                            ? FloatingActionButton(
                                                elevation: 10,
                                                tooltip: context.loc.pause,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                onPressed: audioHandler.pause,
                                                child: Icon(
                                                  Icons.pause_rounded,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                ),
                                              )
                                            : FloatingActionButton(
                                                elevation: 10,
                                                tooltip: context.loc.play,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                onPressed: audioHandler.play,
                                                child: Icon(
                                                  Icons.play_arrow_rounded,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            })
                    ],
                  );
                },
              ),
            );
          case 'Next':
            return StreamBuilder<QueueState>(
              stream: audioHandler.queueState,
              builder: (context, snapshot) {
                final queueState = snapshot.data;
                return Padding(
                  padding: EdgeInsets.only(left: miniplayer ? 0.0 : 16.0),
                  child: IconButton(
                    icon: const Icon(Icons.skip_next_rounded),
                    iconSize: miniplayer ? 32.0 : 36.0,
                    tooltip: context.loc.skipNext,
                    color: Theme.of(context).colorScheme.onSurface,
                    onPressed: queueState?.hasNext ?? true
                        ? audioHandler.skipToNext
                        : null,
                  ),
                );
              },
            );
          case 'Download':
            return !online
                ? const SizedBox()
                : DownloadButton(
                    size: 24.0,
                    icon: 'download',
                    data: MediaItemConverter.mediaItemToMap(mediaItem),
                  );
          default:
            break;
        }
        return const SizedBox();
      }).toList(),
    );
  }
}

abstract class AudioPlayerHandler implements AudioHandler {
  Stream<QueueState> get queueState;
  Future<void> moveQueueItem(int currentIndex, int newIndex);
  ValueStream<double> get volume;
  Future<void> setVolume(double volume);
  ValueStream<double> get speed;
  Stream<Duration?> get durationState;
}
