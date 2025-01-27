import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/core/resources/resources.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/core/enum/playlist_privacy_type.dart';
import 'package:flutter_music_pro/src/utils/ext/string_extensions.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_image.dart';
import 'package:flutter_music_pro/src/presentation/widgets/texts/khmertracks_title.dart';

import '../../data/playlist/model/playlist.dart';

class ItemPlaylist extends StatelessWidget {
  const ItemPlaylist({super.key, required this.playlist, this.action = false});
  final Playlist playlist;
  final bool action;
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
                        imageUrl: playlist.image!,
                        placeholderImage: Images.defalutCover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            title: KhmertracksTitle(playlist.name!),
            subtitle: RichText(
              text: TextSpan(
                children: [
                  if (action)
                    TextSpan(
                      children: [
                        WidgetSpan(
                          child: playlist.public! == 1
                              ? Icon(
                                  FluentIcons.globe_24_regular,
                                  size: 16,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .color,
                                )
                              : Icon(FluentIcons.lock_closed_24_regular,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .color,
                                  size: 16),
                        ),
                        TextSpan(
                            text:
                                ' ${PlaylistPrivacyType.values.firstWhere((e) => e.toIndex == playlist.public!).name(context)}  • ',
                            style: context.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w400)),
                      ],
                    )
                  else
                    const TextSpan(),
                  TextSpan(
                      text:
                          '${playlist.trackTotal} ${playlist.trackTotal! > 1 ? context.loc.songs : context.loc.song} ${!action ? ' • ${playlist.ownerName.toString().capitalize()}' : ""} ',
                      style: context.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w400)),
                ],
              ),
            ),
            trailing: IconButton(
                onPressed: () => context.pushNamed(viewPlaylistsPath,
                    extra: playlist, pathParameters: {'action': '$action'}),
                icon: const Icon(FluentIcons.chevron_right_28_regular)),
            onTap: () => context.pushNamed(viewPlaylistsPath,
                extra: playlist, pathParameters: {'action': '$action'})));
  }
}
