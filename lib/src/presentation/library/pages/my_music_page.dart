//ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/utils/helper/audio_query.dart';
import 'package:zmare/src/presentation/library/modal/download_filter.dart';
import 'package:zmare/src/presentation/widgets/data_search.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

import '../tabs/albums_tab.dart';
import '../tabs/songs_tab.dart';

class MyMusicPage extends StatefulWidget {
  final List<SongModel>? cachedSongs;
  final String? title;
  const MyMusicPage({
    super.key,
    this.cachedSongs,
    this.title,
  });
  @override
  State<MyMusicPage> createState() => _MyMusicPageState();
}

class _MyMusicPageState extends State<MyMusicPage>
    with TickerProviderStateMixin {
  List<SongModel> _songs = [];
  String? tempPath =
      Hive.box(BoxType.myMusic.name).get('tempDirPath')?.toString();
  final Map<String, List<SongModel>> _albums = {};
  final Map<String, List<SongModel>> _artists = {};
  final Map<String, List<SongModel>> _genres = {};
  final Map<String, List<SongModel>> _folders = {};

  final List<String> _sortedAlbumKeysList = [];
  final List<String> _sortedArtistKeysList = [];
  final List<String> _sortedGenreKeysList = [];
  final List<String> _sortedFolderKeysList = [];

  bool added = false;
  int sortValue =
      Hive.box(BoxType.myMusic.name).get('sortValue', defaultValue: 1) as int;
  int orderValue =
      Hive.box(BoxType.myMusic.name).get('orderValue', defaultValue: 1) as int;
  int albumSortValue = Hive.box(BoxType.myMusic.name)
      .get('albumSortValue', defaultValue: 2) as int;
  List dirPaths = Hive.box(BoxType.myMusic.name)
      .get('searchPaths', defaultValue: []) as List;
  int minDuration = Hive.box(BoxType.myMusic.name)
      .get('minDuration', defaultValue: 10) as int;
  bool includeOrExclude = Hive.box(BoxType.myMusic.name)
      .get('includeOrExclude', defaultValue: false) as bool;
  List includedExcludedPaths = Hive.box(BoxType.myMusic.name)
      .get('includedExcludedPaths', defaultValue: []) as List;
  TabController? _tcontroller;
  OfflineAudioQuery offlineAudioQuery = OfflineAudioQuery();
  List<PlaylistModel> playlistDetails = [];

  final Map<int, SongSortType> songSortTypes = {
    0: SongSortType.DISPLAY_NAME,
    1: SongSortType.DATE_ADDED,
    2: SongSortType.ALBUM,
    3: SongSortType.ARTIST,
    4: SongSortType.DURATION,
    5: SongSortType.SIZE,
  };

  final Map<int, OrderType> songOrderTypes = {
    0: OrderType.ASC_OR_SMALLER,
    1: OrderType.DESC_OR_GREATER,
  };

  @override
  void initState() {
    _tcontroller = TabController(length: 5, vsync: this);
    getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tcontroller!.dispose();
  }

  bool checkIncludedOrExcluded(SongModel song) {
    for (final path in includedExcludedPaths) {
      if (song.data.contains(path.toString())) return true;
    }
    return false;
  }

  Future<void> getData() async {
    try {
      if (!Platform.isWindows) {
        PermissionStatus status = await Permission.storage.status;
        if (status.isDenied) {
          await [
            Permission.storage,
            Permission.accessMediaLocation,
            Permission.mediaLibrary,
          ].request();
        }
        status = await Permission.storage.status;
        if (status.isPermanentlyDenied) {
          await openAppSettings();
        }
      }
      Logger.root.info('Requesting permission to access local songs');
      await offlineAudioQuery.requestPermission();
      tempPath ??= (await getTemporaryDirectory()).path;
      if (Platform.isAndroid) {
        Logger.root.info('Getting local playlists');
        playlistDetails = await offlineAudioQuery.getPlaylists();
      }
      if (widget.cachedSongs == null) {
        Logger.root.info('Cache empty, calling audioQuery');
        final receivedSongs = await offlineAudioQuery.getSongs(
          sortType: songSortTypes[sortValue],
          orderType: songOrderTypes[orderValue],
        );
        Logger.root.info('Received ${receivedSongs.length} songs, filtering');
        _songs = receivedSongs
            .where(
              (i) =>
                  (i.duration ?? 60000) > 1000 * minDuration &&
                  (i.isMusic! || i.isPodcast! || i.isAudioBook!) &&
                  (includeOrExclude
                      ? checkIncludedOrExcluded(i)
                      : !checkIncludedOrExcluded(i)),
            )
            .toList();
      } else {
        Logger.root.info('Setting songs to cached songs');
        _songs = widget.cachedSongs!;
      }
      added = true;
      Logger.root.info('got ${_songs.length} songs');
      setState(() {});
      Logger.root.info('setting albums and artists');
      for (int i = 0; i < _songs.length; i++) {
        try {
          if (_albums.containsKey(_songs[i].album ?? 'Unknown')) {
            _albums[_songs[i].album ?? 'Unknown']!.add(_songs[i]);
          } else {
            _albums[_songs[i].album ?? 'Unknown'] = [_songs[i]];
            _sortedAlbumKeysList.add(_songs[i].album ?? 'Unknown');
          }

          if (_artists.containsKey(_songs[i].artist ?? 'Unknown')) {
            _artists[_songs[i].artist ?? 'Unknown']!.add(_songs[i]);
          } else {
            _artists[_songs[i].artist ?? 'Unknown'] = [_songs[i]];
            _sortedArtistKeysList.add(_songs[i].artist ?? 'Unknown');
          }

          if (_genres.containsKey(_songs[i].genre ?? 'Unknown')) {
            _genres[_songs[i].genre ?? 'Unknown']!.add(_songs[i]);
          } else {
            _genres[_songs[i].genre ?? 'Unknown'] = [_songs[i]];
            _sortedGenreKeysList.add(_songs[i].genre ?? 'Unknown');
          }

          final tempPath = _songs[i].data.split('/');
          tempPath.removeLast();
          final dirPath = tempPath.join('/');

          if (_folders.containsKey(dirPath)) {
            _folders[dirPath]!.add(_songs[i]);
          } else {
            _folders[dirPath] = [_songs[i]];
            _sortedFolderKeysList.add(dirPath);
          }
        } catch (e) {
          Logger.root.severe('Error in sorting songs', e);
        }
      }
      Logger.root.info('albums, artists, genre & folders set');
    } catch (e) {
      Logger.root.severe('Error in getData', e);
      added = true;
    }
  }

  Future<void> sortSongs(int sortVal, int order) async {
    Logger.root.info('Sorting songs');
    switch (sortVal) {
      case 0:
        _songs.sort(
          (a, b) => a.displayName.compareTo(b.displayName),
        );
        break;
      case 1:
        _songs.sort(
          (a, b) => a.dateAdded.toString().compareTo(b.dateAdded.toString()),
        );
        break;
      case 2:
        _songs.sort(
          (a, b) => a.album.toString().compareTo(b.album.toString()),
        );
        break;
      case 3:
        _songs.sort(
          (a, b) => a.artist.toString().compareTo(b.artist.toString()),
        );
        break;
      case 4:
        _songs.sort(
          (a, b) => a.duration.toString().compareTo(b.duration.toString()),
        );
        break;
      case 5:
        _songs.sort(
          (a, b) => a.size.toString().compareTo(b.size.toString()),
        );
        break;
      default:
        _songs.sort(
          (a, b) => a.dateAdded.toString().compareTo(b.dateAdded.toString()),
        );
        break;
    }

    if (order == 1) {
      _songs = _songs.reversed.toList();
    }
    Logger.root.info('Done Sorting songs');
  }

  Future<void> deleteSong(SongModel song) async {
    final audioFile = File(song.data);
    if (_albums[song.album]!.length == 1) {
      _sortedAlbumKeysList.remove(song.album);
    }
    _albums[song.album]!.remove(song);
    if (_artists[song.artist]!.length == 1) {
      _sortedArtistKeysList.remove(song.artist);
    }
    _artists[song.artist]!.remove(song);
    if (_genres[song.genre]!.length == 1) {
      _sortedGenreKeysList.remove(song.genre);
    }
    _genres[song.genre]!.remove(song);
    if (_folders[audioFile.parent.path]!.length == 1) {
      _sortedFolderKeysList.remove(audioFile.parent.path);
    }
    _folders[audioFile.parent.path]!.remove(song);
    _songs.remove(song);
    try {
      await audioFile.delete();
      context.showMaterialSnackBar(
        '${context.loc.deleted} ${song.title}',
      );
    } catch (e) {
      Logger.root.severe('Failed to delete $audioFile.path', e);
      context.showMaterialSnackBar(
        '${context.loc.failedDelete} : ${audioFile.path}\nError: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colorScheme.surface,
      child: Column(
        children: [
          Expanded(
            child: DefaultTabController(
              length: 5,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    widget.title ?? context.loc.myMusic,
                    style: context.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  bottom: TabBar(
                    isScrollable: true,
                    controller: _tcontroller,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelStyle: context.bodyLarge,
                    tabs: [
                      Tab(
                        text: context.loc.tracks,
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
                      Tab(
                        text: context.loc.folders,
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(FluentIcons.search_28_regular),
                      tooltip: context.loc.search,
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: DataSearch(
                            data: _songs,
                            tempPath: tempPath!,
                          ),
                        );
                      },
                    ),
                    // IconButton(
                    //     icon: const Icon(FluentIcons.arrow_sort_28_regular),
                    //     tooltip: context.loc.search,
                    //     onPressed: () => showModalBottomSheet(
                    //         useRootNavigator: true,
                    //         context: context,
                    //         shape: const RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.vertical(
                    //             top: Radius.circular(25.0),
                    //           ),
                    //         ),
                    //         builder: (context) => DownloadFilter(
                    //             onCallBack: (int value) async {
                    //               if (value < 6) {
                    //                 sortValue = value;
                    //                 Hive.box(BoxType.myMusic.name)
                    //                     .put('sortValue', value);
                    //               } else {
                    //                 orderValue = value - 6;
                    //                 Hive.box(BoxType.myMusic.name)
                    //                     .put('orderValue', orderValue);
                    //               }
                    //               await sortSongs(sortValue, orderValue);
                    //               setState(() {});
                    //             },
                    //             sortValue: sortValue,
                    //             orderValue: orderValue))),
                  ],
                  centerTitle: false,
                  elevation: 0,
                ),
                body: !added
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : TabBarView(
                        controller: _tcontroller,
                        children: [
                          SongsTab(
                            songs: _songs,
                            playlistName: widget.title,
                            tempPath: tempPath!,
                          ),
                          AlbumsTab(
                            albums: _albums,
                            albumsList: _sortedAlbumKeysList,
                            tempPath: tempPath!,
                          ),
                          AlbumsTab(
                            albums: _artists,
                            albumsList: _sortedArtistKeysList,
                            tempPath: tempPath!,
                          ),
                          AlbumsTab(
                            albums: _genres,
                            albumsList: _sortedGenreKeysList,
                            tempPath: tempPath!,
                          ),
                          AlbumsTab(
                            albums: _folders,
                            albumsList: _sortedFolderKeysList,
                            tempPath: tempPath!,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
