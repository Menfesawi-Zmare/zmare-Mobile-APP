import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:go_router/go_router.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/data/artist/model/artist.dart';
import 'package:zmare/src/presentation/widgets/zmare_image.dart';
import 'package:zmare/src/presentation/widgets/texts/zmare_title.dart';

import 'texts/zmare_subtitle.dart';

class ItemArtist extends StatelessWidget {
  const ItemArtist({super.key, required this.artists});
  final Artist artists;
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
                child: ClipOval(
                  child: ZmareImage(
                    imageUrl: artists.image!,
                    placeholderImage: Images.defalultArtistCover,
                  ),
                ),
              ),
            ],
          ),
          title: ZmareTitle(artists.name!),
          subtitle: ZmareSubTitle(
              '${artists.albumTotal} ${artists.albumTotal! > 1 ? context.loc.albums : context.loc.album} • ${artists.trackTotal} ${artists.trackTotal! > 1 ? context.loc.songs : context.loc.song}'),
          trailing: IconButton(
              onPressed: () => context.pushNamed(artistPath, extra: artists),
              icon: const Icon(FluentIcons.chevron_right_28_regular)),
          onTap: () => context.pushNamed(artistPath, extra: artists),
        ));
  }
}
