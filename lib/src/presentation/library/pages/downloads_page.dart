// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:audiotagger/audiotagger.dart';
import 'package:audiotagger/models/tag.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_music_pro/src/core/resources/resources.dart';
import 'package:flutter_music_pro/src/presentation/widgets/texts/khmertracks_subtitle.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/core/enum/box_types.dart';
import 'package:flutter_music_pro/src/utils/helper/picker.dart';
import 'package:flutter_music_pro/src/utils/services/audio/player_service.dart';
import 'package:flutter_music_pro/src/presentation/library/modal/download_filter.dart';
import 'package:flutter_music_pro/src/presentation/widgets/empty_screen.dart';

import 'package:flutter_music_pro/src/presentation/widgets/playlist_head.dart';

import 'package:flutter_music_pro/src/presentation/widgets/texts/khmertracks_title.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widgets/downloads_search.dart';
import 'liked_songs.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});
  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage>
    with SingleTickerProviderStateMixin {
  Box downloadsBox = Hive.box(BoxType.downloads.name);
  bool added = false;
  List _songs = [];
  final Map<String, List<Map>> _albums = {};
  final Map<String, List<Map>> _artists = {};
  final Map<String, List<Map>> _genres = {};
  List _sortedAlbumKeysList = [];
  List _sortedArtistKeysList = [];
  List _sortedGenreKeysList = [];
  TabController? _tcontroller;
  int sortValue = Hive.box(BoxType.downloadSettings.name)
      .get('sortValue', defaultValue: 1) as int;
  int orderValue = Hive.box(BoxType.downloadSettings.name)
      .get('orderValue', defaultValue: 1) as int;
  int albumSortValue = Hive.box(BoxType.downloadSettings.name)
      .get('albumSortValue', defaultValue: 2) as int;
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showShuffle = ValueNotifier<bool>(true);

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
    getDownloads();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tcontroller!.dispose();
    _scrollController.dispose();
  }

  Future<void> getDownloads() async {
    _songs = downloadsBox.values.toList();
    setArtistAlbum();
  }

  void setArtistAlbum() {
    for (final element in _songs) {
      try {
        if (_albums.containsKey(element['album'])) {
          final List<Map> tempAlbum = _albums[element['album']]!;
          tempAlbum.add(element as Map);
          _albums
              .addEntries([MapEntry(element['album'].toString(), tempAlbum)]);
        } else {
          _albums.addEntries([
            MapEntry(element['album'].toString(), [element as Map])
          ]);
        }

        if (_artists.containsKey(element['artist'])) {
          final List<Map> tempArtist = _artists[element['artist']]!;
          tempArtist.add(element);
          _artists
              .addEntries([MapEntry(element['artist'].toString(), tempArtist)]);
        } else {
          _artists.addEntries([
            MapEntry(element['artist'].toString(), [element])
          ]);
        }

        if (_genres.containsKey(element['genre'])) {
          final List<Map> tempGenre = _genres[element['genre']]!;
          tempGenre.add(element);
          _genres
              .addEntries([MapEntry(element['genre'].toString(), tempGenre)]);
        } else {
          _genres.addEntries([
            MapEntry(element['genre'].toString(), [element])
          ]);
        }
      } catch (e) {
        Logger.root.severe('Error while setting artist and album: $e');
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
    switch (albumSortValue) {
      case 0:
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
        break;
      case 1:
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
        break;
      case 2:
        _sortedAlbumKeysList
            .sort((b, a) => _albums[a]!.length.compareTo(_albums[b]!.length));
        _sortedArtistKeysList
            .sort((b, a) => _artists[a]!.length.compareTo(_artists[b]!.length));
        _sortedGenreKeysList
            .sort((b, a) => _genres[a]!.length.compareTo(_genres[b]!.length));
        break;
      case 3:
        _sortedAlbumKeysList
            .sort((a, b) => _albums[a]!.length.compareTo(_albums[b]!.length));
        _sortedArtistKeysList
            .sort((a, b) => _artists[a]!.length.compareTo(_artists[b]!.length));
        _sortedGenreKeysList
            .sort((a, b) => _genres[a]!.length.compareTo(_genres[b]!.length));
        break;
      default:
        _sortedAlbumKeysList
            .sort((b, a) => _albums[a]!.length.compareTo(_albums[b]!.length));
        _sortedArtistKeysList
            .sort((b, a) => _artists[a]!.length.compareTo(_artists[b]!.length));
        _sortedGenreKeysList
            .sort((b, a) => _genres[a]!.length.compareTo(_genres[b]!.length));
        break;
    }
  }

  Future<void> deleteSong(Map song) async {
    await downloadsBox.delete(song['id']);
    final audioFile = File(song['path'].toString());
    final imageFile = File(song['image'].toString());
    if (_albums[song['album']]!.length == 1) {
      _sortedAlbumKeysList.remove(song['album']);
    }
    _albums[song['album']]!.remove(song);

    if (_artists[song['artist']]!.length == 1) {
      _sortedArtistKeysList.remove(song['artist']);
    }
    _artists[song['artist']]!.remove(song);

    if (_genres[song['genre']]!.length == 1) {
      _sortedGenreKeysList.remove(song['genre']);
    }
    _genres[song['genre']]!.remove(song);

    _songs.remove(song);
    try {
      audioFile.delete();
      if (await imageFile.exists()) {
        imageFile.delete();
      }
      context.showMaterialSnackBar(
        '${context.loc.deleted} ${song['title']}',
      );
    } catch (e) {
      Logger.root.severe('Failed to delete $audioFile.path', e);
      context.showMaterialSnackBar(
          '${context.loc.failedDelete}: ${audioFile.path}\nError: $e');
    }
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
                title: Text(context.loc.down),
                titleTextStyle:
                    context.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                elevation: 0,
                bottom: TabBar(
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
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(FluentIcons.search_28_regular),
                    tooltip: context.loc.search,
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: DownloadsSearch(
                          data: _songs,
                          isDowns: true,
                        ),
                      );
                    },
                  ),
                  if (_songs.isNotEmpty)
                    IconButton(
                        icon: const Icon(FluentIcons.arrow_sort_28_regular),
                        tooltip: context.loc.sortOrder,
                        onPressed: () => showModalBottomSheet(
                            useRootNavigator: true,
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0),
                              ),
                            ),
                            builder: (context) => DownloadFilter(
                                onCallBack: (int value) async {
                                  if (value < 5) {
                                    sortValue = value;
                                    Hive.box(BoxType.downloadSettings.name)
                                        .put('sortValue', value);
                                  } else {
                                    orderValue = value - 5;
                                    Hive.box(BoxType.downloadSettings.name)
                                        .put('orderValue', orderValue);
                                  }
                                  sortSongs(
                                      sortVal: sortValue, order: orderValue);
                                  setState(() {});
                                },
                                sortValue: sortValue,
                                orderValue: orderValue))),
                ],
              ),
              body: !added
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : TabBarView(
                      controller: _tcontroller,
                      children: [
                        DownSongsTab(
                          onDelete: (Map item) {
                            deleteSong(item);
                          },
                          songs: _songs,
                          scrollController: _scrollController,
                        ),
                        AlbumsTab(
                          albums: _albums,
                          offline: true,
                          type: 'album',
                          sortedAlbumKeysList: _sortedAlbumKeysList,
                        ),
                        AlbumsTab(
                          albums: _artists,
                          type: 'artist',
                          // tempPath: tempPath,
                          offline: true,
                          sortedAlbumKeysList: _sortedArtistKeysList,
                        ),
                        AlbumsTab(
                          albums: _genres,
                          type: 'genre',
                          offline: true,
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

Future<Map> editTags(Map song, BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      final tagger = Audiotagger();

      FileImage songImage = FileImage(File(song['image'].toString()));

      final titlecontroller =
          TextEditingController(text: song['title'].toString());
      final albumcontroller =
          TextEditingController(text: song['album'].toString());
      final artistcontroller =
          TextEditingController(text: song['artist'].toString());
      final albumArtistController =
          TextEditingController(text: song['albumArtist'].toString());
      final genrecontroller =
          TextEditingController(text: song['genre'].toString());
      final yearcontroller =
          TextEditingController(text: song['year'].toString());
      final pathcontroller =
          TextEditingController(text: song['path'].toString());

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        content: SizedBox(
          height: 400,
          width: 300,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final String filePath = await Picker.selectFile(
                      context: context,
                      // ext: ['png', 'jpg', 'jpeg'],
                      message: 'Pick Image',
                    );
                    if (filePath != '') {
                      final imagePath = filePath;
                      File(imagePath).copy(song['image'].toString());

                      songImage = FileImage(File(imagePath));

                      final Tag tag = Tag(
                        artwork: imagePath,
                      );
                      try {
                        await [
                          Permission.manageExternalStorage,
                        ].request();
                        await tagger.writeTags(
                          path: song['path'].toString(),
                          tag: tag,
                        );
                      } catch (e) {
                        await tagger.writeTags(
                          path: song['path'].toString(),
                          tag: tag,
                        );
                      }
                    }
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width / 2,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Image(
                        fit: BoxFit.cover,
                        image: songImage,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Text(
                      context.loc.title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                TextField(
                  autofocus: true,
                  controller: titlecontroller,
                  onSubmitted: (value) {},
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      context.loc.artist,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                TextField(
                  autofocus: true,
                  controller: artistcontroller,
                  onSubmitted: (value) {},
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      context.loc.albumArtist,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                TextField(
                  autofocus: true,
                  controller: albumArtistController,
                  onSubmitted: (value) {},
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      context.loc.album,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                TextField(
                  autofocus: true,
                  controller: albumcontroller,
                  onSubmitted: (value) {},
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      context.loc.genre,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                TextField(
                  autofocus: true,
                  controller: genrecontroller,
                  onSubmitted: (value) {},
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      context.loc.year,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                TextField(
                  autofocus: true,
                  controller: yearcontroller,
                  onSubmitted: (value) {},
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      context.loc.songPath,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                TextField(
                  autofocus: true,
                  controller: pathcontroller,
                  onSubmitted: (value) {},
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.grey[700],
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(context.loc.cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () async {
              Navigator.pop(context);
              song['title'] = titlecontroller.text;
              song['album'] = albumcontroller.text;
              song['artist'] = artistcontroller.text;
              song['albumArtist'] = albumArtistController.text;
              song['genre'] = genrecontroller.text;
              song['year'] = yearcontroller.text;
              song['path'] = pathcontroller.text;
              final tag = Tag(
                title: titlecontroller.text,
                artist: artistcontroller.text,
                album: albumcontroller.text,
                genre: genrecontroller.text,
                year: yearcontroller.text,
                albumArtist: albumArtistController.text,
              );
              try {
                try {
                  await [
                    Permission.manageExternalStorage,
                  ].request();
                  tagger.writeTags(
                    path: song['path'].toString(),
                    tag: tag,
                  );
                } catch (e) {
                  await tagger.writeTags(
                    path: song['path'].toString(),
                    tag: tag,
                  );
                  context.showMaterialSnackBar(context.loc.successTagEdit);
                }
              } catch (e) {
                Logger.root.severe('Failed to edit tags', e);
                context.showMaterialSnackBar(
                  '${context.loc.failedTagEdit}\nError: $e',
                );
              }
            },
            child: Text(
              context.loc.ok,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary == Colors.white
                    ? Colors.black
                    : null,
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      );
    },
  );
  return song;
}

class DownSongsTab extends StatefulWidget {
  final List songs;
  final Function(Map item) onDelete;
  final ScrollController scrollController;
  const DownSongsTab({
    super.key,
    required this.songs,
    required this.onDelete,
    required this.scrollController,
  });

  @override
  State<DownSongsTab> createState() => _DownSongsTabState();
}

class _DownSongsTabState extends State<DownSongsTab>
    with AutomaticKeepAliveClientMixin {
  Future<void> downImage(
    String imageFilePath,
    String songFilePath,
    String url,
  ) async {
    final File file = File(imageFilePath);

    try {
      await file.create();
      final image = await Audiotagger().readArtwork(path: songFilePath);
      if (image != null) {
        file.writeAsBytesSync(image);
      }
    } catch (e) {
      final HttpClientRequest request2 =
          await HttpClient().getUrl(Uri.parse(url));
      final HttpClientResponse response2 = await request2.close();
      final bytes2 = await consolidateHttpClientResponseBytes(response2);
      await file.writeAsBytes(bytes2);
    }
  }

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
                offline: true,
                fromDownloads: true,
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      indent: 78,
                      height: 0,
                    );
                  },
                  controller: widget.scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 10),
                  shrinkWrap: true,
                  itemCount: widget.songs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                      minVerticalPadding: 8.0,
                      contentPadding: const EdgeInsets.only(left: 16),
                      leading: SizedBox.square(
                        dimension: 56,
                        child: Image(
                          fit: BoxFit.cover,
                          image: FileImage(
                            File(
                              widget.songs[index]['image'].toString(),
                            ),
                          ),
                          errorBuilder: (_, __, ___) {
                            if (widget.songs[index]['image'] != null &&
                                widget.songs[index]['image_url'] != null) {
                              downImage(
                                widget.songs[index]['image'].toString(),
                                widget.songs[index]['path'].toString(),
                                widget.songs[index]['image_url'].toString(),
                              );
                            }
                            return Image.asset(Images.defalutCover);
                          },
                        ),
                      ),
                      onTap: () {
                        PlayerInvoke.init(
                          songsList: widget.songs,
                          index: index,
                          isOffline: true,
                          fromDownloads: true,
                          recommend: false,
                        );
                      },
                      title:
                          KhmertracksTitle('${widget.songs[index]['title']}'),
                      subtitle: KhmertracksSubTitle(
                        '${widget.songs[index]['artist'] ?? 'Artist name'}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PopupMenuButton(
                            icon: const Icon(Icons.more_horiz_rounded),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 0,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.edit_rounded,
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      context.loc.edit,
                                      style: context.titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 1,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.delete_rounded,
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      context.loc.delete,
                                      style: context.titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (int? value) async {
                              if (value == 0) {
                                widget.songs[index] = await editTags(
                                  widget.songs[index] as Map,
                                  context,
                                );
                                Hive.box(BoxType.downloads.name).put(
                                  widget.songs[index]['id'],
                                  widget.songs[index],
                                );
                                setState(() {});
                              }
                              if (value == 1) {
                                setState(() {
                                  widget.onDelete(widget.songs[index] as Map);
                                });
                              }
                            },
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
