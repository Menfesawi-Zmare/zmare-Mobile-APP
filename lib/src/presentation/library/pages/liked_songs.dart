import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/utils/helper/songs_count.dart' as songs_count;
import 'package:zmare/src/utils/services/audio/player_service.dart';
import 'package:zmare/src/presentation/widgets/collage.dart';
import 'package:zmare/src/presentation/widgets/download_button.dart';
import 'package:zmare/src/presentation/widgets/downloads_search.dart';
import 'package:zmare/src/presentation/widgets/empty_screen.dart';
import 'package:zmare/src/presentation/widgets/like_button.dart';

import 'package:zmare/src/presentation/widgets/playlist_head.dart';
import 'package:zmare/src/presentation/widgets/texts/khmertracks_subtitle.dart';
import 'package:zmare/src/presentation/widgets/texts/khmertracks_title.dart';

class LikedSongs extends StatefulWidget {
  final String playlistName;
  final String? showName;
  final bool fromPlaylist;
  final List? songs;
  const LikedSongs({
    super.key,
    required this.playlistName,
    this.showName,
    this.fromPlaylist = false,
    this.songs,
  });
  @override
  State<LikedSongs> createState() => _LikedSongsState();
}

class _LikedSongsState extends State<LikedSongs>
    with SingleTickerProviderStateMixin {
  Box? likedBox;
  bool added = false;
  List _songs = [];
  final Map<String, List<Map>> _albums = {};
  final Map<String, List<Map>> _artists = {};
  final Map<String, List<Map>> _genres = {};
  List _sortedAlbumKeysList = [];
  List _sortedArtistKeysList = [];
  List _sortedGenreKeysList = [];
  TabController? _tcontroller;
  int sortValue =
      Hive.box(BoxType.settings.name).get('sortValue', defaultValue: 1) as int;
  int orderValue =
      Hive.box(BoxType.settings.name).get('orderValue', defaultValue: 1) as int;
  int albumSortValue = Hive.box(BoxType.settings.name)
      .get('albumSortValue', defaultValue: 2) as int;
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showShuffle = ValueNotifier<bool>(true);

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  void initState() {
    _tcontroller = TabController(length: 4, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        _showShuffle.value = false;
      } else {
        _showShuffle.value = true;
      }
    });
    getLiked();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tcontroller!.dispose();
    _scrollController.dispose();
  }

  void getLiked() {
    likedBox = Hive.box(widget.playlistName);
    if (widget.fromPlaylist) {
      _songs = widget.songs!;
    } else {
      _songs = likedBox?.values.toList() ?? [];
      songs_count.addSongsCount(
        widget.playlistName,
        _songs.length,
        _songs.length >= 4
            ? _songs.sublist(0, 4)
            : _songs.sublist(0, _songs.length),
      );
    }
    setArtistAlbum();
  }

  void setArtistAlbum() {
    for (final element in _songs) {
      if (_albums.containsKey(element['album'])) {
        final List<Map> tempAlbum = _albums[element['album']]!;
        tempAlbum.add(element as Map);
        _albums.addEntries([MapEntry(element['album'].toString(), tempAlbum)]);
      } else {
        _albums.addEntries([
          MapEntry(element['album'].toString(), [element as Map])
        ]);
      }

      element['artist'].toString().split(', ').forEach((singleArtist) {
        if (_artists.containsKey(singleArtist)) {
          final List<Map> tempArtist = _artists[singleArtist]!;
          tempArtist.add(element);
          _artists.addEntries([MapEntry(singleArtist, tempArtist)]);
        } else {
          _artists.addEntries([
            MapEntry(singleArtist, [element])
          ]);
        }
      });

      if (_genres.containsKey(element['genre'])) {
        final List<Map> tempGenre = _genres[element['genre']]!;
        tempGenre.add(element);
        _genres.addEntries([MapEntry(element['genre'].toString(), tempGenre)]);
      } else {
        _genres.addEntries([
          MapEntry(element['genre'].toString(), [element])
        ]);
      }
    }

    sortSongs(sortVal: sortValue, order: orderValue);

    _sortedAlbumKeysList = _albums.keys.toList();
    _sortedArtistKeysList = _artists.keys.toList();
    _sortedGenreKeysList = _genres.keys.toList();

    sortAlbums();

    added = true;
    setState(() {});
  }

  void sortSongs({required int sortVal, required int order}) {
    switch (sortVal) {
      case 0:
        _songs.sort(
          (a, b) => a['title']
              .toString()
              .toUpperCase()
              .compareTo(b['title'].toString().toUpperCase()),
        );
        break;
      case 1:
        _songs.sort(
          (a, b) => a['dateAdded']
              .toString()
              .toUpperCase()
              .compareTo(b['dateAdded'].toString().toUpperCase()),
        );
        break;
      case 2:
        _songs.sort(
          (a, b) => a['album']
              .toString()
              .toUpperCase()
              .compareTo(b['album'].toString().toUpperCase()),
        );
        break;
      case 3:
        _songs.sort(
          (a, b) => a['artist']
              .toString()
              .toUpperCase()
              .compareTo(b['artist'].toString().toUpperCase()),
        );
        break;
      case 4:
        _songs.sort(
          (a, b) => a['duration']
              .toString()
              .toUpperCase()
              .compareTo(b['duration'].toString().toUpperCase()),
        );
        break;
      default:
        _songs.sort(
          (b, a) => a['dateAdded']
              .toString()
              .toUpperCase()
              .compareTo(b['dateAdded'].toString().toUpperCase()),
        );
        break;
    }

    if (order == 1) {
      _songs = _songs.reversed.toList();
    }
  }

  void sortAlbums() {
    if (albumSortValue == 0) {
      _sortedAlbumKeysList.sort(
        (a, b) =>
            a.toString().toUpperCase().compareTo(b.toString().toUpperCase()),
      );
      _sortedArtistKeysList.sort(
        (a, b) =>
            a.toString().toUpperCase().compareTo(b.toString().toUpperCase()),
      );
      _sortedGenreKeysList.sort(
        (a, b) =>
            a.toString().toUpperCase().compareTo(b.toString().toUpperCase()),
      );
    }
    if (albumSortValue == 1) {
      _sortedAlbumKeysList.sort(
        (b, a) =>
            a.toString().toUpperCase().compareTo(b.toString().toUpperCase()),
      );
      _sortedArtistKeysList.sort(
        (b, a) =>
            a.toString().toUpperCase().compareTo(b.toString().toUpperCase()),
      );
      _sortedGenreKeysList.sort(
        (b, a) =>
            a.toString().toUpperCase().compareTo(b.toString().toUpperCase()),
      );
    }
    if (albumSortValue == 2) {
      _sortedAlbumKeysList
          .sort((b, a) => _albums[a]!.length.compareTo(_albums[b]!.length));
      _sortedArtistKeysList
          .sort((b, a) => _artists[a]!.length.compareTo(_artists[b]!.length));
      _sortedGenreKeysList
          .sort((b, a) => _genres[a]!.length.compareTo(_genres[b]!.length));
    }
    if (albumSortValue == 3) {
      _sortedAlbumKeysList
          .sort((a, b) => _albums[a]!.length.compareTo(_albums[b]!.length));
      _sortedArtistKeysList
          .sort((a, b) => _artists[a]!.length.compareTo(_artists[b]!.length));
      _sortedGenreKeysList
          .sort((a, b) => _genres[a]!.length.compareTo(_genres[b]!.length));
    }
    if (albumSortValue == 4) {
      _sortedAlbumKeysList.shuffle();
      _sortedArtistKeysList.shuffle();
      _sortedGenreKeysList.shuffle();
    }
  }

  void deleteLiked(Map song) {
    setState(() {
      likedBox!.delete(song['id']);
      if (_albums[song['album']]!.length == 1) {
        _sortedAlbumKeysList.remove(song['album']);
      }
      _albums[song['album']]!.remove(song);

      song['artist'].toString().split(', ').forEach((singleArtist) {
        if (_artists[singleArtist]!.length == 1) {
          _sortedArtistKeysList.remove(singleArtist);
        }
        _artists[singleArtist]!.remove(song);
      });

      if (_genres[song['genre']]!.length == 1) {
        _sortedGenreKeysList.remove(song['genre']);
      }
      _genres[song['genre']]!.remove(song);

      _songs.remove(song);
      songs_count.addSongsCount(
        widget.playlistName,
        _songs.length,
        _songs.length >= 4
            ? _songs.sublist(0, 4)
            : _songs.sublist(0, _songs.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  widget.showName == null
                      ? widget.playlistName[0].toUpperCase() +
                          widget.playlistName.substring(1)
                      : widget.showName![0].toUpperCase() +
                          widget.showName!.substring(1),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                titleTextStyle: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
                centerTitle: false,
                elevation: 0,
                bottom: TabBar(
                  controller: _tcontroller,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle:
                      context.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(
                      text: context.loc.songs,
                    ),
                    Tab(
                      text: context.loc.albums,
                    ),
                    Tab(
                      text: context.loc.artists,
                    ),
                    Tab(
                      text: context.loc.genres,
                    ),
                  ],
                ),
                actions: [
                  if (_songs.isNotEmpty)
                    MultiDownloadButton(
                      data: _songs,
                      playlistName: widget.showName == null
                          ? widget.playlistName[0].toUpperCase() +
                              widget.playlistName.substring(1)
                          : widget.showName![0].toUpperCase() +
                              widget.showName!.substring(1),
                    ),
                  IconButton(
                    icon: const Icon(CupertinoIcons.search),
                    tooltip: context.loc.search,
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: DownloadsSearch(data: _songs),
                      );
                    },
                  ),
                  PopupMenuButton(
                    icon: const Icon(Icons.sort_rounded),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    onSelected:
                        // (currentIndex == 0) ?
                        (int value) {
                      if (value < 5) {
                        sortValue = value;
                        Hive.box(BoxType.settings.name).put('sortValue', value);
                      } else {
                        orderValue = value - 5;
                        Hive.box(BoxType.settings.name)
                            .put('orderValue', orderValue);
                      }
                      sortSongs(sortVal: sortValue, order: orderValue);
                      setState(() {});
                    },
                    // : (int value) {
                    //     albumSortValue = value;
                    //     Hive.box(BoxType.settings.name).put('albumSortValue', value);
                    //     sortAlbums();
                    //     setState(() {});
                    //   },
                    itemBuilder:
                        // (currentIndex == 0)
                        // ?
                        (context) {
                      final List<String> sortTypes = [
                        context.loc.displayName,
                        context.loc.dateAdded,
                        context.loc.album,
                        context.loc.artist,
                        context.loc.duration,
                      ];
                      final List<String> orderTypes = [
                        context.loc.inc,
                        context.loc.dec,
                      ];
                      final menuList = <PopupMenuEntry<int>>[];
                      menuList.addAll(
                        sortTypes
                            .map(
                              (e) => PopupMenuItem(
                                value: sortTypes.indexOf(e),
                                child: Row(
                                  children: [
                                    if (sortValue == sortTypes.indexOf(e))
                                      Icon(
                                        Icons.check_rounded,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.grey[700],
                                      )
                                    else
                                      const SizedBox(),
                                    const SizedBox(width: 10),
                                    Text(
                                      e,
                                      style: context.titleMedium!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      );
                      menuList.add(
                        const PopupMenuDivider(
                          height: 10,
                        ),
                      );
                      menuList.addAll(
                        orderTypes
                            .map(
                              (e) => PopupMenuItem(
                                value: sortTypes.length + orderTypes.indexOf(e),
                                child: Row(
                                  children: [
                                    if (orderValue == orderTypes.indexOf(e))
                                      Icon(
                                        Icons.check_rounded,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.grey[700],
                                      )
                                    else
                                      const SizedBox(),
                                    const SizedBox(width: 10),
                                    Text(
                                      e,
                                      style: context.titleMedium!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: context.colorScheme.onSurface),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      );
                      return menuList;
                    },
                  ),
                ],
              ),
              body: !added
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : TabBarView(
                      // physics: const CustomPhysics(),
                      controller: _tcontroller,
                      children: [
                        SongsTab(
                          songs: _songs,
                          onDelete: (Map item) {
                            deleteLiked(item);
                          },
                          playlistName: widget.playlistName,
                          scrollController: _scrollController,
                        ),
                        AlbumsTab(
                          albums: _albums,
                          type: 'album',
                          offline: false,
                          playlistName: widget.playlistName,
                          sortedAlbumKeysList: _sortedAlbumKeysList,
                        ),
                        AlbumsTab(
                          albums: _artists,
                          type: 'artist',
                          offline: false,
                          playlistName: widget.playlistName,
                          sortedAlbumKeysList: _sortedArtistKeysList,
                        ),
                        AlbumsTab(
                          albums: _genres,
                          type: 'genre',
                          offline: false,
                          playlistName: widget.playlistName,
                          sortedAlbumKeysList: _sortedGenreKeysList,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class SongsTab extends StatefulWidget {
  final List songs;
  final String playlistName;
  final Function(Map item) onDelete;
  final ScrollController scrollController;
  const SongsTab({
    super.key,
    required this.songs,
    required this.onDelete,
    required this.playlistName,
    required this.scrollController,
  });

  @override
  State<SongsTab> createState() => _SongsTabState();
}

class _SongsTabState extends State<SongsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return (widget.songs.isEmpty)
        ? emptyScreen(
            context,
            3,
            context.loc.nothingTo,
            15.0,
            context.loc.showHere,
            50,
            context.loc.addSomething,
            23.0,
          )
        : Column(
            children: [
              PlaylistHead(
                songsList: widget.songs,
                offline: false,
                fromDownloads: false,
              ),
              Expanded(
                child: ListView.builder(
                  controller: widget.scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 10),
                  shrinkWrap: true,
                  itemCount: widget.songs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: SizedBox.square(
                          dimension: 50,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            errorWidget: (context, _, __) => const Image(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                Images.defalutCover,
                              ),
                            ),
                            imageUrl: widget.songs[index]['image']
                                .toString()
                                .replaceAll('http:', 'https:'),
                            placeholder: (context, url) => const Image(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                Images.defalutCover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        PlayerInvoke.init(
                          songsList: widget.songs,
                          index: index,
                          isOffline: false,
                          recommend: false,
                          playlistBox: widget.playlistName,
                        );
                      },
                      title: Text(
                        '${widget.songs[index]['title']}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${widget.songs[index]['artist'] ?? 'Unknown'} - ${widget.songs[index]['album'] ?? 'Unknown'}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.playlistName != BoxType.favorite.name)
                            LikeButton(
                              mediaItem: null,
                              data: widget.songs[index] as Map,
                            ),
                          DownloadButton(
                            data: widget.songs[index] as Map,
                            icon: 'download',
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}

class AlbumsTab extends StatefulWidget {
  final Map<String, List> albums;
  final List sortedAlbumKeysList;
  // final String? tempPath;
  final String type;
  final bool offline;
  final String? playlistName;
  const AlbumsTab({
    super.key,
    required this.albums,
    required this.offline,
    required this.sortedAlbumKeysList,
    required this.type,
    this.playlistName,
    // this.tempPath,
  });

  @override
  State<AlbumsTab> createState() => _AlbumsTabState();
}

class _AlbumsTabState extends State<AlbumsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.sortedAlbumKeysList.isEmpty
        ? emptyScreen(
            context,
            3,
            context.loc.nothingTo,
            15.0,
            context.loc.showHere,
            50,
            context.loc.addSomething,
            23.0,
          )
        : ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                indent: 78,
                height: 0,
              );
            },
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 10.0),
            shrinkWrap: true,
            itemCount: widget.sortedAlbumKeysList.length,
            itemBuilder: (context, index) {
              final List imageList = widget
                          .albums[widget.sortedAlbumKeysList[index]]!.length >=
                      4
                  ? widget.albums[widget.sortedAlbumKeysList[index]]!
                      .sublist(0, 4)
                  : widget.albums[widget.sortedAlbumKeysList[index]]!.sublist(
                      0,
                      widget.albums[widget.sortedAlbumKeysList[index]]!.length,
                    );
              return ListTile(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                minVerticalPadding: 8.0,
                contentPadding: const EdgeInsets.only(left: 16),
                leading: (widget.offline)
                    ? OfflineCollage(
                        imageList: imageList,
                        showGrid: widget.type == 'genre',
                        placeholderImage: widget.type == 'artist'
                            ? Images.defalultArtistCover
                            : Images.defalutAlbumCover,
                      )
                    : Collage(
                        imageList: imageList,
                        showGrid: widget.type == 'genre',
                        placeholderImage: widget.type == 'artist'
                            ? Images.defalultArtistCover
                            : Images.defalutAlbumCover,
                      ),
                title: KhmertracksTitle(
                  '${widget.sortedAlbumKeysList[index]}',
                ),
                subtitle: KhmertracksSubTitle(widget
                            .albums[widget.sortedAlbumKeysList[index]]!
                            .length ==
                        1
                    ? '${widget.albums[widget.sortedAlbumKeysList[index]]!.length} ${context.loc.song}'
                    : '${widget.albums[widget.sortedAlbumKeysList[index]]!.length} ${context.loc.songs}'),
                onTap: () {
                  context.pushNamed(
                    showSongName,
                    extra: widget.albums[widget.sortedAlbumKeysList[index]]!,
                    pathParameters: {
                      'type': widget.offline.toString(),
                      'title': widget.sortedAlbumKeysList[index]
                    },
                  );
                },
              );
            },
          );
  }
}
