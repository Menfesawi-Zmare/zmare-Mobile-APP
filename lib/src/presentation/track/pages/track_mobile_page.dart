import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_music_pro/src/data/song/model/item_song_model.dart';
import 'package:flutter_music_pro/src/presentation/widgets/item_list_big.dart';
import 'package:flutter_music_pro/src/presentation/widgets/no_result_widget.dart';
import '../../../service_locator.dart';
import '../bloc/track_bloc.dart';

class TrackMobilePage extends StatefulWidget {
  const TrackMobilePage({super.key, required this.type});
  final String type;
  @override
  State<TrackMobilePage> createState() => _TrackMobilePageState();
}

class _TrackMobilePageState extends State<TrackMobilePage>
    with AutomaticKeepAliveClientMixin {
  List<ItemSongModel> listItemSong = [];
  List<ItemSongModel> totalTracks = [];
  final TrackBloc trackBloc = locator.get<TrackBloc>();
  final PagingController<int, ItemSongModel> _pagingController =
      PagingController(firstPageKey: 1);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      trackBloc.add(TrackFetch(pageKey, widget.type));
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
    super.build(context);
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        strokeWidth: 2.0,
        onRefresh: () async {
          trackBloc.add(TrackFetch(1, widget.type));
          _pagingController.refresh();
          didChangeDependencies();
          return Future<void>.delayed(const Duration(seconds: 1));
        },
        child: BlocProvider(
          create: (context) => trackBloc,
          child: BlocListener(
            bloc: trackBloc,
            listener: (context, state) {
              if (state is TrackFetchSuccess) {
                listItemSong = state.trackListModel.songList!;
                totalTracks = totalTracks..addAll(listItemSong);
                final isLastPage = listItemSong.length <
                    state.trackListModel.pagination!.perPage!;
                if (isLastPage) {
                  _pagingController.appendLastPage(listItemSong);
                } else {
                  _pagingController.appendPage(listItemSong,
                      state.trackListModel.pagination!.currentPage! + 1);
                }
              }
              if (state is TrackFailedState) {
                _pagingController.error = state;
              }
              if (state is TrackNoData) {
                _pagingController.itemList = [];
              }
            },
            child: PagedListView<int, ItemSongModel>.separated(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<ItemSongModel>(
                  noItemsFoundIndicatorBuilder: (context) => NoResultWidget(
                      showRefresh: true,
                      onTap: () => _pagingController.refresh()),
                  itemBuilder: (context, item, index) {
                    return ItemListBig(
                        songList: item, listItemSong: totalTracks);
                  }),
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  indent: 78,
                  height: 0,
                );
              },
            ),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
