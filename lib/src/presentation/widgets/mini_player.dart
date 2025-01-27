import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/core/resources/resources.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_image.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_music_pro/src/core/enum/box_types.dart';
import 'package:flutter_music_pro/src/presentation/player/pages/audioplayer.dart';
import 'package:flutter_music_pro/src/presentation/widgets/animated_text.dart';
import 'package:flutter_music_pro/src/service_locator.dart';

class MiniPlayer extends StatefulWidget {
  static const MiniPlayer _instance = MiniPlayer._internal();

  factory MiniPlayer() {
    return _instance;
  }

  const MiniPlayer._internal();

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  AudioPlayerHandler audioHandler = locator<AudioPlayerHandler>();
  Box<dynamic> playerSettings = locator.get(
    instanceName: BoxType.settings.name,
  );
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: audioHandler.playbackState,
      builder: (context, snapshot) {
        return StreamBuilder<MediaItem?>(
          stream: audioHandler.mediaItem,
          builder: (context, snapshot) {
            final MediaItem? mediaItem = snapshot.data;
            if (snapshot.connectionState != ConnectionState.active) {
              return const SizedBox();
            }
            if (mediaItem == null) return const SizedBox();
            final bool isLocal =
                mediaItem.artUri?.toString().startsWith('file:') ?? false;
            return ValueListenableBuilder(
              valueListenable: playerSettings.listenable(),
              builder: (BuildContext context, Box box1, Widget? child) {
                final bool extraControls =
                    box1.get(extraControlsKey, defaultValue: false);
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 0.0,
                    vertical: 0.0,
                  ),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12))),
                  elevation: 2,
                  child: SizedBox(
                    height: 60,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (_, __, ___) => const PlayScreen(),
                              ),
                            );
                          },
                          title: AnimatedText(
                              text: '${mediaItem.title} • ${mediaItem.artist}',
                              pauseAfterRound: const Duration(seconds: 3),
                              defaultAlignment: TextAlign.left,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              showFadingOnlyWhenScrolling: false,
                              fadingEdgeEndFraction: 0.1,
                              fadingEdgeStartFraction: 0.1,
                              style: context.titleMedium),
                          leading: Hero(
                            tag: 'currentArtwork',
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 5),
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: isLocal
                                    ? SizedBox.square(
                                        dimension: 40.0,
                                        child: Image(
                                          fit: BoxFit.cover,
                                          image: FileImage(
                                            File(
                                                mediaItem.artUri!.toFilePath()),
                                          ),
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Image(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  Images.defalutCover),
                                            );
                                          },
                                        ),
                                      )
                                    : SizedBox.square(
                                        dimension: 40,
                                        child: KhmertracksImage(
                                            imageUrl:
                                                mediaItem.artUri.toString(),
                                            placeholderImage:
                                                Images.defalutCover)),
                              ),
                            ),
                          ),
                          trailing: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: extraControls ? 0 : 10),
                            child: ControlButtons(audioHandler,
                                miniplayer: true,
                                buttons: extraControls
                                    ? ['Previous', 'Play/Pause', 'Next']
                                    : ['Play/Pause']),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
