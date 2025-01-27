import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/core/resources/resources.dart';
import 'package:flutter_music_pro/src/data/playlist/model/playlist.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_image.dart';
import 'package:flutter_music_pro/src/presentation/widgets/texts/khmertracks_title.dart';

class ItemExplorerPlaylist extends StatelessWidget {
  const ItemExplorerPlaylist({super.key, required this.playlist});
  final Playlist playlist;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(viewPlaylistsPath,
          extra: playlist, pathParameters: {'action': 'false'}),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1 / 1,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: KhmertracksImage(
                  imageUrl: playlist.image!,
                  placeholderImage: Images.defalutCover,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: KhmertracksTitle(
              playlist.name!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
