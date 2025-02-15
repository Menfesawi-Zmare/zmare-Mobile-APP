import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/presentation/widgets/queue_control_bar.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/presentation/player/pages/audioplayer.dart';
import 'package:zmare/src/presentation/player/pages/now_play.dart';
import 'package:zmare/src/presentation/widgets/empty_screen.dart';
import 'package:zmare/src/service_locator.dart';
import 'package:glassmorphism/glassmorphism.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({super.key});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  final AudioPlayerHandler audioHandler = locator<AudioPlayerHandler>();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AudioPlayerHandler audioPlayerHandler = locator<AudioPlayerHandler>();
    return Scaffold(
      extendBody: true,
      appBar: context.materialYouAppBar(context.loc.nowPlaying),
      body: StreamBuilder<PlaybackState>(
        stream: audioHandler.playbackState,
        builder: (context, snapshot) {
          final playbackState = snapshot.data;
          final processingState = playbackState?.processingState;
          return Scaffold(
            appBar: processingState != AudioProcessingState.idle
                ? null
                : AppBar(
                    title: Text(context.loc.nowPlaying),
                    centerTitle: true,
                    elevation: 0,
                  ),
            body: processingState == AudioProcessingState.idle
                ? emptyScreen(
                    context,
                    3,
                    context.loc.nothingIs,
                    18.0,
                    context.loc.playingCap,
                    60,
                    context.loc.playSomething,
                    23.0,
                  )
                : StreamBuilder<MediaItem?>(
                    stream: audioHandler.mediaItem,
                    builder: (context, snapshot) {
                      final mediaItem = snapshot.data;
                      return mediaItem == null
                          ? const SizedBox()
                          : NowPlayingStream(
                              scrollController: _scrollController,
                              audioHandler: audioHandler,
                            );
                    },
                  ),
          );
        },
      ),
      bottomNavigationBar: GlassmorphicContainer(
        height: 107,
        width: MediaQuery.of(context).size.width,
        borderRadius: 0,
        blur: 25,
        alignment: Alignment.bottomCenter,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.titleMedium!.color!.withOpacity(0.1),
            context.titleMedium!.color!.withOpacity(0.05),
          ],
          stops: const [0.1, 1],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.titleMedium!.color!.withOpacity(0.5),
            context.titleMedium!.color!.withOpacity(0.5),
          ],
        ),
        border: 0,
        child: QueueControlBar(
            audioHandler: audioHandler, audioPlayerHandler: audioPlayerHandler),
      ),
    );
  }
}
