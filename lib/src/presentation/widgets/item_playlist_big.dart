import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:go_router/go_router.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/playlist_privacy_type.dart';
import 'package:zmare/src/utils/ext/string_extensions.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_image.dart';
import 'package:zmare/src/presentation/widgets/texts/khmertracks_title.dart';

import '../../data/playlist/model/playlist.dart';

class ItemPlaylistBig extends StatelessWidget {
  const ItemPlaylistBig(
      {super.key, required this.playlist, this.action = false});
  final Playlist playlist;
  final bool action;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.zero,
        child: ListTile(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            contentPadding:
                const EdgeInsets.only(left: 16.0, right: 0.0, bottom: 10),
            visualDensity: const VisualDensity(vertical: 4, horizontal: 0),
            leading: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: SizedBox(
                    width: 140,
                    height: 72,
                    child: Stack(children: [
                      SizedBox(
                        width: 140,
                        child: KhmertracksImage(
                          imageUrl: playlist.image!,
                          placeholderImage: Images.defalutCover,
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 140,
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3)),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2, bottom: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.playlist_play_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  Text(playlist.trackTotal!.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: context.bodySmall?.copyWith(
                                          fontWeight: FontWeight.w600))
                                ],
                              ),
                            ),
                          )),
                    ]),
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
                            style: context.titleSmall?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: context.onBackground)),
                      ],
                    )
                  else
                    const TextSpan(),
                  TextSpan(
                      text:
                          '${playlist.trackTotal} ${playlist.trackTotal! > 1 ? context.loc.songs : context.loc.song} ${!action ? ' • ${playlist.ownerName.toString().capitalize()}' : ""} ',
                      style: context.titleSmall?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: context.onBackground)),
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
