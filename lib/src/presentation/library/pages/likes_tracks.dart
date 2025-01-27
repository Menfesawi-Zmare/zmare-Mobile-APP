import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/data/song/model/item_song_model.dart';
import 'package:flutter_music_pro/src/presentation/profile/bloc/profile_bloc.dart';
import 'package:flutter_music_pro/src/presentation/widgets/item_list_big.dart';

import 'package:flutter_music_pro/src/service_locator.dart';

class LikesTracks extends StatefulWidget {
  const LikesTracks({super.key, required this.profileId});
  final int profileId;
  @override
  State<LikesTracks> createState() => _LikesTracksState();
}

class _LikesTracksState extends State<LikesTracks> {
  List<ItemSongModel> listItemSong = [];
  List<ItemSongModel> totalTracks = [];
  final ProfileBloc profileBloc = locator.get<ProfileBloc>();
  final PagingController<int, ItemSongModel> _pagingController =
      PagingController(firstPageKey: 1);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      profileBloc.add(GetProfileLikes(widget.profileId, pageKey));
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.materialYouAppBar(
        context.loc.likes,
        actions: [
          IconButton(
            icon: Icon(
              FluentIcons.search_28_regular,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () {
              context.pushNamed(searchPath);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        strokeWidth: 2.0,
        onRefresh: () async {
          _pagingController.refresh();
          profileBloc.add(GetProfileLikes(widget.profileId, 1));
          return Future<void>.delayed(const Duration(seconds: 1));
        },
        child: BlocProvider(
          create: (context) => profileBloc,
          child: BlocListener(
            bloc: profileBloc,
            listener: (context, state) {
              if (state is ProfileLikes) {
                listItemSong = state.trackList.songList!;
                totalTracks = totalTracks..addAll(listItemSong);
                final isLastPage =
                    listItemSong.length < state.trackList.pagination!.perPage!;
                if (isLastPage) {
                  _pagingController.appendLastPage(listItemSong);
                } else {
                  _pagingController.appendPage(listItemSong,
                      state.trackList.pagination!.currentPage! + 1);
                }
              }
              if (state is ProfileFailed) {
                _pagingController.error = state.message;
              }
              if (state is NoData) {
                _pagingController.appendLastPage([]);
              }
            },
            child: BlocBuilder(
                bloc: profileBloc,
                builder: (context, state) => PagedListView<int, ItemSongModel>(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<ItemSongModel>(
                        itemBuilder: (context, item, index) => ItemListBig(
                            songList: item, listItemSong: totalTracks),
                      ),
                    )),
          ),
        ),
      ),
    );
  }
}
