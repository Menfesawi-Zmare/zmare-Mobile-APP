import 'package:flutter/material.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:go_router/go_router.dart';
import 'package:zmare/src/data/album/model/album.dart';
import 'package:zmare/src/presentation/widgets/zmare_image.dart';
import 'package:zmare/src/presentation/widgets/texts/zmare_title.dart';

class ItemArtistAlbum extends StatelessWidget {
  const ItemArtistAlbum({super.key, required this.item});
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
                child: ZmareImage(
                  imageUrl: item.image!,
                  placeholderImage: Images.defalutAlbumCover,
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: ZmareTitle(item.name!, maxLines: 1),
        ),
      ],
    );
  }
}
