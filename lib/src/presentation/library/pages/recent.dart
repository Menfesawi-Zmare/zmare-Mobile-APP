// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/utils/services/audio/player_service.dart';
import 'package:zmare/src/data/song/model/item_song_model.dart';
import 'package:zmare/src/presentation/modal/modal_more.dart';
import 'package:zmare/src/presentation/widgets/empty_screen.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_image.dart';

import 'package:zmare/src/presentation/widgets/texts/khmertracks_subtitle.dart';
import 'package:zmare/src/presentation/widgets/texts/khmertracks_title.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RecentlyPlayed extends StatefulWidget {
  const RecentlyPlayed({super.key});

  @override
  State<RecentlyPlayed> createState() => _RecentlyPlayedState();
}

class _RecentlyPlayedState extends State<RecentlyPlayed> {
  List _songs = [];
  bool added = false;

  Future<void> getSongs() async {
    _songs = Hive.box(BoxType.cache.name).get('recentSongs', defaultValue: [])
        as List;
    added = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!added) {
      getSongs();
    }

    return Scaffold(
        appBar: context.materialYouAppBar(
          context.loc.history,
          actions: [
            IconButton(
              onPressed: () {
                Hive.box(BoxType.cache.name).put('recentSongs', []);
                setState(() {
                  _songs = [];
                });
              },
              tooltip: context.loc.clearAll,
              icon: const Icon(Icons.clear_all_rounded),
            ),
          ],
        ),
        body: _songs.isEmpty
            ? emptyScreen(
                context,
                3,
                context.loc.nothingTo,
                15,
                context.loc.showHere,
                50.0,
                context.loc.playSomething,
                23.0,
              )
            : ListView.separated(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: _songs.length,
                separatorBuilder: (context, index) => Divider(
                      indent: 78,
                      height: 0,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withOpacity(0.3),
                    ),
                itemBuilder: (context, index) {
                  return _songs.isEmpty
                      ? const SizedBox()
                      : Dismissible(
                          key: Key(_songs[index]['id'].toString()),
                          direction: DismissDirection.endToStart,
                          background: const ColoredBox(
                            color: Colors.redAccent,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.delete_outline_rounded),
                                ],
                              ),
                            ),
                          ),
                          onDismissed: (direction) {
                            _songs.removeAt(index);
                            setState(() {});
                            Hive.box(BoxType.cache.name)
                                .put('recentSongs', _songs);
                          },
                          child: ListTile(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0))),
                            dense: true,
                            contentPadding:
                                const EdgeInsets.only(left: 10.0, right: 0.0),
                            horizontalTitleGap: 10.0,
                            minVerticalPadding: 0,
                            visualDensity: const VisualDensity(vertical: 2),
                            leading: SizedBox.square(
                              dimension: 56,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: _songs[index]['image']
                                          .toString()
                                          .startsWith('file:')
                                      ? Image(
                                          fit: BoxFit.cover,
                                          image: FileImage(
                                            File(
                                              Uri.parse(_songs[index]['image']
                                                      .toString())
                                                  .toFilePath(),
                                            ),
                                          ),
                                        )
                                      : KhmertracksImage(
                                          imageUrl: _songs[index]['image'],
                                          placeholderImage: Images.defalutCover,
                                        ),
                                ),
                              ),
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  HapticFeedback.mediumImpact();
                                  showModalBottomSheet(
                                    context: context,
                                    useRootNavigator: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25.0),
                                      ),
                                    ),
                                    builder: (context) => ModalMore(
                                        songList: ItemSongModel(
                                      id: int.parse(_songs[index]['id']),
                                      artist: _songs[index]['artist'],
                                      artistId: _songs[index]['artist_id'],
                                      album: _songs[index]['album'],
                                      albumCover: _songs[index]['album_cover'],
                                      albumId: _songs[index]['album_id'],
                                      title: _songs[index]['title'],
                                      image: _songs[index]['image'],
                                      url: _songs[index]['url'],
                                      link: _songs[index]['link'],
                                    )),
                                  );
                                },
                                icon: Icon(MdiIcons.dotsHorizontal)),
                            title: KhmertracksTitle(
                              '${_songs[index]["title"]}',
                              maxLines: 1,
                            ),
                            subtitle: KhmertracksSubTitle(
                              '${_songs[index]["artist"]}',
                            ),
                            onTap: () {
                              PlayerInvoke.init(
                                songsList: _songs,
                                index: index,
                                isOffline: false,
                              );
                              Navigator.pushNamed(context, '/player');
                            },
                          ),
                        );
                }));
  }
}
