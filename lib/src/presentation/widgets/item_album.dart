import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/core/resources/resources.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/data/album/model/album.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_image.dart';
import 'package:flutter_music_pro/src/presentation/widgets/texts/khmertracks_subTitle.dart';
import 'package:flutter_music_pro/src/presentation/widgets/texts/khmertracks_title.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ItemAlbum extends StatelessWidget {
  const ItemAlbum({super.key, required this.album});
  final Album album;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.zero,
        child: ListTile(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            dense: true,
            contentPadding: const EdgeInsets.only(left: 10.0, right: 0.0),
            visualDensity: const VisualDensity(vertical: 4),
            horizontalTitleGap: 10.0,
            minVerticalPadding: 0,
            leading: Column(
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: KhmertracksImage(
                        imageUrl: album.image!,
                        placeholderImage: Images.defalutAlbumCover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            title: KhmertracksTitle(album.name!),
            subtitle: KhmertracksSubTitle(
                '${album.trackTotal} ${album.trackTotal! > 1 ? context.loc.songs : context.loc.song}'),
            trailing: IconButton(
                onPressed: () =>
                    context.pushNamed(albumSongsPath, extra: album),
                icon: Icon(MdiIcons.chevronRight)),
            onTap: () => context.pushNamed(albumSongsPath, extra: album)));
  }
}
