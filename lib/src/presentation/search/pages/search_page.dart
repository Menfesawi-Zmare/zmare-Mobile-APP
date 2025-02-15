import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/core/enum/search_type.dart';
import 'package:zmare/src/data/album/model/album.dart';
import 'package:zmare/src/data/album/model/album_list.dart';
import 'package:zmare/src/data/artist/model/artist.dart';
import 'package:zmare/src/data/playlist/model/playlist.dart';
import 'package:zmare/src/data/profile/model/profile.dart';
import 'package:zmare/src/data/song/model/item_song_model.dart';
import 'package:zmare/src/presentation/search/bloc/search_bloc.dart';
import 'package:zmare/src/presentation/widgets/item_album.dart';
import 'package:zmare/src/presentation/widgets/item_artist.dart';
import 'package:zmare/src/presentation/widgets/item_list_big.dart';
import 'package:zmare/src/presentation/widgets/item_playlist.dart';
import 'package:zmare/src/presentation/widgets/item_profile.dart';

import 'package:zmare/src/presentation/widgets/no_result_widget.dart';
import 'package:zmare/src/service_locator.dart';
import 'package:logging/logging.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Box<dynamic> searchBox = locator.get(instanceName: BoxType.search.name);
  final controller = TextEditingController();
  List searchLocal =
      Hive.box(BoxType.search.name).get('search', defaultValue: []) as List;
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);
  List<SuggestionItem> search = [];
  List<SuggestionItem> liveSearch = [];
  final SearchBloc searchBloc = locator.get<SearchBloc>();
  String query = '';
  List<SuggestionItem>? listSuggestion = [];
  List<ItemSongModel>? songList = [];
  List<dynamic> totalTracks = [];
  List<AlbumList>? albumList = [];
  List<Artist>? artistList = [];
  List<dynamic>? dynamicList = [];
  int page = 1;
  int filterSelectedIndex = 0;
  bool isLoading = false;
  bool showHistory = true;
  bool showFilter = false;
  var focusNode = FocusNode();

  @override
  void initState() {
    searchLocal = searchLocal.toSet().toList();
    for (var e in searchLocal) {
      search.add(SuggestionItem(e, true));
    }
    _pagingController.addPageRequestListener((pageKey) {
      switch (filterSelectedIndex) {
        case 0:
          searchBloc.add(FetchSongSearchEvent(controller.text.trim(), pageKey));
          break;
        case 1:
          searchBloc
              .add(FetchArtistSearchEvent(controller.text.trim(), pageKey));
          break;
        case 2:
          searchBloc
              .add(FetchAlbumSearchEvent(controller.text.trim(), pageKey));
          break;
        case 3:
          searchBloc
              .add(FetchPlaylistSearchEvent(controller.text.trim(), pageKey));
          break;
        case 4:
          searchBloc
              .add(FetchProfileSearchEvent(controller.text.trim(), pageKey));
          break;
        default:
          searchBloc.add(FetchSongSearchEvent(controller.text.trim(), pageKey));
      }
    });
    super.initState();
  }

  void onSubmitted(int filterId, String query) {
    switch (filterId) {
      case 0:
        searchBloc.add(FetchSongSearchEvent(query, page));
        setState(() {
          isLoading = true;
        });
        break;
      case 1:
        searchBloc.add(FetchArtistSearchEvent(query, page));
        setState(() {
          isLoading = true;
        });
        break;
      case 2:
        searchBloc.add(FetchAlbumSearchEvent(query, page));
        setState(() {
          isLoading = true;
        });
        break;
      case 3:
        searchBloc.add(FetchPlaylistSearchEvent(query, page));
        setState(() {
          isLoading = true;
        });
        break;
      case 4:
        searchBloc.add(FetchProfileSearchEvent(query, page));
        setState(() {
          isLoading = true;
        });
        break;
      default:
        searchBloc.add(FetchSongSearchEvent(query, page));
        setState(() {
          isLoading = true;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => searchBloc,
      child: BlocListener<SearchBloc, SearchState>(
        listener: (context, state) {
          if (state is SearchSuggestion) {
            if (showHistory) {
              liveSearch.clear();
              liveSearch.addAll(state.suggestionList.suggestions!
                  .map((e) => SuggestionItem(e, false)));
              return;
            }
          }
          if (state is SearchTracks) {
            setState(() {
              dynamicList = state.trackList.songList;
              isLoading = false;
              totalTracks = totalTracks..addAll(dynamicList!);
              final isLastPage =
                  dynamicList!.length < state.trackList.pagination!.perPage!;
              if (isLastPage) {
                _pagingController.appendLastPage(dynamicList!);
              } else {
                _pagingController.appendPage(
                    dynamicList!, state.trackList.pagination!.currentPage! + 1);
              }
            });
          }
          if (state is SearchAlbumsLoaded) {
            setState(() {
              dynamicList = state.allAlbums.albumList!;
              isLoading = false;
              final isLastPage =
                  dynamicList!.length < state.allAlbums.pagination!.perPage!;
              if (isLastPage) {
                _pagingController.appendLastPage(dynamicList!);
              } else {
                _pagingController.appendPage(
                    dynamicList!, state.allAlbums.pagination!.currentPage! + 1);
              }
            });
          }
          if (state is SearchArtists) {
            setState(() {
              dynamicList = state.artistList.artistList;
              isLoading = false;
              final isLastPage =
                  dynamicList!.length < state.artistList.pagination!.perPage!;
              if (isLastPage) {
                _pagingController.appendLastPage(dynamicList!);
              } else {
                _pagingController.appendPage(dynamicList!,
                    state.artistList.pagination!.currentPage! + 1);
              }
            });
          }
          if (state is SearchPlaylists) {
            setState(() {
              dynamicList = state.playlistList.playlist;
              isLoading = false;
              final isLastPage =
                  dynamicList!.length < state.playlistList.pagination!.perPage!;
              if (isLastPage) {
                _pagingController.appendLastPage(dynamicList!);
              } else {
                _pagingController.appendPage(dynamicList!,
                    state.playlistList.pagination!.currentPage! + 1);
              }
            });
          }
          if (state is SearchProfile) {
            setState(() {
              dynamicList = state.profileList.profiles;
              isLoading = false;
              final isLastPage =
                  dynamicList!.length < state.profileList.pagination!.perPage!;
              if (isLastPage) {
                _pagingController.appendLastPage(dynamicList!);
              } else {
                _pagingController.appendPage(dynamicList!,
                    state.profileList.pagination!.currentPage! + 1);
              }
            });
          }
          if (state is SearchFailed) {
            setState(() {
              dynamicList = [];
              isLoading = false;
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
              title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(32)),
            child: Center(
              child: TextField(
                focusNode: focusNode,
                textAlignVertical: TextAlignVertical.bottom,
                controller: controller,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.fromLTRB(16.0, 0.0, 18.0, 20.0),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    borderSide: BorderSide(
                      width: 1.5,
                      color: Colors.transparent,
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    borderSide: BorderSide(
                      width: 1.5,
                      color: Colors.transparent,
                    ),
                  ), // OutlineInputBorder
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    borderSide: BorderSide(
                      width: 1.5,
                      color: Colors.transparent,
                    ),
                  ),
                  // prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      /* Clear the search field */
                      setState(() {
                        focusNode.requestFocus();
                        controller.text = '';
                        showHistory = true;
                        showFilter = false;
                        dynamicList = [];
                        _pagingController.itemList!.isNotEmpty
                            ? _pagingController.itemList!.clear()
                            : null;
                      });
                    },
                  ),
                  hintText: context.loc.search,
                  // border: InputBorder.none
                ),
                autofocus: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                onTap: () {
                  setState(() {
                    showHistory = true;
                    showFilter = false;
                    dynamicList = [];
                    totalTracks = [];
                    _pagingController.itemList?.clear();
                  });
                },
                onSubmitted: (submittedQuery) {
                  Logger.root.info(submittedQuery);
                  if (submittedQuery.trim() != '') {
                    query = submittedQuery;
                    List searchQueries = Hive.box('search')
                        .get('search', defaultValue: []) as List;
                    if (searchQueries.contains(query)) {
                      searchQueries.remove(query);
                    }
                    searchQueries.insert(0, query);
                    if (searchQueries.length > 10) {
                      searchQueries = searchQueries.sublist(0, 10);
                    }
                    Hive.box('search').put('search', searchQueries);
                    setState(() {
                      isLoading = true;
                      showHistory = false;
                      showFilter = true;
                      dynamicList = [];
                      totalTracks = [];
                    });
                    onSubmitted(filterSelectedIndex, submittedQuery);
                  }
                },
                onChanged: (query) {
                  List reloadSearch = Hive.box(BoxType.search.name)
                      .get('search', defaultValue: []) as List;
                  List<SuggestionItem> reloadList = [];
                  for (var e in reloadSearch) {
                    reloadList.add(SuggestionItem(e, true));
                  }
                  if (query.isEmpty) {
                    setState(() {
                      search = reloadList;
                    });
                    return;
                  } else {
                    searchBloc.add(FetchSearchSuggestionEvent(query));
                    Future.delayed(const Duration(milliseconds: 600), () {
                      setState(() {
                        List<SuggestionItem> localSearch = reloadList
                            .where((item) => item.title
                                .toString()
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                            .toSet()
                            .toList();
                        search = [...localSearch, ...liveSearch]
                          ..map((e) => e.title).toSet().toList();
                      });
                    });
                  }
                },
              ),
            ),
          )),
          body: CustomScrollView(shrinkWrap: true, slivers: [
            //Filter Chip Button
            if (showFilter)
              SliverAppBar(
                floating: true,
                pinned: true,
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                title: SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: SearchType.values.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: FilterChip(
                          showCheckmark: false,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          label: Text(
                            SearchType.values[i].name(context),
                            style: context.titleSmall,
                          ),
                          selected: SearchType.values[i].toIndex ==
                                  filterSelectedIndex
                              ? true
                              : false,
                          onSelected: (bool value) {
                            setState(() {
                              dynamicList = [];
                              totalTracks = [];
                              filterSelectedIndex = i;
                              _pagingController.itemList?.clear();
                            });
                            onSubmitted(filterSelectedIndex, controller.text);
                          },
                        ),
                      );
                    },
                  ),
                ),
              )
            else
              SliverToBoxAdapter(child: Container()),
            //Searhc History
            if (showHistory)
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                return ListTile(
                  leading: search[index].isHistory
                      ? const Icon(FluentIcons.history_48_regular)
                      : const Icon(FluentIcons.search_48_regular),
                  title: Text(
                    search[index].title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.bodyLarge,
                  ),
                  trailing: const Icon(FluentIcons.arrow_up_left_48_regular),
                  onTap: () {
                    List searchQueries =
                        searchBox.get('search', defaultValue: []) as List;
                    searchQueries.insert(0, search[index].title.trim());
                    if (searchQueries.length > 18) {
                      searchQueries = searchQueries.sublist(0, 18);
                    }
                    searchBox.put('search', searchQueries);
                    setState(() {
                      controller.text = search[index].title.trim();
                      searchBloc
                          .add(FetchSongSearchEvent(controller.text, page));
                      showHistory = false;
                      showFilter = true;
                      FocusScope.of(context).unfocus();
                    });
                  },
                );
              }, childCount: search.length))
            else
              SliverToBoxAdapter(child: Container()),
            //Search Results
            if (isLoading)
              const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()))
            else
              dynamicList!.isNotEmpty
                  ? PagedSliverList.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          indent: 78,
                          height: 0,
                        );
                      },
                      builderDelegate: PagedChildBuilderDelegate<dynamic>(
                          itemBuilder: (context, item, index) {
                        if (item is ItemSongModel) {
                          return ItemListBig(
                              songList: item, listItemSong: [...totalTracks]);
                        } else if (item is Artist) {
                          return ItemArtist(artists: item);
                        } else if (item is Album) {
                          return ItemAlbum(album: item);
                        } else if (item is Playlist) {
                          return ItemPlaylist(playlist: item);
                        } else if (item is Profile) {
                          return ItemProfile(profile: item);
                        }
                        return const NoResultWidget();
                      }),
                      pagingController: _pagingController,
                    )
                  : SliverVisibility(
                      visible: showHistory ? false : true,
                      sliver:
                          const SliverFillRemaining(child: NoResultWidget()),
                    ),
          ]),
        ),
      ),
    );
  }
}

class FilterItem {
  int id;
  String label;
  bool isSelected;
  FilterItem(this.id, this.label, this.isSelected);
}

class SuggestionItem {
  String title;
  bool isHistory;
  SuggestionItem(this.title, this.isHistory);
}
