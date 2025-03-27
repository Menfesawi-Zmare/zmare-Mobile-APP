import 'dart:io';
import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:palette_generator/palette_generator.dart';

import 'package:zmare/src/presentation/player/pages/now_play.dart';
import 'package:zmare/src/presentation/widgets/next_song.dart';
import 'package:zmare/src/presentation/widgets/report_button.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/utils/helper/dominant_color.dart';
import 'package:zmare/src/utils/helper/mediaitem_converter.dart';
import 'package:zmare/src/utils/helper/zoom_tap_animation.dart';
import 'package:zmare/src/presentation/player/pages/name_and_control.dart';
import 'package:zmare/src/presentation/widgets/download_button.dart';
import 'package:zmare/src/presentation/widgets/like_button.dart';
import 'package:zmare/src/service_locator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/routes.dart';
import '../widget/artwork_widget.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});
  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<List<Color?>?> gradientColor =
      ValueNotifier(defaultGradientColor);
  final AudioPlayerHandler audioHandler = locator<AudioPlayerHandler>();
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  late AnimationController controller;
  late Animation<Alignment> topAlignmentAnimation;
  late Animation<Alignment> bottomAlignmentAnimation;
  late Animation<double> rotationAnimation;
  final accountJson = account.get(accountDetail, defaultValue: '');
  late bool isPlaying = false;
  bool isSignedUp = false;
  bool isMusicQueueOpened = false;
  Color dominantColor = Colors.black;

  final ScrollController _scrollController = ScrollController();
  void updateBackgroundColors(List<Color?> value) {
    gradientColor.value = value;
    return;
  }

  String format(String msg) {
    return '${msg[0].toUpperCase()}${msg.substring(1)}: '.replaceAll('_', ' ');
  }

  @override
  void initState() {
    if (accountJson != '') {
      isSignedUp = true;
    }

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 27));
    // Initialize the animation controller

    topAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
          ),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.bottomRight,
            end: Alignment.bottomLeft,
          ),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.bottomLeft,
            end: Alignment.topLeft,
          ),
          weight: 1),
    ]).animate(controller);

    bottomAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.bottomRight,
            end: Alignment.bottomLeft,
          ),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.bottomLeft,
            end: Alignment.topLeft,
          ),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
          ),
          weight: 1),
    ]).animate(controller);

    controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  void extractPrimaryColor(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);

    setState(() {
      dominantColor = paletteGenerator.dominantColor?.color ?? Colors.black;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.down,
      background: const ColoredBox(color: Colors.transparent),
      key: const Key('playScreen'),
      onDismissed: (direction) {
        GoRouter.of(rootNavigatorKey.currentContext!).pop();
      },
      child: StreamBuilder<MediaItem?>(
        stream: audioHandler.mediaItem,
        builder: (context, snapshot) {
          final MediaItem? mediaItem = snapshot.data;

          if (mediaItem == null) return const SizedBox();
          final offline =
              !mediaItem.extras!['url'].toString().startsWith('http');
          if (mediaItem.artUri == null || mediaItem.artUri.toString().isEmpty) {
            extractPrimaryColor(
              AssetImage("assets/song.png"),
            );
            getColors(
              imageProvider: AssetImage("assets/song.png"),
            ).then((value) => updateBackgroundColors(value));
          } else {
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
          }

          if (mediaItem.artUri.toString().startsWith('file')) {
            extractPrimaryColor(
                FileImage(File(mediaItem.artUri!.toFilePath())));
          } else {
            extractPrimaryColor(
                CachedNetworkImageProvider(mediaItem.artUri.toString()));
          }
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
                      GoRouter.of(rootNavigatorKey.currentContext!).pop();
                    },
                  ),
                  actions: [
                    if (!offline)
                      ReportButton(
                        mediaItem: mediaItem,
                        dominantColor: dominantColor,
                      ),
                  ],
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
                          if (isMusicQueueOpened)
                            Container(
                              height: constraints.maxWidth * 1.3,
                              width: constraints.maxWidth * 0.45,
                              color: Colors.transparent,
                              child: StreamBuilder<MediaItem?>(
                                stream: audioHandler.mediaItem,
                                builder: (context, snapshot) {
                                  final mediaItem = snapshot.data;
                                  return mediaItem == null
                                      ? const SizedBox()
                                      : NowPlayingStream(
                                          // scrollController: _scrollController,
                                          audioHandler: audioHandler,
                                        );
                                },
                              ),
                            )
                          else
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
                            isSignedUp: isSignedUp,
                            openPlayList: () {
                              setState(() {
                                isMusicQueueOpened = !isMusicQueueOpened;
                              });
                            },
                            dominantColor: dominantColor,
                            playistOpened: isMusicQueueOpened,
                            cardKey: cardKey,
                            animationController: controller,
                            mediaItem: mediaItem,
                            offline: offline,
                            width: constraints.maxWidth / 2,
                            height: constraints.maxHeight,
                            audioHandler: audioHandler,
                          ),
                        ],
                      );
                    }
                    return SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          // Artwork
                          if (isMusicQueueOpened)
                            Container(
                              height: constraints.maxWidth * 1.3,
                              width: constraints.maxWidth,
                              color: Colors.transparent,
                              child: StreamBuilder<MediaItem?>(
                                stream: audioHandler.mediaItem,
                                builder: (context, snapshot) {
                                  final mediaItem = snapshot.data;
                                  return mediaItem == null
                                      ? const SizedBox()
                                      : NowPlayingStream(
                                          // scrollController: _scrollController,
                                          audioHandler: audioHandler,
                                        );
                                },
                              ),
                            )
                          else
                            ArtWorkWidget(
                              cardKey: cardKey,
                              mediaItem: mediaItem,
                              width: constraints.maxWidth,
                              audioHandler: audioHandler,
                              offline: offline,
                            ),

                          // title and controls
                          NameNControls(
                            isSignedUp: isSignedUp,
                            dominantColor: dominantColor,
                            openPlayList: () {
                              setState(() {
                                isMusicQueueOpened = !isMusicQueueOpened;
                              });
                            },
                            playistOpened: isMusicQueueOpened,
                            cardKey: cardKey,
                            mediaItem: mediaItem,
                            animationController: controller,
                            offline: offline,
                            width: constraints.maxWidth,
                            height: constraints.maxHeight -
                                (constraints.maxWidth * 0.95),
                            audioHandler: audioHandler,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // }
              ),
            ),
            builder:
                (BuildContext context, List<Color?>? value, Widget? child) {
              return AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    return Container(
                      height: double.maxFinite,
                      // duration: const Duration(milliseconds: 600),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: topAlignmentAnimation.value,
                              end: bottomAlignmentAnimation.value,
                              colors: Theme.of(context).brightness ==
                                      Brightness.dark
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
                  });
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

