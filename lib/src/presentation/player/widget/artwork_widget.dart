import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:zmare/src/presentation/player/lyric/lyric_ui.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/utils/helper/lyrics.dart';
import 'package:zmare/src/presentation/player/pages/audioplayer.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_text.dart';
import 'package:logging/logging.dart';

class ArtWorkWidget extends StatefulWidget {
  final GlobalKey<FlipCardState> cardKey;
  final MediaItem mediaItem;
  final bool offline;
  final double width;
  final AudioPlayerHandler audioHandler;

  const ArtWorkWidget({
    super.key,
    required this.cardKey,
    required this.mediaItem,
    required this.width,
    this.offline = false,
    required this.audioHandler,
  });

  @override
  State<ArtWorkWidget> createState() => _ArtWorkWidgetState();
}

class _ArtWorkWidgetState extends State<ArtWorkWidget> {
  final ValueNotifier<bool> dragging = ValueNotifier<bool>(false);
  final ValueNotifier<bool> tapped = ValueNotifier<bool>(false);
  final ValueNotifier<int> doubletapped = ValueNotifier<int>(0);
  final ValueNotifier<bool> done = ValueNotifier<bool>(false);
  //Lyric
  Map lyrics = {'id': '', 'lyrics': ''};
  bool flipped = false;

