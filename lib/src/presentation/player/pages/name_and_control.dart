import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flip_card/flip_card.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:zmare/src/presentation/modal/modal_comment.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/utils/helper/lyrics.dart';
import 'package:zmare/src/utils/helper/mediaitem_converter.dart';
import 'package:zmare/src/data/song/model/item_song_model.dart';
import 'package:zmare/src/presentation/modal/modal_more.dart';
import 'package:zmare/src/presentation/player/pages/audioplayer.dart';
import 'package:zmare/src/presentation/widgets/animated_text.dart';
import 'package:zmare/src/presentation/widgets/download_button.dart';
import 'package:zmare/src/presentation/widgets/like_button.dart';
import 'package:zmare/src/presentation/widgets/seek_bar.dart';
import 'package:zmare/src/presentation/widgets/textinput_dialog.dart';
import 'package:rxdart/rxdart.dart';

class NameNControls extends StatelessWidget {
  final GlobalKey<FlipCardState> cardKey;
  final MediaItem mediaItem;
  final bool offline;
  final AnimationController? animationController;
  final double width;
  final double height;
  final AudioPlayerHandler audioHandler;
  final VoidCallback openPlayList;
  final bool playistOpened;
  final Color dominantColor;

  const NameNControls({
    super.key,
    required this.cardKey,
    required this.dominantColor,
    required this.width,
    required this.height,
    required this.mediaItem,
    required this.openPlayList,
    required this.audioHandler,
    this.offline = false,
    required this.animationController,
    required this.playistOpened,
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
    Duration? time;
    final double titleBoxHeight = height * 0.25;
    final double seekBoxHeight = height > 500 ? height * 0.15 : height * 0.2;
    final double controlBoxHeight = offline
        ? height > 500
            ? height * 0.2
            : height * 0.25
        : (height < 350
            ? height * 0.4
            : height > 500
                ? height * 0.2
                : height * 0.3);
    final double nowplayingBoxHeight = min(70, height * 0.15);
    return SizedBox(
      width: width,
      height: playistOpened ? height * 1.2 : height,
      child: Stack(
        children: [
          Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 10.0,
              ),

              /// Title and subtitle
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (playistOpened &&
                        MediaQuery.of(context).orientation ==
                            Orientation.portrait)
                      SizedBox.shrink()
                    else
                      Expanded(
                        child: AnimatedText(
                          text: mediaItem.title
                              .split(' (')[0]
                              .split('|')[0]
                              .trim(),
                          pauseAfterRound: const Duration(seconds: 3),
                          showFadingOnlyWhenScrolling: true,
                          fadingEdgeEndFraction: 0.1,
                          fadingEdgeStartFraction: 0.1,
                          startAfter: const Duration(seconds: 2),
                          defaultAlignment: TextAlign.left,
                          style: context.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Washera',
                          ),
                        ),
                      ),
                    if (audioHandler.mediaItem.value!.artUri
                            .toString()
                            .startsWith('http') &&
                        !playistOpened)
                      IconButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0),
                              ),
                            ),
                            builder: (context) => ModalMore(
                                offline: offline,
                                isPlayingPage: true,
                                songList: ItemSongModel(
                                    id: int.parse(
                                        audioHandler.mediaItem.value!.id),
                                    image: audioHandler.mediaItem.value!.artUri
                                        .toString(),
                                    album: audioHandler.mediaItem.value!.album,
                                    albumCover: audioHandler.mediaItem.value!
                                        .extras?['album_cover'],
                                    albumId: offline == true
                                        ? int.parse(audioHandler.mediaItem
                                            .value!.extras?['album_id'])
                                        : audioHandler.mediaItem.value!
                                            .extras?['album_id'],
                                    title: audioHandler.mediaItem.value!.title,
                                    artist:
                                        audioHandler.mediaItem.value!.artist,
                                    artistId: audioHandler
                                        .mediaItem.value!.extras?['artist_id'],
                                    url: audioHandler.mediaItem.value!.extras?['url'],
                                    link: audioHandler.mediaItem.value!.extras?['link'])),
                          );
                        },
                        icon: const Icon(FluentIcons.more_vertical_24_regular),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                  ],
                ),
              ),

              if (playistOpened &&
                  MediaQuery.of(context).orientation == Orientation.portrait)
                SizedBox.shrink()
              else
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 1.0),
                  child: AnimatedText(
                      text: (mediaItem.album ?? '').isEmpty
                          ? '${(mediaItem.artist ?? "").isEmpty ? "Unknown" : mediaItem.artist}'
                          : '${(mediaItem.artist ?? "").isEmpty ? "Unknown" : mediaItem.artist} • ${mediaItem.album}',
                      pauseAfterRound: const Duration(seconds: 3),
                      showFadingOnlyWhenScrolling: false,
                      fadingEdgeEndFraction: 0.1,
                      defaultAlignment: TextAlign.left,
                      fadingEdgeStartFraction: 0.1,
                      startAfter: const Duration(seconds: 2),
                      style: context.bodyLarge?.copyWith(
                        color: context.bodySmall!.color,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Washera',
                      )),
                ),
              SizedBox(
                height: 13.0,
              ),
              SizedBox(
                width: width * 0.97,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder<String>(
                        future: offline
                            ? Lyrics.getOffLyrics(
                                mediaItem.extras!['url'].toString())
                            : null,
                        builder: (context, snapshot) {
                          return Visibility(
                            visible: snapshot.data != null &&
                                    snapshot.data!.isNotEmpty ||
                                audioHandler.mediaItem.value!
                                            .extras?['lyrics'] !=
                                        null &&
                                    audioHandler.mediaItem.value!
                                            .extras?['lyrics'] !=
                                        '',
                            child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        onPressed: () =>
                                            cardKey.currentState!.toggleCard(),
                                        icon: const Icon(Icons.lyrics_outlined,
                                            size: 25),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ])),
                          );
                        }),
                    if (!offline) LikeButton(mediaItem: mediaItem, size: 25.0),
                    IconButton(
                        onPressed: openPlayList,
                        icon: Icon(
                          Icons.queue_music_outlined,
                          size: 25,
                        ))
                  ],
                ),
              ),

              /// Seekbar starts from here
              SizedBox(
                // height: seekBoxHeight,
                width: width * 0.9,
                child: StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      dominantColor: dominantColor,
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                          positionData?.bufferedPosition ?? Duration.zero,
                      offline: offline,
                      onChangeEnd: (newPosition) {
                        audioHandler.seek(newPosition);
                      },
                      audioHandler: audioHandler,
                    );
                  },
                ),
              ),

              /// Final row starts from here
              SizedBox(
                // height: controlBoxHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Center(
                    child: SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              StreamBuilder<AudioServiceRepeatMode>(
                                stream: audioHandler.playbackState
                                    .map((state) => state.repeatMode)
                                    .distinct(),
                                builder: (context, snapshot) {
                                  final repeatMode = snapshot.data ??
                                      AudioServiceRepeatMode.none;
                                  const texts = ['None', 'All', 'One'];
                                  final icons = [
                                    Icon(
                                      FluentIcons.arrow_repeat_all_16_regular,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                    Icon(
                                      FluentIcons.arrow_repeat_all_16_filled,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                    Icon(
                                      FluentIcons.arrow_repeat_1_16_filled,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ];
                                  const cycleModes = [
                                    AudioServiceRepeatMode.none,
                                    AudioServiceRepeatMode.all,
                                    AudioServiceRepeatMode.one,
                                  ];
                                  final index = cycleModes.indexOf(repeatMode);
                                  return IconButton(
                                    icon: icons[index],
                                    tooltip:
                                        'Repeat ${texts[(index + 1) % texts.length]}',
                                    onPressed: () async {
                                      await Hive.box(BoxType.player.name).put(
                                        playerRepeatMode,
                                        texts[(index + 1) % texts.length],
                                      );
                                      await audioHandler.setRepeatMode(
                                        cycleModes[
                                            (cycleModes.indexOf(repeatMode) +
                                                    1) %
                                                cycleModes.length],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          ControlButtons(
                            dominantColor: dominantColor,
                            animationController: animationController,
                            audioHandler,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              StreamBuilder<bool>(
                                stream: audioHandler.playbackState
                                    .map(
                                      (state) =>
                                          state.shuffleMode ==
                                          AudioServiceShuffleMode.all,
                                    )
                                    .distinct(),
                                builder: (context, snapshot) {
                                  final shuffleModeEnabled =
                                      snapshot.data ?? false;
                                  return IconButton(
                                    icon: shuffleModeEnabled
                                        ? Icon(
                                            FluentIcons.arrow_shuffle_16_filled,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          )
                                        : Icon(
                                            FluentIcons
                                                .arrow_shuffle_16_regular,
                                            color:
                                                Theme.of(context).disabledColor,
                                          ),
                                    tooltip: context.loc.shuffle,
                                    onPressed: () async {
                                      final enable = !shuffleModeEnabled;
                                      await audioHandler.setShuffleMode(
                                        enable
                                            ? AudioServiceShuffleMode.all
                                            : AudioServiceShuffleMode.none,
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: playistOpened
              //       ? nowplayingBoxHeight + 97
              //       : nowplayingBoxHeight,
              // ),
            ],
          ),
          // FutureBuilder<String>(
          //     future: offline
          //         ? Lyrics.getOffLyrics(mediaItem.extras!['url'].toString())
          //         : null,
          //     builder: (context, snapshot) {
          //       return Visibility(
          //         visible: snapshot.data != null && snapshot.data!.isNotEmpty ||
          //             audioHandler.mediaItem.value!.extras?['lyrics'] != null &&
          //                 audioHandler.mediaItem.value!.extras?['lyrics'] != '',
          //         child: Align(
          //             alignment: Alignment.bottomLeft,
          //             child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.start,
          //                 children: [
          //                   IconButton(
          //                     padding:
          //                         const EdgeInsets.symmetric(horizontal: 16),
          //                     onPressed: () =>
          //                         cardKey.currentState!.toggleCard(),
          //                     icon: const Icon(FluentIcons.subtitles_24_regular,
          //                         size: 28),
          //                     color: Theme.of(context).colorScheme.secondary,
          //                   ),
          //                 ])),
          //       );
          //     }),
          if (playistOpened)
            SizedBox.shrink()
          else
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!offline && mediaItem.extras!['download'] == true)
                    DownloadButton(
                      size: 24.0,
                      data: MediaItemConverter.mediaItemToMap(
                        mediaItem,
                      ),
                    ),
                  if (!offline)
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                          return ModalComment(
                              track: ItemSongModel(
                                  id: int.parse(
                                      audioHandler.mediaItem.value!.id),
                                  image: audioHandler.mediaItem.value!.artUri
                                      .toString(),
                                  album: audioHandler.mediaItem.value!.album,
                                  albumCover: audioHandler
                                      .mediaItem.value!.extras?['album_cover'],
                                  albumId: offline == true
                                      ? int.parse(audioHandler
                                          .mediaItem.value!.extras?['album_id'])
                                      : audioHandler
                                          .mediaItem.value!.extras?['album_id'],
                                  title: audioHandler.mediaItem.value!.title,
                                  artist: audioHandler.mediaItem.value!.artist,
                                  artistId: audioHandler
                                      .mediaItem.value!.extras?['artist_id'],
                                  url: audioHandler
                                      .mediaItem.value!.extras?['url']));
                        }));
                      },
                      icon: const Icon(FluentIcons.comment_24_regular),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  // if (!offline) LikeButton(mediaItem: mediaItem, size: 24.0),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            title: Text(
                              context.loc.sleepTimer,
                              style: context.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            contentPadding: const EdgeInsets.all(10.0),
                            children: [
                              const Divider(),
                              ListTile(
                                title: Text(
                                  context.loc.sleepDur,
                                  style: context.bodyLarge,
                                ),
                                subtitle: Text(
                                  context.loc.sleepDurSub,
                                  style: context.bodySmall,
                                ),
                                dense: true,
                                onTap: () {
                                  Navigator.pop(context);
                                  setTimer(
                                    context,
                                    time,
                                  );
                                },
                              ),
                              ListTile(
                                title: Text(
                                  context.loc.sleepAfter,
                                  style: context.bodyLarge,
                                ),
                                subtitle: Text(context.loc.sleepAfterSub,
                                    style: context.bodySmall),
                                dense: true,
                                isThreeLine: true,
                                onTap: () {
                                  Navigator.pop(context);
                                  setCounter(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(FluentIcons.sleep_20_regular),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  // if (audioHandler.mediaItem.value!.artUri
                  //     .toString()
                  //     .startsWith('http'))
                  //   IconButton(
                  //     onPressed: () {
                  //       HapticFeedback.mediumImpact();
                  //       showModalBottomSheet(
                  //         context: context,
                  //         shape: const RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.vertical(
                  //             top: Radius.circular(25.0),
                  //           ),
                  //         ),
                  //         builder: (context) => ModalMore(
                  //             offline: offline,
                  //             isPlayingPage: true,
                  //             songList: ItemSongModel(
                  //                 id: int.parse(audioHandler.mediaItem.value!.id),
                  //                 image: audioHandler.mediaItem.value!.artUri
                  //                     .toString(),
                  //                 album: audioHandler.mediaItem.value!.album,
                  //                 albumCover: audioHandler
                  //                     .mediaItem.value!.extras?['album_cover'],
                  //                 albumId: offline == true
                  //                     ? int.parse(audioHandler
                  //                         .mediaItem.value!.extras?['album_id'])
                  //                     : audioHandler
                  //                         .mediaItem.value!.extras?['album_id'],
                  //                 title: audioHandler.mediaItem.value!.title,
                  //                 artist: audioHandler.mediaItem.value!.artist,
                  //                 artistId: audioHandler
                  //                     .mediaItem.value!.extras?['artist_id'],
                  //                 url: audioHandler
                  //                     .mediaItem.value!.extras?['url'],
                  //                 link: audioHandler
                  //                     .mediaItem.value!.extras?['link'])),
                  //       );
                  //     },
                  //     icon: const Icon(FluentIcons.more_vertical_24_regular),
                  //     color: Theme.of(context).colorScheme.secondary,
                  //   )
                ],
              ),
            )
        ],
      ),
    );
  }

  Future<dynamic> setCounter(BuildContext context) async {
    await showTextInputDialog(
      context: context,
      title: context.loc.enterSongsCount,
      initialText: '',
      keyboardType: TextInputType.number,
      onSubmitted: (String value) {
        sleepCounter(
          int.parse(value),
        );
        context.pop();
        context.showMaterialSnackBar(
            '${context.loc.sleepTimerSetFor} $value ${context.loc.songs}');
      },
    );
  }

  void sleepTimer(int time) {
    audioHandler.customAction('sleepTimer', {'time': time});
  }

  void sleepCounter(int count) {
    audioHandler.customAction('sleepCounter', {'count': count});
  }

  Future<dynamic> setTimer(
    BuildContext context,
    Duration? time,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Center(
            child: Text(
              context.loc.selectDur,
              style: context.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          children: [
            Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    primaryColor: Theme.of(context).colorScheme.secondary,
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  child: CupertinoTimerPicker(
                    mode: CupertinoTimerPickerMode.hm,
                    onTimerDurationChanged: (value) {
                      time = value;
                    },
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    sleepTimer(0);
                    Navigator.pop(context);
                  },
                  child: Text(context.loc.cancel),
                ),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    sleepTimer(time!.inMinutes);
                    Navigator.pop(context);
                    context.showMaterialSnackBar(
                        '${context.loc.sleepTimerSetFor} ${time!.inMinutes} ${context.loc.minutes}');
                  },
                  child: Text(context.loc.ok,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary)),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
