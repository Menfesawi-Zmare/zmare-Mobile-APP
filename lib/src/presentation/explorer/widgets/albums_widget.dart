import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/core/enum/explorer_item_type.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zmare/src/app/routes.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/core/enum/grid_type.dart';
import 'package:zmare/src/utils/helper/ad_helper.dart';
import 'package:zmare/src/data/album/model/album.dart';
import 'package:zmare/src/presentation/widgets/dynamic_grid.dart';
import 'package:zmare/src/service_locator.dart';

class AlbumsWidget extends StatefulWidget {
  const AlbumsWidget(
      {super.key,
      required this.albums,
      required this.title,
      required this.type});
  final List<Album>? albums;
  final String title;
  final String type;
  @override
  State<AlbumsWidget> createState() => _AlbumsWidgetState();
}

class _AlbumsWidgetState extends State<AlbumsWidget> {
  @override
  Widget build(BuildContext context) {
    int? limit = settings.get(explorerPerPage, defaultValue: 10);
    return Column(mainAxisSize: MainAxisSize.min, children: [
      ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(widget.title,
              style: context.titleLarge?.copyWith(
                color: context.onBackground,
                fontWeight: FontWeight.w600,
              )),
          trailing: Visibility(
            visible: widget.albums!.length >= limit! ? true : false,
            child: IconButton(
              onPressed: () {
                AdHelper.showInterstitialAd();
                widget.type == ExplorerItemType.custom.name
                    ? context.pushNamed(customAlbumPath,
                        extra: widget.albums,
                        pathParameters: {'title': widget.title})
                    : context.pushNamed(allAlbumPath, extra: widget.title);
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
              .listenable(keys: [albumGridKey]),
          builder: (context, value, child) {
            int gridStyleId = value.get(albumGridKey,
                defaultValue: GridType.coloredCard.toIndex);
            return SizedBox(
              height: gridStyleId != 3 ? 200 : 130,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.albums!.length > limit
                      ? widget.albums!.sublist(0, limit).length
                      : widget.albums!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return DynamicGrid(
                      title: widget.albums![index].name!,
                      image: widget.albums![index].image!,
                      gridStyleId: gridStyleId,
                      onTap: () => context.pushNamed(albumSongsPath,
                          extra: widget.albums![index]),
                    );
                  }),
            );
          })
    ]);
  }
}
