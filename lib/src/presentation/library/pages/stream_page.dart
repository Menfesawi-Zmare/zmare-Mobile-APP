import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/data/artist/model/artist.dart';
import 'package:zmare/src/data/song/model/item_song_model.dart';
import 'package:zmare/src/presentation/track/bloc/track_bloc.dart';
import 'package:zmare/src/presentation/widgets/item_list_big.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_image.dart';

import 'package:zmare/src/presentation/widgets/no_subscribe_widget.dart';
import 'package:zmare/src/service_locator.dart';
// ignore: depend_on_referenced_packages
import "package:collection/collection.dart";

class StreamPage extends StatefulWidget {
  const StreamPage({super.key});

  @override
  State<StreamPage> createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage> {
  List<ItemSongModel> listItemSong = [];
  List<ItemSongModel> totalTracks = [];
  final TrackBloc trackBloc = locator.get<TrackBloc>();
  final PagingController<int, ItemSongModel> _pagingController =
      PagingController(firstPageKey: 1);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Artist>? artists = [];
  int? selectedArtistId;
  int? artistId;
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      if (selectedArtistId != null) {
        trackBloc.add(GetArtistTrackListsEvent(artistId!, pageKey));
        return;
      }
      trackBloc.add(StreamFetch(pageKey, 0));
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
      appBar: AppBar(
        centerTitle: false,
        title: Text(context.loc.stream),
        titleTextStyle:
            context.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(90.0),
          child: SizedBox(
            height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      primary: false,
                      itemCount:
                          groupBy(artists!, (Artist element) => element.id)
                              .entries
                              .length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          color: selectedArtistId == index
                              ? Theme.of(context).colorScheme.secondaryContainer
                              : Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              context.show();
                              setState(() {
                                artistId = groupBy(artists!,
                                        (Artist element) => element.id)
                                    .values
                                    .elementAt(index)[0]
                                    .id!;
                                listItemSong = [];
                                totalTracks = [];
                                if (selectedArtistId == index) {
                                  selectedArtistId = null;
                                  trackBloc.add(const StreamFetch(1, 0));
                                } else {
                                  selectedArtistId = index;
                                  trackBloc.add(
                                      GetArtistTrackListsEvent(artistId!, 1));
                                }
                                _pagingController.itemList?.clear();
                              });
                            },
                            child: Column(children: [
                              SizedBox(
                                width: 64,
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: ClipOval(
                                        child: KhmertracksImage(
                                      imageUrl: groupBy(artists!,
                                              (Artist element) => element.id)
                                          .values
                                          .elementAt(index)[0]
                                          .image!,
                                      placeholderImage:
                                          Images.defalultArtistCover,
                                    )),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width: 64,
                                  child: Text(
                                      groupBy(artists!,
                                              (Artist element) => element.id)
                                          .values
                                          .elementAt(index)[0]
                                          .name!,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.bodySmall?.copyWith(
                                          fontWeight: selectedArtistId == index
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color:
                                              context.colorScheme.onSurface)))
                            ]),
                          ),
                        );
                      }),
                ),
                if (groupBy(artists!, (Artist element) => element.id)
                    .entries
                    .isNotEmpty)
                  TextButton(
                      onPressed: () => context.pushNamed(subscriptionsPath),
                      child: Text(
                        context.loc.all,
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w600),
                      ))
              ],
            ),
          ),
        ),
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
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
                key: _refreshIndicatorKey,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                strokeWidth: 2.0,
                onRefresh: () async {
                  trackBloc.add(const StreamFetch(1, 0));
                  _pagingController.refresh();
                  return Future<void>.delayed(const Duration(seconds: 1));
                },
                child: BlocProvider(
                  create: (context) => trackBloc,
                  child: BlocListener(
                    bloc: trackBloc,
                    listener: (context, state) {
                      if (state is TrackFetchSuccess) {
                        context.dismiss();
                        listItemSong = state.trackListModel.songList!;
                        totalTracks = totalTracks..addAll(listItemSong);
                        if (artists!.isEmpty) {
                          for (var e in listItemSong) {
                            artists!.add(Artist(
                                id: e.artistId!.split(',').length > 1
                                    ? int.parse(e.artistId!.split(',')[0])
                                    : int.parse(e.artistId!),
                                name: e.artist!.split(',').length > 1
                                    ? e.artist!.split(',')[0]
                                    : e.artist!,
                                image: e.artistImage));
                          }
                          setState(() {});
                        }
                        final isLastPage = listItemSong.length <
                            state.trackListModel.pagination!.perPage!;
                        if (isLastPage) {
                          _pagingController.appendLastPage(listItemSong);
                        } else {
                          _pagingController.appendPage(
                              listItemSong,
                              state.trackListModel.pagination!.currentPage! +
                                  1);
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
                      padding: EdgeInsets.zero,
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<ItemSongModel>(
                          noItemsFoundIndicatorBuilder: (context) =>
                              NoSubscribeWidget(
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
                )),
          ),
        ],
      ),
    );
  }
}
