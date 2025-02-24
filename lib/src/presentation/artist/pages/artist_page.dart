// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zmare/src/core/enum/sub_type.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:zmare/src/app/routes.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/utils/services/audio/player_service.dart';
import 'package:zmare/src/data/album/model/album.dart';
import 'package:zmare/src/data/artist/model/artist.dart';
import 'package:zmare/src/data/profile/model/profile.dart';
import 'package:zmare/src/data/song/model/item_song_model.dart';
import 'package:zmare/src/presentation/artist/bloc/artist_bloc.dart';
import 'package:zmare/src/presentation/artist/pages/artist_albums.dart';
import 'package:zmare/src/presentation/login/bloc/auth_bloc.dart';
import 'package:zmare/src/presentation/widgets/item_song_small.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_image.dart';
import 'package:zmare/src/service_locator.dart';
import 'package:readmore/readmore.dart';

class ArtistPage extends StatefulWidget {
  const ArtistPage({super.key, required this.artists});
  final Artist artists;
  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  List<ItemSongModel> songList = [];
  List<Album> albumList = [];
  int totalAlbums = 0;
  int totalSongs = 0;
  int scrobbles = 0;
  int listener = 0;
  String biography = '';
  String profileUrl = '';
  bool isSubscribe = false;
  final ArtistBloc artistBloc = locator.get<ArtistBloc>();
  //Get User Profile
  final accountJson = account.get(accountDetail, defaultValue: '');
  final AuthBloc authBloc = locator.get<AuthBloc>();
  Profile? profile;
  @override
  void initState() {
    profileUrl = widget.artists.image!;
    artistBloc.add(GetArtistDetailEvent(widget.artists.id!));
    artistBloc.add(GetArtistTrackListsEvent(widget.artists.id!, ''));
    artistBloc.add(GetArtistAlbumEvent(widget.artists.id!, 1, ''));
    if (accountJson.toString() != '') {
      profile = Profile?.fromJson(jsonDecode(jsonEncode(accountJson)));
      authBloc.add(GetSubsEvent(widget.artists.id!, 'artist'));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: context.materialYouAppBar(''),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 350,
          toolbarHeight: 40,
          collapsedHeight: 50,
          pinned: true,
          flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            // Calculate how much the app bar is collapsed
            double percentage = (constraints.maxHeight - kToolbarHeight) /
                (250 - kToolbarHeight);

            return FlexibleSpaceBar(
              expandedTitleScale: 1.3,
              titlePadding: EdgeInsets.only(left: percentage > 0.5 ? 0 : 30),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  AspectRatio(
                      aspectRatio: 1 / 1,
                      child: KhmertracksImage(
                        imageUrl: profileUrl,
                        placeholderImage: Images.defalultArtistCover,
                      )),
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            end: Alignment.topCenter,
                            begin: Alignment.bottomCenter,
                            stops: [
                          0.0,
                          1.0,
                        ],
                            colors: [
                          Theme.of(context).colorScheme.surface,
                          Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(0.5),
                          // Colors.transparent
                        ])),
                  ),
                ],
              ),
              // centerTitle: true,
              title: ListTile(
                title: Text(widget.artists.name!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.headlineMedium?.copyWith(
                        color: context.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                dense: true,
                subtitle: Text(
                    '$totalAlbums ${totalAlbums > 1 ? context.loc.albums : context.loc.album}  •  $totalSongs ${totalSongs > 1 ? context.loc.songs : context.loc.song}',
                    style: context.titleMedium!.copyWith(fontSize: 10)),
              ),
            );
          }),
        ),
        SliverToBoxAdapter(
          child: Column(children: [
            Visibility(
              visible: songList.isNotEmpty ? true : false,
              child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: BlocProvider(
                    create: (context) => authBloc,
                    child: BlocConsumer(
                      bloc: authBloc,
                      listener: (context, state) {
                        if (state is GetSubsState) {
                          setState(() {
                            isSubscribe = state.result;
                          });
                        }
                      },
                      builder: (context, state) {
                        return Row(
                          children: [
                            Expanded(
                                child: OutlinedButton.icon(
                              onPressed: () {
                                if (accountJson != '') {
                                  HapticFeedback.mediumImpact();
                                  authBloc.add(AddSubsEvent(
                                      widget.artists.id!, 'artist'));
                                } else {
                                  if (songList.isNotEmpty) {
                                    PlayerInvoke.init(
                                      songsList: songList
                                          .map((e) => e.toJson())
                                          .toList(),
                                      index: 0,
                                      isOffline: false,
                                      shuffle: false,
                                    );
                                  }
                                }
                              },
                              icon: accountJson != ''
                                  ? isSubscribe
                                      ? const Icon(
                                          FluentIcons.person_delete_24_filled)
                                      : const Icon(FluentIcons.add_24_regular)
                                  : const Icon(Icons.play_arrow_rounded),
                              label: Text(
                                  accountJson != ''
                                      ? isSubscribe
                                          ? context.loc.unSubscribe
                                          : context.loc.subscribe
                                      : context.loc.playAll,
                                  style: context.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  visualDensity:
                                      const VisualDensity(vertical: 1)),
                            )),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                                child: OutlinedButton.icon(
                              onPressed: () {
                                if (songList.isNotEmpty) {
                                  PlayerInvoke.init(
                                    songsList: songList
                                        .map((e) => e.toJson())
                                        .toList(),
                                    index: 0,
                                    isOffline: false,
                                    shuffle: true,
                                  );
                                }
                              },
                              icon: Icon(
                                FluentIcons.arrow_shuffle_24_regular,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              label: Text(context.loc.shuffle,
                                  style: context.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: context.onPrimary)),
                              style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                  shape: const StadiumBorder(),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  visualDensity:
                                      const VisualDensity(vertical: 1)),
                            )),
                          ],
                        );
                      },
                    ),
                  )),
            ),
            Visibility(
                visible: totalAlbums > 0 ? true : false,
                child: ArtistAlbums(
                  albumList: albumList,
                  artist: widget.artists,
                )),
            Visibility(
              visible: songList.isNotEmpty ? true : false,
              child: ListTile(
                  contentPadding:
                      const EdgeInsets.only(left: 16.0, right: 0.0, top: 0),
                  title: Text(context.loc.tracks,
                      style: context.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  trailing: Visibility(
                    visible: songList.isNotEmpty
                        ? (songList.length >= 10 ? true : false)
                        : false,
                    child: IconButton(
                      onPressed: () => context.pushNamed(allArtistSongsPath,
                          extra: widget.artists),
                      icon: Icon(
                        FluentIcons.arrow_right_28_regular,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  )),
            ),
            BlocProvider(
              create: (context) => artistBloc,
              child: BlocConsumer(
                bloc: artistBloc,
                listener: (context, state) {
                  if (state is ArtistTrackLoaded) {
                    songList = state.artistTrackList.trackList!;
                    if (accountJson != '') {
                      authBloc.add(GetSubsEvent(
                          widget.artists.id!, SubTypeEnum.artist.name));
                    }
                    setState(() {});
                  }
                  if (state is ArtistDetailLoaded) {
                    setState(() {
                      totalAlbums = state.artistDetail.artist!.albumTotal!;
                      totalSongs = state.artistDetail.artist!.trackTotal!;
                      listener = state.artistDetail.artist!.listener!;
                      scrobbles = state.artistDetail.artist!.subscribers!;
                      biography = state.artistDetail.artist!.description ?? '';
                      if (profileUrl.isEmpty) {
                        profileUrl = state.artistDetail.artist!.image!;
                      }
                    });
                  }
                  if (state is ArtistAlbumsLoaded) {
                    setState(() {
                      albumList = state.all.albumList!;
                    });
                  }
                },
                builder: (context, state) {
                  if (state is ArtistLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(
                    children: [
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: songList.isNotEmpty
                              ? (songList.length > 10
                                  ? songList.sublist(0, 10).length
                                  : songList.length)
                              : songList.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return ItemSongSmall(
                                songList: songList[index],
                                number: (index + 1).toString(),
                                index: index,
                                listItemSong: songList);
                          }),
                    ],
                  );
                },
              ),
            ),
            Visibility(
              visible: biography.isNotEmpty ? true : false,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding:
                          const EdgeInsets.only(left: 0.0, right: 0.0, top: 0),
                      title: Text(context.loc.biography,
                          style: context.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    ReadMoreText(biography,
                        trimLines: 4,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: context.loc.showMore,
                        trimExpandedText: context.loc.showLess,
                        moreStyle: context.titleMedium,
                        style: context.titleMedium),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.loc.listener,
                            style: context.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        Text(
                            NumberFormat.compact()
                                .format(listener.toDouble())
                                .toString(),
                            style: context.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    child: InkWell(
                      onTap: () => scrobbles > 0
                          ? context.pushNamed(artistFollowersPath,
                              extra: widget.artists)
                          : null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.loc.scrobbles,
                              style: context.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          Text(scrobbles.toString(),
                              style: context.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ]),
        )
      ]),
    );
  }
}
