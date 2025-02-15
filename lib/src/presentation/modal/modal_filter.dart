import 'package:flutter/material.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/data/song/model/item_song_model.dart';
import 'package:go_router/go_router.dart';

class ModalFilter extends StatelessWidget {
  const ModalFilter(
      {super.key,
      required this.songList,
      required this.onCallBack,
      required this.selectedFilter,
      required this.onSetSelectedId});
  final int selectedFilter;
  final List<ItemSongModel> songList;
  final Function(List<ItemSongModel> songList) onCallBack;
  final Function(int setSelectedId) onSetSelectedId;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 10),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20, right: 10),
            title: Text(context.loc.sortOrder,
                style:
                    context.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            trailing: IconButton(
                onPressed: () => GoRouter.of(context).pop(),
                icon: const Icon(Icons.close)),
          ),
          ListTile(
            title: Text(context.loc.recentlyUploaded,
                style:
                    context.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            leading: const Icon(Icons.calendar_month_outlined),
            onTap: () {
              List<ItemSongModel> sortByPopular = songList
                ..sort((a, b) => a.id!.compareTo(b.id!));
              onCallBack(sortByPopular.reversed.toList());
              onSetSelectedId(1);
              GoRouter.of(context).pop();
            },
            trailing: selectedFilter == 1
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
          ),
          ListTile(
            title: Text(context.loc.popularLabel,
                style:
                    context.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            leading: const Icon(Icons.trending_up_rounded),
            onTap: () {
              List<ItemSongModel> sortByPopular = songList
                ..sort((a, b) => a.views!.compareTo(b.views!));
              onCallBack(sortByPopular.reversed.toList());
              onSetSelectedId(0);
              GoRouter.of(context).pop();
            },
            trailing: selectedFilter == 0
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