  void fetchLyrics() {
    Logger.root.info('Fetching lyrics for ${widget.mediaItem.title}');
    done.value = false;
    if (widget.offline) {
      Lyrics.getOffLyrics(
        widget.mediaItem.extras!['url'].toString(),
      ).then((value) {
        Logger.root.info('Fetching lyrics for1 $value');
        if (value == '') {
          lyrics['id'] = widget.mediaItem.id;
          lyrics['lyrics'] = widget.mediaItem.extras?['lyrics'];
          done.value = true;
        } else {
          Logger.root.info('Lyrics found offline');
          lyrics['id'] = widget.mediaItem.id;
          lyrics['lyrics'] = value;
          done.value = true;
        }
      });
    } else {
      lyrics['id'] = widget.mediaItem.id;
      if (widget.mediaItem.extras?['lyrics'] != null) {
        Lyrics.downloadLyric(widget.mediaItem.extras?['lyrics'],
                '${widget.mediaItem.id}.lrc')
            .then((value) {
          value.readAsString().then((e) {
            lyrics['lyrics'] = e;
            done.value = true;
          });
        });
      } else {
        lyrics['lyrics'] = '';
        done.value = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var lyricUI = FlutterMusicProLyricUI(
        textStyle: context.titleMedium,
        highlight: false,
        defaultSize: 22.0,
        defaultExtSize: 20.0,
        lyricBaseLine: LyricBaseLine.CENTER,
        lyricAlign: LyricAlign.LEFT);

    if (flipped && lyrics['id'] != widget.mediaItem.id) {
      fetchLyrics();
    }
    return SizedBox(
      height: widget.width * 0.95,
      width: widget.width * 0.95,
      child: Hero(
        tag: 'currentArtwork',
        child: FlipCard(
          key: widget.cardKey,
          flipOnTouch: false,
          onFlipDone: (value) {
            flipped = value;
            if (flipped && lyrics['id'] != widget.mediaItem.id) {
              fetchLyrics();
            }
          },
          back: GestureDetector(
            onTap: () => widget.cardKey.currentState!.toggleCard(),
            onDoubleTap: () => widget.cardKey.currentState!.toggleCard(),
            child: Stack(
              children: [
                ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black,
                        Colors.black,
                        Colors.black,
                        Colors.transparent
                      ],
                    ).createShader(
                      Rect.fromLTRB(0, 0, rect.width, rect.height),
                    );
                  },
                  blendMode: BlendMode.dstIn,
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 20,
                      ),
                      child: ValueListenableBuilder(
                          valueListenable: done,
                          child: const CircularProgressIndicator(),
                          builder: (
                            BuildContext context,
                            bool value,
                            Widget? child,
                          ) {
                            return value
                                ? lyrics['lyrics'] == '' ||
                                        lyrics['lyrics'] == null
                                    ? SizedBox(
                                        width: widget.width * 0.9,
                                        height: widget.width * 0.9,
                                        child: Center(
                                          child: KhmertracksText(
                                              text: context.loc.noLyrics),
                                        ),
                                      )
                                    : StreamBuilder<Duration>(
                                        stream: AudioService.position,
                                        builder: (context, snapshot) {
                                          final position =
                                              snapshot.data ?? Duration.zero;
                                          return LayoutBuilder(
                                              builder: (context, constraints) {
                                            return LyricsReader(
                                              padding: EdgeInsets.zero,
                                              model: LyricsModelBuilder.create()
                                                  .bindLyricToMain(
                                                      lyrics['lyrics'])
                                                  .getModel(),
                                              position: position.inMilliseconds,
                                              lyricUi: lyricUI,
                                              playing: true,
                                              size: Size(
                                                widget.width * 0.9,
                                                widget.width * 0.9,
                                              ),
                                              emptyBuilder: () => SizedBox(
                                                width: widget.width * 0.9,
                                                height: widget.width * 0.9,
                                                child: Center(
                                                  child: KhmertracksText(
                                                      text:
                                                          context.loc.noLyrics),
                                                ),
                                              ),
                                            );
                                          });
                                        })
                                : child!;
                          }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          front: StreamBuilder<QueueState>(
            stream: widget.audioHandler.queueState,
            builder: (context, snapshot) {
              final bool enabled = Hive.box(BoxType.player.name)
                  .get('enableGesture', defaultValue: true) as bool;
              return GestureDetector(
                onTap: !enabled
                    ? null
                    : () {
                        tapped.value = true;
                        Future.delayed(const Duration(seconds: 2), () async {
                          tapped.value = false;
                        });
                      },
                onDoubleTapDown: (details) {
                  if (details.globalPosition.dx <= widget.width * 2 / 5) {
                    widget.audioHandler.customAction('rewind');
                    doubletapped.value = -1;
                    Future.delayed(const Duration(milliseconds: 500), () async {
                      doubletapped.value = 0;
                    });
                  }
                  if (details.globalPosition.dx > widget.width * 2 / 5 &&
                      details.globalPosition.dx < widget.width * 3 / 5) {
                    widget.cardKey.currentState!.toggleCard();
                  }
                  if (details.globalPosition.dx >= widget.width * 3 / 5) {
                    widget.audioHandler.customAction('fastForward');
                    doubletapped.value = 1;
                    Future.delayed(const Duration(milliseconds: 500), () async {
                      doubletapped.value = 0;
                    });
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Card(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child:
                          widget.mediaItem.artUri.toString().startsWith('file')
                              ? Image(
                                  fit: BoxFit.cover,
                                  width: widget.width * 0.92,
                                  height: widget.width * 0.92,
                                  gaplessPlayback: true,
                                  errorBuilder: (
                                    BuildContext context,
                                    Object exception,
                                    StackTrace? stackTrace,
                                  ) {
                                    return const Image(
                                      fit: BoxFit.cover,
                                      image: AssetImage(Images.defalutCover),
                                    );
                                  },
                                  image: FileImage(
                                    File(
                                      widget.mediaItem.artUri!.toFilePath(),
                                    ),
                                  ),
                                )
                              : CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  errorWidget: (BuildContext context, _, __) =>
                                      const Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage(Images.defalutCover),
                                  ),
                                  placeholder: (BuildContext context, _) =>
                                      const Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage(Images.defalutCover),
                                  ),
                                  imageUrl: widget.mediaItem.artUri.toString(),
                                  width: widget.width * 0.92,
                                  height: widget.width * 0.92,
                                ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: doubletapped,
                      child: const Icon(
                        Icons.forward_10_rounded,
                        size: 60.0,
                      ),
                      builder: (
                        BuildContext context,
                        int value,
                        Widget? child,
                      ) {
                        return Visibility(
                          visible: value != 0,
                          child: Card(
                            color: Colors.transparent,
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22.0),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: SizedBox.expand(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: value == 1
                                        ? [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.4),
                                            Colors.black.withOpacity(0.7),
                                          ]
                                        : [
                                            Colors.black.withOpacity(0.7),
                                            Colors.black.withOpacity(0.4),
                                            Colors.transparent,
                                          ],
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Visibility(
                                      visible: value == -1,
                                      child: const Icon(
                                        Icons.replay_10_rounded,
                                        size: 60.0,
                                      ),
                                    ),
                                    const SizedBox(),
                                    Visibility(
                                      visible: value == 1,
                                      child: child!,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
