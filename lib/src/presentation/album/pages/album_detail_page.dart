import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:zmare/src/utils/services/audio/player_service.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/utils/helper/color_ultil.dart';
import 'package:zmare/src/utils/helper/khmertracks_palette.dart';
import 'package:zmare/src/data/album/model/album.dart';
import 'package:zmare/src/data/song/model/item_song_model.dart';
import 'package:zmare/src/presentation/album/bloc/album_bloc.dart';
import 'package:zmare/src/presentation/widgets/item_song_small.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_image.dart';

import 'package:zmare/src/presentation/widgets/texts/khmertracks_subtitle.dart';
import 'package:zmare/src/service_locator.dart';

class AlbumDetailPage extends StatefulWidget {
  const AlbumDetailPage({super.key, required this.album});
  final Album album;
  @override
  State<AlbumDetailPage> createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage> {
  final AlbumBloc albumBloc = locator.get<AlbumBloc>();
  List<ItemSongModel> songList = [];
  final ValueNotifier<List<Color?>?> paletteColor = ValueNotifier([]);
  @override
  void initState() {
    albumBloc.add(GetAlbumTrackEvent(widget.album.id!));
    paletteGenerator(
            imageProvider: CachedNetworkImageProvider(widget.album.image!,
                maxWidth: 80, maxHeight: 80))
        .then((value) => updateButtonColors(value));
    super.initState();
  }

  void updateButtonColors(List<Color?> value) {
    paletteColor.value = value;
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: context.materialYouAppBar(''),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
            child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: KhmertracksImage(
                        imageUrl: widget.album.image!,
                        placeholderImage: Images.defalultArtistCover,
                      )),
                )),
          ),
          ListTile(
              dense: true,
              contentPadding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, top: 0),
              visualDensity: const VisualDensity(vertical: 4),
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox.square(
                    dimension: 56,
                    child: ClipOval(
                      child: KhmertracksImage(
                        imageUrl:
                            songList.isNotEmpty ? songList[0].artistImage! : "",
                        placeholderImage: Images.defalultArtistCover,
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(widget.album.name!,
                  style: context.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurface)),
              subtitle: KhmertracksSubTitle(
                  songList.isNotEmpty ? songList[0].artist : "")),
          const SizedBox(
            height: 8,
          ),
          ValueListenableBuilder(
            valueListenable: paletteColor,
            builder:
                (BuildContext context, List<Color?>? value, Widget? child) {
              final Color? getColor = value!.isNotEmpty
                  ? value[5]
                  : Theme.of(context).colorScheme.primary.withOpacity(0.5);
              final color = Theme.of(context).brightness == Brightness.dark
                  ? lighten(getColor!, 0.4)
                  : darken(getColor!, 0.4);
              return AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    children: [
                      Expanded(
                          child: OutlinedButton.icon(
                        onPressed: () {
                          if (songList.isNotEmpty) {
                            PlayerInvoke.init(
                              songsList:
                                  songList.map((e) => e.toJson()).toList(),
                              index: 0,
                              isOffline: false,
                              shuffle: false,
                            );
                          }
                        },
                        icon: Icon(Icons.play_arrow, color: color),
                        label: Text(
                          context.loc.playAll,
                          style: TextStyle(color: color),
                        ),
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(color: color),
                            shape: const StadiumBorder(),
                            visualDensity: const VisualDensity(vertical: 1)),
                      )),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: OutlinedButton.icon(
                        onPressed: () {
                          if (songList.isNotEmpty) {
                            PlayerInvoke.init(
                              songsList:
                                  songList.map((e) => e.toJson()).toList(),
                              index: 0,
                              isOffline: false,
                              shuffle: true,
                            );
                          }
                        },
                        icon: Icon(
                          FluentIcons.arrow_shuffle_16_regular,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        label: Text(
                          context.loc.shuffle,
                          style: TextStyle(
                            color: context.colorScheme.surface,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Colors.transparent,
                            ),
                            shape: const StadiumBorder(),
                            backgroundColor: color,
                            visualDensity: const VisualDensity(vertical: 1)),
                      )),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            height: 16,
          ),
          BlocProvider(
            create: (context) => albumBloc,
            child: BlocConsumer<AlbumBloc, AlbumState>(
              listener: (context, state) {
                if (state is AlbumLoaded) {
                  songList = state.albumTrack.songList!;
                  setState(() {});
                }
              },
              builder: (context, state) {
                if (state is AlbumLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: songList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return ItemSongSmall(
                          showArtistName: true,
                          songList: songList[index],
                          number: (index + 1).toString(),
                          index: index,
                          listItemSong: songList);
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
