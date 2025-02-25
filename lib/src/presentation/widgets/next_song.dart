import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/presentation/library/pages/nowplaying.dart';
import 'package:zmare/src/presentation/player/pages/audioplayer.dart';
import 'package:zmare/src/utils/ext/common.dart';

class NextSong extends StatelessWidget {
  const NextSong({super.key, required this.audioHandler});
  final AudioPlayerHandler audioHandler;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QueueState>(
        stream: audioHandler.queueState,
        builder: (context, snapshot) {
          final queueState = snapshot.data ?? QueueState.empty;
          final queue = queueState.queue;
          final int queueStateIndex = queueState.queueIndex ?? 0;
          MediaItem? song;
          if (queueState.hasNext) {
            song = queue[queueStateIndex + 1];
            return GestureDetector(
              onTap: () => {
                // Navigator.of(context).push(MaterialPageRoute<void>(
                //     builder: (BuildContext context) {
                //       return const NowPlaying();
                //     },
                //     fullscreenDialog: true))
              },
              child: Container(
                height: 56.0,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      context.loc.upNext.toUpperCase(),
                      style: context.bodySmall,
                    ),
                    Container(
                      width: 170,
                      // color: Colors.black,
                      child: RichText(
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade,
                        text: TextSpan(
                          style: context.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w200),
                          children: [
                            TextSpan(
                              text: song.title,
                              style: context.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w300),
                            ),
                            const TextSpan(text: ' • '),
                            TextSpan(
                              text: song.artist,
                              style: context.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}
