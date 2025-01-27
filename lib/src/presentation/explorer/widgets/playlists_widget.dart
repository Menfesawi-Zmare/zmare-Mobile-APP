import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/data/playlist/model/playlist.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_music_pro/src/app/routes.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/core/enum/box_types.dart';
import 'package:flutter_music_pro/src/core/enum/grid_type.dart';
import 'package:flutter_music_pro/src/utils/helper/ad_helper.dart';
import 'package:flutter_music_pro/src/presentation/widgets/dynamic_grid.dart';
import 'package:flutter_music_pro/src/service_locator.dart';

class PlaylistsWidget extends StatefulWidget {
  const PlaylistsWidget(
      {super.key, required this.playlists, required this.title});
  final List<Playlist>? playlists;
  final String title;
  @override
  State<PlaylistsWidget> createState() => _PlaylistsWidgetState();
}

class _PlaylistsWidgetState extends State<PlaylistsWidget> {
  int? limit = settings.get(explorerPerPage, defaultValue: 10);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(widget.title,
              style: context.titleLarge?.copyWith(
                color: context.onBackground,
                fontWeight: FontWeight.w600,
              )),
          trailing: Visibility(
            visible: widget.playlists!.length >= limit! ? true : false,
            child: IconButton(
              onPressed: () {
                AdHelper.showInterstitialAd();
                context.pushNamed(allPlaylistsPath,
                    extra: widget.playlists,
                    pathParameters: {'title': widget.title});
              },
              icon: Icon(
                FluentIcons.arrow_right_28_regular,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          )),
      ValueListenableBuilder<Box<dynamic>>(
          valueListenable: locator
              .get<Box<dynamic>>(instanceName: BoxType.settings.name)
              .listenable(keys: [playlistGridKey]),
          builder: (context, value, child) {
            int gridStyleId = value.get(playlistGridKey,
                defaultValue: GridType.tinyCard.toIndex);
            return SizedBox(
              height: gridStyleId != 3 ? 200 : 128,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.playlists!.length > limit!
                      ? widget.playlists!.sublist(0, limit).length
                      : widget.playlists!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return DynamicGrid(
                      title: widget.playlists![index].name!,
                      image: widget.playlists![index].image!,
                      gridStyleId: gridStyleId,
                      onTap: () => context.pushNamed(viewPlaylistsPath,
                          extra: widget.playlists![index],
                          pathParameters: {'action': 'false'}),
                    );
                  }),
            );
          })
    ]);
  }
}
