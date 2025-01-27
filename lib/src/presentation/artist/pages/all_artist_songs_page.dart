import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/data/artist/model/artist.dart';
import 'package:flutter_music_pro/src/data/song/model/item_song_model.dart';
import 'package:flutter_music_pro/src/presentation/artist/bloc/artist_bloc.dart';
import 'package:flutter_music_pro/src/presentation/modal/modal_filter.dart';
import 'package:flutter_music_pro/src/presentation/widgets/item_list_big.dart';
import 'package:flutter_music_pro/src/service_locator.dart';

class AllArtistSongPage extends StatefulWidget {
  const AllArtistSongPage({super.key, required this.artist});
  final Artist artist;

  @override
  State<AllArtistSongPage> createState() => _AllArtistSongPageState();
}

class _AllArtistSongPageState extends State<AllArtistSongPage> {
  final ArtistBloc artistBloc = locator.get<ArtistBloc>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<ItemSongModel> allSong = [];
  int selectedFilter = 1;
  @override
  void initState() {
    artistBloc.add(GetArtistAllTrackListsEvent(widget.artist.id!, 'all'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: context.materialYouAppBar(context.loc.allSongs, actions: [
        IconButton(
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
                builder: (context) => ModalFilter(
                  songList: allSong,
                  onCallBack: (List<ItemSongModel> songList) {
                    setState(() {
                      allSong = songList;
                    });
                  },
                  selectedFilter: selectedFilter,
                  onSetSelectedId: (int setSelectedId) {
                    setState(() {
                      selectedFilter = setSelectedId;
                    });
                  },
                ),
              );
            },
            icon: const Icon(Icons.sort_rounded))
      ]),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        strokeWidth: 2.0,
        onRefresh: () async {
          setState(() {
            selectedFilter = 1;
          });
          allSong = [];
          artistBloc
              .add(GetArtistAllTrackListsEvent(widget.artist.id!, 'all'));
          return Future<void>.delayed(const Duration(seconds: 1));
        },
        child: BlocProvider(
          create: (context) => artistBloc,
          child: BlocConsumer(
            bloc: artistBloc,
            listener: (context, state) {
              if (state is ArtistTrackLoaded) {
                allSong = state.artistTrackList.trackList!;
              }
            },
            builder: (context, state) {
              if (state is ArtistTrackLoaded) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                          separatorBuilder: (context, index) => const Divider(
                                indent: 78,
                                height: 0,
                              ),
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          shrinkWrap: true,
                          primary: false,
                          itemCount: allSong.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return ItemListBig(
                                songList: allSong[index],
                                listItemSong: allSong);
                          }),
                    ),
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),      
    );
  }
}
