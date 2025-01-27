import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/utils/services/audio/player_service.dart';
import 'package:flutter_music_pro/src/data/song/model/item_song_model.dart';

class PlayAndShuffleButton extends StatelessWidget {
  const PlayAndShuffleButton({super.key, required this.songList});
  final List<ItemSongModel> songList;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0),
      child: Row(
        children: [
          Expanded(
              child: OutlinedButton.icon(
            onPressed: () {
              if (songList.isNotEmpty) {
                PlayerInvoke.init(
                  songsList: songList.map((e) => e.toJson()).toList(),
                  index: 0,
                  isOffline: false,
                  shuffle: false,
                );                
              }
            },
            icon: const Icon(
              Icons.play_arrow,
              color: Colors.black,
            ),
            label: Text(
              context.loc.playAll,
              style: context.titleSmall!.copyWith(color: Colors.black),
            ),
            style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Colors.transparent,
                ),
                shape: const StadiumBorder(),
                backgroundColor: Colors.white,
                visualDensity: const VisualDensity(vertical: 1)),
          )),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: OutlinedButton.icon(
            onPressed: () {
              if (songList.isNotEmpty) {
                PlayerInvoke.init(
                  songsList: songList.map((e) => e.toJson()).toList(),
                  index: 0,
                  isOffline: false,
                  shuffle: true,
                );                
              }
            },
            icon: const Icon(
              FluentIcons.arrow_shuffle_16_regular,
              color: Colors.white,
            ),
            label: Text(
              context.loc.shuffle,
              style: context.titleSmall!.copyWith(color: Colors.white),
            ),
            style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Colors.transparent,
                ),
                shape: const StadiumBorder(),
                backgroundColor: Colors.grey,
                visualDensity: const VisualDensity(vertical: 1)),
          )),
        ],
      ),
    );
  }
}
