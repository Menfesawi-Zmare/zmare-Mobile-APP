import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/presentation/player/pages/audioplayer.dart';
import 'package:flutter_music_pro/src/presentation/widgets/playback_control.dart';
import 'package:flutter_music_pro/src/utils/ext/color_extension.dart';
import 'package:rxdart/rxdart.dart';

class QueueControlBar extends StatelessWidget {
  const QueueControlBar(
      {super.key,
      required this.audioHandler,
      required this.audioPlayerHandler});
  final AudioHandler audioHandler;
  final AudioPlayerHandler audioPlayerHandler;

  Stream<Duration> get _bufferedPositionStream => audioHandler.playbackState
      .map((state) => state.bufferedPosition)
      .distinct();

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        AudioService.position,
        _bufferedPositionStream,
        audioPlayerHandler.durationState,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
        stream: audioHandler.mediaItem,
        builder: (context, snapshot) {
          final mediaItem = snapshot.data;
          return mediaItem == null
              ? const SizedBox()
              : Column(
                  verticalDirection: VerticalDirection.up,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                      child: PlaybackControl(
                          audioHandler: audioHandler,
                          audioPlayerHandler: audioPlayerHandler),
                      // child: Text('Controller'),
                    ),
                    StreamBuilder<PositionData>(
                        stream: _positionDataStream,
                        builder: (context, snapshot) {
                          final positionData = snapshot.data ??
                              PositionData(
                                  Duration.zero, Duration.zero, Duration.zero);
                          return SizedBox(
                            height: 2,
                            child: LinearProgressIndicator(
                              value: (positionData.position.inSeconds /
                                      positionData.duration.inSeconds)
                                  .clamp(0.001, 1),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  context.colorScheme.primary),
                              backgroundColor: context
                                  .colorScheme.primaryContainer
                                  .withAlpha(120),
                            ),
                          );
                        }),
                  ],
                );
        });
  }
}