// ignore: must_be_immutable
class ControlButtons extends StatefulWidget {
  final AudioPlayerHandler audioHandler;
  final bool shuffle;
  final bool miniplayer;
  final List buttons;
  final bool? isSignedUp;
  final Color? dominantColor;
  AnimationController? animationController;
  ControlButtons(
    this.audioHandler, {
    super.key,
    this.shuffle = false,
    this.miniplayer = false,
    this.buttons = const ['Previous', 'Play/Pause', 'Next'],
    this.dominantColor,
    this.animationController,
    this.isSignedUp,
  });

  @override
  State<ControlButtons> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons> {
  Stream<Duration> get _bufferedPositionStream =>
      widget.audioHandler.playbackState
          .map((state) => state.bufferedPosition)
          .distinct();

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        AudioService.position,
        _bufferedPositionStream,
        widget.audioHandler.durationState,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  bool isPlaying = false;
  void _resetAnimation() {
    if (widget.animationController != null) {
      widget.animationController!.reset();
      if (isPlaying) {
        widget.animationController!.forward();
      }
    }
  }

  @override
  void initState() {
    widget.audioHandler.mediaItem.listen((mediaItem) {
      if (mediaItem != null) {
        _resetAnimation();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaItem mediaItem = widget.audioHandler.mediaItem.value!;
    final bool online = mediaItem.extras!['url'].toString().startsWith('http');
    const min = 0.001;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: widget.buttons.map((e) {
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
              stream: widget.audioHandler.queueState,
              builder: (context, snapshot) {
                final queueState = snapshot.data;
                if (!widget.miniplayer) {
                  isPlaying
                      ? widget.animationController!.forward()
                      : widget.animationController!.stop();
                }
                return Padding(
                  padding:
                      EdgeInsets.only(right: widget.miniplayer ? 0.0 : 16.0),
                  child: IconButton(
                    icon: const Icon(Icons.skip_previous_rounded),
                    iconSize: widget.miniplayer ? 32.0 : 36.0,
                    tooltip: context.loc.skipPrevious,
                    color: Theme.of(context).colorScheme.onSurface,
                    onPressed: () {
                      if (queueState?.hasPrevious ?? true) {
                        widget.audioHandler.skipToPrevious().then(
                          (_) {
                            _resetAnimation();
                          },
                        );
                      } else {
                        return null;
                      }
                    },
                  ),
                );
              },
            );
          case 'Play/Pause':
            return SizedBox(
              height: widget.miniplayer ? 65.0 : 65.0,
              width: widget.miniplayer ? 40.0 : 65.0,
              child: StreamBuilder<PlaybackState>(
                stream: widget.audioHandler.playbackState,
                builder: (context, snapshot) {
                  final playbackState = snapshot.data;
                  final processingState = playbackState?.processingState;
                  final playing = playbackState?.playing ?? true;
                  isPlaying = playing;
                  if (!widget.miniplayer) {
                    playing
                        ? widget.animationController!.forward()
                        : widget.animationController!.stop();
                  }

                  return Stack(
                    children: [
                      if (processingState == AudioProcessingState.loading ||
                          processingState == AudioProcessingState.buffering)
                        Center(
                          child: SizedBox(
                            height: widget.miniplayer ? 40.0 : 65.0,
                            width: widget.miniplayer ? 40.0 : 65.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                // widget.dominantColor!,
                                Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      if (widget.miniplayer)
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
                                  progressColor: widget.dominantColor,
                                  // Theme.of(context).colorScheme.primary,
                                  backgroundColor: Colors.transparent,
                                  center: playing
                                      ? IconButton(
                                          tooltip: context.loc.pause,
                                          onPressed: widget.audioHandler.pause,
                                          icon: const Icon(
                                            Icons.pause_rounded,
                                          ),
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        )
                                      : IconButton(
                                          tooltip: context.loc.play,
                                          onPressed: widget.audioHandler.play,
                                          icon: const Icon(
                                              Icons.play_arrow_rounded),
                                          color:
                                              //  widget.dominantColor,
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
                                                elevation: 2,
                                                tooltip: context.loc.pause,
                                                backgroundColor:
                                                    widget.dominantColor,
                                                onPressed:
                                                    widget.audioHandler.pause,
                                                child: Icon(
                                                  Icons.pause_rounded,
                                                  color: widget.dominantColor!
                                                              .computeLuminance() >
                                                          0.5
                                                      ? Colors.black
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                ),
                                              )
                                            : FloatingActionButton(
                                                shape: const CircleBorder(),
                                                elevation: 2,
                                                tooltip: context.loc.play,
                                                backgroundColor:
                                                    widget.dominantColor,
                                                onPressed:
                                                    widget.audioHandler.play,
                                                child: Icon(
                                                  Icons.play_arrow_rounded,
                                                  color: widget.dominantColor!
                                                              .computeLuminance() >
                                                          0.5
                                                      ? Colors.black
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
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
                                                shape: const CircleBorder(),
                                                elevation: 2,
                                                tooltip: context.loc.pause,
                                                backgroundColor:
                                                    widget.dominantColor,
                                                // Theme.of(context)
                                                //     .colorScheme
                                                //     .primary,
                                                onPressed:
                                                    widget.audioHandler.pause,
                                                child: Icon(
                                                  Icons.pause_rounded,
                                                  color: widget.dominantColor!
                                                              .computeLuminance() >
                                                          0.5
                                                      ? Colors.black
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                ),
                                              )
                                            : FloatingActionButton(
                                                shape: const CircleBorder(),
                                                elevation: 2,
                                                tooltip: context.loc.play,
                                                backgroundColor:
                                                    widget.dominantColor,
                                                // Theme.of(context)
                                                //     .colorScheme
                                                //     .primary,
                                                onPressed:
                                                    widget.audioHandler.play,
                                                child: Icon(
                                                  Icons.play_arrow_rounded,
                                                  color: widget.dominantColor!
                                                              .computeLuminance() >
                                                          0.5
                                                      ? Colors.black
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                );
                                // return ZoomTapAnimation(
                                //   begin: 1.0,
                                //   end: 0.9,
                                //   beginDuration:
                                //       const Duration(milliseconds: 20),
                                //   endDuration:
                                //       const Duration(milliseconds: 120),
                                //   beginCurve: Curves.decelerate,
                                //   endCurve: Curves.fastOutSlowIn,
                                //   child: Center(
                                //     child: SizedBox(
                                //       height: 59,
                                //       width: 59,
                                //       child: Center(
                                //         child: playing
                                //             ? FloatingActionButton(
                                //                 elevation: 10,
                                //                 tooltip: context.loc.pause,
                                //                 backgroundColor:
                                //                     Theme.of(context)
                                //                         .colorScheme
                                //                         .primary,
                                //                 onPressed:
                                //                     widget.audioHandler.pause,
                                //                 child: Icon(
                                //                   Icons.pause_rounded,
                                //                   color: Theme.of(context)
                                //                       .colorScheme
                                //                       .surface,
                                //                 ),
                                //               )
                                //             : FloatingActionButton(
                                //                 elevation: 10,
                                //                 tooltip: context.loc.play,
                                //                 backgroundColor:
                                //                     Theme.of(context)
                                //                         .colorScheme
                                //                         .primary,
                                //                 onPressed:
                                //                     widget.audioHandler.play,
                                //                 child: Icon(
                                //                   Icons.play_arrow_rounded,
                                //                   color: Theme.of(context)
                                //                       .colorScheme
                                //                       .surface,
                                //                 ),
                                //               ),
                                //       ),
                                //     ),
                                //   ),
                                // );
                              }
                            })
                    ],
                  );
                },
              ),
            );
          case 'Next':
            return StreamBuilder<QueueState>(
              stream: widget.audioHandler.queueState,
              builder: (context, snapshot) {
                final queueState = snapshot.data;

                if (!widget.miniplayer) {
                  isPlaying
                      ? widget.animationController!.forward()
                      : widget.animationController!.stop();
                }
                return Padding(
                  padding:
                      EdgeInsets.only(left: widget.miniplayer ? 0.0 : 16.0),
                  child: IconButton(
                    icon: const Icon(Icons.skip_next_rounded),
                    iconSize: widget.miniplayer ? 32.0 : 36.0,
                    tooltip: context.loc.skipNext,
                    color: Theme.of(context).colorScheme.onSurface,
                    onPressed: () {
                      if (queueState?.hasNext ?? true) {
                        widget.audioHandler.skipToNext().then(
                          (_) {
                            _resetAnimation();
                          },
                        );
                      } else {
                        return null;
                      }
                    },
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
