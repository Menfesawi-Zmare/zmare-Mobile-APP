import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:zmare/src/core/theme/zmare_theme.dart';
import 'package:zmare/src/presentation/library/modal/download_filter.dart';
import 'package:zmare/src/presentation/widgets/cover_sliver_appbar.dart';
import 'package:zmare/src/presentation/widgets/data_search.dart';
import 'package:hive/hive.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/utils/services/audio/player_service.dart';

class ShowSongs extends StatefulWidget {
  final List data;
  final String offline;
  final String? title;
  const ShowSongs({
    super.key,
    required this.data,
    required this.offline,
    this.title,
  });
  @override
  State<ShowSongs> createState() => _ShowSongsState();
}

class _ShowSongsState extends State<ShowSongs> {
  List _songs = [];
  List original = [];
  bool offline = false;
  bool added = false;
  bool processStatus = false;
  int sortValue = Hive.box(BoxType.downloadSettings.name)
      .get('sortValue', defaultValue: 1) as int;
  int orderValue = Hive.box(BoxType.downloadSettings.name)
      .get('orderValue', defaultValue: 1) as int;

  Future<void> getSongs() async {
    added = true;
    _songs = widget.data;
    // ignore: sdk_version_since
    offline = bool.parse(widget.offline);
    if (!offline) original = List.from(_songs);

    sortSongs(sortVal: sortValue, order: orderValue);

    processStatus = true;
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

  @override
  Widget build(BuildContext context) {
    if (!added) {
      getSongs();
    }

    return Scaffold(
        body: Material(
            child: Scrollbar(
                child: CustomScrollView(slivers: <Widget>[
      AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        child: CoverSliverAppBar(
          title: widget.title ?? context.loc.songs,
          subtitle: _songs[0]['artist'],
          cover: Image(
            image: getAlbumImage(_songs[0]['image']),
            fit: BoxFit.cover,
          ),
          backgroundColor: bgColor(context.colorScheme.primary),
          button: SizedBox(
            width: 48,
            child: Center(
              child: ElevatedButton(
                onPressed: () => {
                  PlayerInvoke.init(
                    songsList: _songs,
                    index: 0,
                    isOffline: offline,
                    fromDownloads: offline,
                    recommend: !offline,
                  )
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: context.colorScheme.onPrimary,
                  fixedSize: const Size.fromHeight(48),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                ),
                child: const Icon(Icons.play_arrow_rounded),
              ),
            ),
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
                            sortSongs(sortVal: sortValue, order: orderValue);
                            setState(() {});
                          },
                          sortValue: sortValue,
                          orderValue: orderValue))),
          ],
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int d) {
            return ListTile(
              contentPadding: const EdgeInsets.only(left: 16),
              leading: SizedBox(
                height: 56,
                width: 40,
                child: Center(child: Text('${d + 1}')),
              ),
              title: Text(
                '${_songs[d]['title']}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Row(
                children: [
                  Text(
                    '${_songs[d]['artist']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              onTap: () {
                PlayerInvoke.init(
                  songsList: _songs,
                  index: d,
                  isOffline: offline,
                  fromDownloads: offline,
                  recommend: !offline,
                );
              },
            );
          },
          childCount: _songs.length,
        ),
      ),
    ]))));
  }
}
