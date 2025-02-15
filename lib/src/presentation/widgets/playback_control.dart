import 'package:audio_service/audio_service.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/presentation/player/pages/audioplayer.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:hive/hive.dart';

class PlaybackControl extends StatelessWidget {
  const PlaybackControl(
      {super.key,
      required this.audioHandler,
      required this.audioPlayerHandler});
  final AudioHandler audioHandler;
  final AudioPlayerHandler audioPlayerHandler;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StreamBuilder<AudioServiceRepeatMode>(
          stream: audioHandler.playbackState
              .map((state) => state.repeatMode)
              .distinct(),
          builder: (context, snapshot) {
            final repeatMode = snapshot.data ?? AudioServiceRepeatMode.none;
            const texts = ['None', 'All', 'One'];
            final icons = [
              Icon(
                FluentIcons.arrow_repeat_all_16_regular,
                color: Theme.of(context).disabledColor,
              ),
              Icon(
                FluentIcons.arrow_repeat_all_16_filled,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              Icon(
                FluentIcons.arrow_repeat_1_16_filled,
                color: Theme.of(context).colorScheme.onSurface,
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
              tooltip: 'Repeat ${texts[(index + 1) % texts.length]}',
              onPressed: () async {
                await Hive.box(BoxType.player.name).put(
                  playerRepeatMode,
                  texts[(index + 1) % texts.length],
                );
                await audioHandler.setRepeatMode(
                  cycleModes[
                      (cycleModes.indexOf(repeatMode) + 1) % cycleModes.length],
                );
              },
            );
          },
        ),
        ControlButtons(
          audioPlayerHandler,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<bool>(
              stream: audioHandler.playbackState
                  .map(
                    (state) => state.shuffleMode == AudioServiceShuffleMode.all,
                  )
                  .distinct(),
              builder: (context, snapshot) {
                final shuffleModeEnabled = snapshot.data ?? false;
                return IconButton(
                  icon: shuffleModeEnabled
                      ? Icon(
                          FluentIcons.arrow_shuffle_16_filled,
                          color: Theme.of(context).colorScheme.onSurface,
                        )
                      : Icon(
                          FluentIcons.arrow_shuffle_16_regular,
                          color: Theme.of(context).disabledColor,
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
    );
  }
}
