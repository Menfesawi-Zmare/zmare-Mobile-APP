import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/core/resources/resources.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_music_pro/src/data/album/model/album.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_image.dart';
import 'package:flutter_music_pro/src/presentation/widgets/texts/khmertracks_title.dart';

class ItemProductionAlbum extends StatelessWidget {
  const ItemProductionAlbum({super.key, required this.item});
  final Album item;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () {
            context.pushNamed(albumSongsPath, extra: item);
          },
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: KhmertracksImage(
                  imageUrl: item.image!,
                  placeholderImage: Images.defalutAlbumCover,
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: KhmertracksTitle(
            item.name!,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
