import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:go_router/go_router.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/playlist_privacy_type.dart';
import 'package:zmare/src/utils/helper/dominant_color.dart';
import 'package:zmare/src/data/playlist/model/playlists_request_model.dart';
import 'package:zmare/src/data/song/model/item_song_model.dart';
import 'package:zmare/src/presentation/login/bloc/auth_bloc.dart';
import 'package:zmare/src/presentation/modal/modal_playlist_description.dart';
import 'package:zmare/src/presentation/modal/modal_update_playlist.dart';
import 'package:zmare/src/presentation/playlist/bloc/playlist_bloc.dart';
import 'package:zmare/src/presentation/widgets/download_button.dart';
import 'package:zmare/src/presentation/widgets/item_song_small.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_bottom_sheet.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_image.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_text.dart';

import 'package:zmare/src/presentation/widgets/play_and_shuffle_button.dart';
import 'package:zmare/src/service_locator.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/playlist/model/playlist.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key, required this.playlist, this.action = ''});
  final Playlist playlist;
  final String action;
  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  GlobalKey widgetKey = GlobalKey();
  Offset? widgetOffset;
  double? currentPosition;
  double opacity = 0;
  final ScrollController scrollController = ScrollController();
  List<ItemSongModel> songList = [];
  List<ItemSongModel> recommendedMusics = [];
  late ItemSongModel addItemSong;
  final ValueNotifier<List<Color?>?> gradientColor =
      ValueNotifier(defaultGradientColor);
  final AuthBloc authBloc = locator.get<AuthBloc>();
  final PlaylistBloc playlistBloc = locator.get<PlaylistBloc>();
  late Playlist playlist;
  @override
  void initState() {
    playlist = widget.playlist;
    playlistBloc.add(GetPlaylistEvent(playlist.id!));
    getColors(
      imageProvider: CachedNetworkImageProvider(playlist.image!,
          maxWidth: 80, maxHeight: 80),
    ).then((value) => updateBackgroundColors(value));
    scrollController.addListener(scrollListener);
    super.initState();
  }

  void updateBackgroundColors(List<Color?> value) {
    gradientColor.value = value;
    return;
  }

  void scrollListener() {
    final double expandedHeight = MediaQuery.of(context).size.height * 0.162;
    if (scrollController.offset.roundToDouble() > expandedHeight) {
      opacity = opacity;
    } else {
      scrollController.offset.roundToDouble() / (expandedHeight) > 0
          ? opacity = scrollController.offset.roundToDouble() / (expandedHeight)
          : opacity = 0;
    }
    setState(() {});
  }

  @override
  void dispose() {
    scrollController.dispose();
    authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authBloc,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AddToPlaylistState) {
            if (state.addToPlaylistResponse.status == true) {
              setState(() {
                songList.remove(addItemSong);
              });
            }
          }
          if (state is DeletePlaylistState) {
            if (state.result == true) {
              context.pop();
              context.showMaterialSnackBar(context.loc.playlistDeleted);
            }
          }
          if (state is Failure) {
            context.showMaterialSnackBar(state.message);
          }
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          // appBar: AppBar(
          //   elevation: 0,
          //   backgroundColor:
          //       opacity < 0.6 ? Colors.transparent.withOpacity(opacity) : null,
          //   title: Opacity(
          //     opacity: opacity,
          //     child: Text(playlist.name!,
          //         overflow: TextOverflow.ellipsis,
          //         style: context.titleLarge
          //             ?.copyWith(fontWeight: FontWeight.bold)),
          //   ),
          //   centerTitle: false,
          //   actions: [
          //     if (widget.action.toLowerCase() == 'true')
          //       IconButton(
          //           onPressed: () => khmertracksAlertDialog(
          //                 context,
          //                 title: KhmertracksText(
          //                   text: context.loc.deletePlaylist,
          //                   isBold: true,
          //                 ),
          //                 child: const SizedBox.shrink(),
          //                 confirmationButton: TextButton(
          //                   style: TextButton.styleFrom(
          //                     backgroundColor:
          //                         Theme.of(context).colorScheme.primary,
          //                     padding:
          //                         const EdgeInsets.symmetric(horizontal: 16),
          //                   ),
          //                   onPressed: () {
          //                     authBloc.add(DeletePlaylistEvent(playlist.id!));
          //                     context.pop();
          //                   },
          //                   child: Text(context.loc.delete,
          //                       style: TextStyle(
          //                           color: context.colorScheme.onPrimary)),
          //                 ),
          //               ),
          //           icon: Icon(
          //             FluentIcons.delete_12_regular,
          //             color: Theme.of(context).colorScheme.onSurface,
          //           ))
          //     else
          //       const SizedBox.shrink()
          //   ],
          // ),

          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 350,
                toolbarHeight: 40,
                collapsedHeight: 50,
                pinned: true,
                flexibleSpace: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  // Calculate how much the app bar is collapsed
                  double percentage = (constraints.maxHeight - kToolbarHeight) /
                      (250 - kToolbarHeight);

                  return FlexibleSpaceBar(
                      expandedTitleScale: 1.3,
                      titlePadding:
                          EdgeInsets.only(left: percentage > 0.5 ? 0 : 30),
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          AspectRatio(
                              aspectRatio: 1 / 1,
                              child: KhmertracksImage(
                                imageUrl: playlist.image!,
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
                      title: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(playlist.name!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.headlineMedium?.copyWith(
                                        color: context.onSurface,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                                if (percentage > 0.5)
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '${songList.length.toString()} ${songList.length > 1 ? context.loc.songs : context.loc.song} ',
                                          style: context.labelMedium!.copyWith(
                                              color: context.bodySmall!.color,
                                              fontSize: 10),
                                        ),
                                        WidgetSpan(
                                          child: playlist.public! == 1
                                              ? Icon(
                                                  FluentIcons.globe_24_regular,
                                                  size: 14,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .color)
                                              : Icon(
                                                  FluentIcons
                                                      .lock_closed_24_regular,
                                                  size: 14,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .color),
                                        ),
                                        TextSpan(
                                          text:
                                              ' ${PlaylistPrivacyType.values.firstWhere((e) => e.toIndex == playlist.public!).name(context)}',
                                          style: context.labelMedium!.copyWith(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .color,
                                              fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (percentage > 0.5)
                                  Text(
                                      context.loc
                                          .createBy(playlist.ownerName ?? ""),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.headlineMedium?.copyWith(
                                          color: context.onSurface,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w300)),
                              ],
                            ),
                            Row(
                              // spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // if (songList.isNotEmpty)
                                //   MultiDownloadButton(
                                //     data: songList
                                //         .map((e) => e.toJson())
                                //         .toList(),
                                //     playlistName: playlist.name!,
                                //   )
                                // else
                                //   SizedBox.shrink(),
                                SizedBox(
                                  width: 35,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        Navigator.of(context).push(
                                            MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) {
                                                  return ModalUpdatePlaylist(
                                                    playlist: playlist,
                                                    bloc: authBloc,
                                                    onCallBack:
                                                        (Playlist updated) {
                                                      setState(() {
                                                        playlist = updated;
                                                      });
                                                      context.showMaterialSnackBar(
                                                          context.loc
                                                              .playlistUpdated);
                                                    },
                                                  );
                                                },
                                                fullscreenDialog: true));
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: const CircleBorder(),
                                          padding: const EdgeInsets.all(0),
                                          backgroundColor:
                                              context.primaryContainer),
                                      child: const Icon(
                                          FluentIcons.edit_16_regular,
                                          size: 17,
                                          color: Colors.white)),
                                ),
                              ],
                            ),

                            // SizedBox(
                            //   width: 45,
                            //   child: ElevatedButton(
                            //       onPressed: () {
                            //         Share.share(
                            //           '${playlist.name} ${context.loc.createBy(playlist.ownerName!)} ${playlist.url}',
                            //           subject: playlist.name,
                            //         );
                            //       },
                            //       style: ElevatedButton.styleFrom(
                            //           shape: const CircleBorder(),
                            //           padding: EdgeInsets.zero,
                            //           backgroundColor: Colors.grey),
                            //       child: const Icon(
                            //           FluentIcons.share_16_regular,
                            //           color: Colors.white)),
                            // )
                          ],
                        ),
                      ));
                }),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Visibility(
                      visible: playlist.description != null ? true : false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                useRootNavigator: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25.0),
                                  ),
                                ),
                                builder: (context) => ModalPlaylistDescrition(
                                    description: playlist.description ?? ''));
                          },
                          child: Text(
                            playlist.description ?? '',
                            maxLines: 3,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: context.titleMedium!.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Visibility(
                          visible: songList.isNotEmpty ? true : false,
                          child: PlayAndShuffleButton(songList: songList)),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    BlocProvider(
                      create: (context) => playlistBloc,
                      child: BlocConsumer<PlaylistBloc, PlaylistState>(
                        listener: (context, state) {
                          if (state is PlaylistLoaded) {
                            setState(() {
                              songList = state.trackList.songList!;
                            });
                          }
                        },
                        builder: (context, state) {
                          if (state is PlaylistLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: songList.length,
                              // itemCount: 100,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                // return Text("hello");
                                return ItemSongSmall(
                                    showArtistName: true,
                                    songList: songList[index],
                                    number: (index + 1).toString(),
                                    index: index,
                                    listItemSong: songList,
                                    action:
                                        widget.action.toLowerCase() == 'true'
                                            ? true
                                            : false,
                                    playlist: widget.playlist,
                                    onRemoveCallBack: (Playlist playlist) {
                                      setState(() {
                                        addItemSong = songList[index];
                                      });
                                      authBloc.add(AddToPlaylistEvent(
                                          PlaylistsRequestModel(
                                              trackId: songList[index].id,
                                              playlistId: playlist.id!)));
                                    });
                              });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // body: ListView(
          //     controller: scrollController,
          //     padding: const EdgeInsets.only(top: 0),
          //     children: [
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           ValueListenableBuilder(
          //             valueListenable: gradientColor,
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Padding(
          //                   padding: const EdgeInsets.only(
          //                       left: 10, right: 10, top: kToolbarHeight * 1.9),
          //                   child: SizedBox(
          //                     width: double.infinity,
          //                     height: 200,
          //                     child: AspectRatio(
          //                         aspectRatio: 1 / 1,
          //                         child: Card(
          //                           elevation: 1,
          //                           shape: RoundedRectangleBorder(
          //                             borderRadius: BorderRadius.circular(40.0),
          //                           ),
          //                           child: ClipRRect(
          //                               borderRadius: BorderRadius.circular(12),
          //                               child: KhmertracksImage(
          //                                 imageUrl: playlist.image!,
          //                                 placeholderImage: Images.defalutCover,
          //                               )),
          //                         )),
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.only(
          //                       left: 16, right: 16, top: 10),
          //                   child: KhmertracksText(
          //                     text: playlist.name!,
          //                     isBold: true,
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.only(
          //                       left: 16, right: 16, bottom: 5),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     crossAxisAlignment: CrossAxisAlignment.center,
          //                     children: [
          //                       Column(
          //                         crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: [
          // KhmertracksText(
          //   text: context.loc
          //       .createBy(playlist.ownerName ?? ""),
          //   isSmall: true,
          //   isBold: true,
          // ),
          //                           const SizedBox(height: 5),
          // RichText(
          //   text: TextSpan(
          //     children: [
          //       TextSpan(
          //         text:
          //             '${songList.length.toString()} ${songList.length > 1 ? context.loc.songs : context.loc.song} ',
          //         style: context.labelMedium!
          //             .copyWith(
          //                 color: context
          //                     .bodySmall!.color),
          //       ),
          //       WidgetSpan(
          //         child: playlist.public! == 1
          //             ? Icon(
          //                 FluentIcons
          //                     .globe_24_regular,
          //                 size: 14,
          //                 color: Theme.of(context)
          //                     .textTheme
          //                     .bodySmall!
          //                     .color)
          //             : Icon(
          //                 FluentIcons
          //                     .lock_closed_24_regular,
          //                 size: 14,
          //                 color: Theme.of(context)
          //                     .textTheme
          //                     .bodySmall!
          //                     .color),
          //       ),
          //       TextSpan(
          //         text:
          //             ' ${PlaylistPrivacyType.values.firstWhere((e) => e.toIndex == playlist.public!).name(context)}',
          //         style: context.labelMedium!
          //             .copyWith(
          //                 color: Theme.of(context)
          //                     .textTheme
          //                     .bodySmall!
          //                     .color),
          //       ),
          //     ],
          //   ),
          // )
          //                         ],
          //                       ),
          //                       Wrap(children: <Widget>[
          //                         Visibility(
          //                           visible:
          //                               widget.action.toLowerCase() == 'true'
          //                                   ? true
          //                                   : false,
          // child: SizedBox(
          //   width: 45,
          //   child: ElevatedButton(
          //       onPressed: () {
          //         HapticFeedback.mediumImpact();
          //         Navigator.of(context).push(
          //             MaterialPageRoute<void>(
          //                 builder:
          //                     (BuildContext context) {
          //                   return ModalUpdatePlaylist(
          //                     playlist: playlist,
          //                     bloc: authBloc,
          //                     onCallBack:
          //                         (Playlist updated) {
          //                       setState(() {
          //                         playlist = updated;
          //                       });
          //                       context.showMaterialSnackBar(
          //                           context.loc
          //                               .playlistUpdated);
          //                     },
          //                   );
          //                 },
          //                 fullscreenDialog: true));
          //       },
          //       style: ElevatedButton.styleFrom(
          //           shape: const CircleBorder(),
          //           padding: const EdgeInsets.all(0),
          //           backgroundColor: Colors.grey),
          //       child: const Icon(
          //           FluentIcons.edit_16_regular,
          //           color: Colors.white)),
          // ),
          //                         ),
          // if (songList.isNotEmpty)
          //   MultiDownloadButton(
          //     data: songList
          //         .map((e) => e.toJson())
          //         .toList(),
          //     playlistName: playlist.name!,
          //   )
          // else
          //   const SizedBox.shrink(),
          // SizedBox(
          //   width: 45,
          //   child: ElevatedButton(
          //       onPressed: () {
          //         Share.share(
          //           '${playlist.name} ${context.loc.createBy(playlist.ownerName!)} ${playlist.url}',
          //           subject: playlist.name,
          //         );
          //       },
          //       style: ElevatedButton.styleFrom(
          //           shape: const CircleBorder(),
          //           padding: EdgeInsets.zero,
          //           backgroundColor: Colors.grey),
          //       child: const Icon(
          //           FluentIcons.share_16_regular,
          //           color: Colors.white)),
          // )
          //                       ]),
          //                     ],
          //                   ),
          //                 ),
          // Visibility(
          //   visible:
          //       playlist.description != null ? true : false,
          //   child: Padding(
          //     padding:
          //         const EdgeInsets.symmetric(horizontal: 16),
          //     child: InkWell(
          //       onTap: () {
          //         showModalBottomSheet(
          //             context: context,
          //             useRootNavigator: true,
          //             shape: const RoundedRectangleBorder(
          //               borderRadius: BorderRadius.vertical(
          //                 top: Radius.circular(25.0),
          //               ),
          //             ),
          //             builder: (context) =>
          //                 ModalPlaylistDescrition(
          //                     description:
          //                         playlist.description ?? ''));
          //       },
          //       child: Text(
          //         playlist.description ?? '',
          //         maxLines: 2,
          //         overflow: TextOverflow.ellipsis,
          //         style: context.titleMedium!,
          //       ),
          //     ),
          //   ),
          // ),
          //                 const SizedBox(
          //                   height: 16,
          //                 ),
          // Visibility(
          //     visible: songList.isNotEmpty ? true : false,
          //     child: PlayAndShuffleButton(songList: songList)),
          // const SizedBox(
          //   height: 16,
          // ),
          //               ],
          //             ),
          //             builder: (BuildContext context, List<Color?>? value,
          //                 Widget? child) {
          //               return AnimatedContainer(
          //                 duration: const Duration(milliseconds: 600),
          //                 decoration: BoxDecoration(
          //                   gradient: LinearGradient(
          //                     begin: Alignment.topCenter,
          //                     end: Alignment.bottomCenter,
          //                     colors: Theme.of(context).brightness ==
          //                             Brightness.dark
          //                         ? [
          //                             value?[1] ?? Colors.grey[900]!,
          //                             context.colorScheme.surface,
          //                           ]
          //                         : [
          //                             value?[1] ?? const Color(0xfff5f9ff),
          //                             context.colorScheme.surface,
          //                           ],
          //                   ),
          //                 ),
          //                 child: child,
          //               );
          //             },
          //           ),
          // BlocProvider(
          //   create: (context) => playlistBloc,
          //   child: BlocConsumer<PlaylistBloc, PlaylistState>(
          //     listener: (context, state) {
          //       if (state is PlaylistLoaded) {
          //         setState(() {
          //           songList = state.trackList.songList!;
          //         });
          //       }
          //     },
          //     builder: (context, state) {
          //       if (state is PlaylistLoading) {
          //         return const Center(
          //           child: CircularProgressIndicator(),
          //         );
          //       }
          //       return ListView.builder(
          //           padding: EdgeInsets.zero,
          //           shrinkWrap: true,
          //           itemCount: 100,
          //           physics: const NeverScrollableScrollPhysics(),
          //           scrollDirection: Axis.vertical,
          //           itemBuilder: (BuildContext context, int index) {
          //             return Text("hello");
          //             // return ItemSongSmall(
          //             //     showArtistName: true,
          //             //     songList: songList[index],
          //             //     number: (index + 1).toString(),
          //             //     index: index,
          //             //     listItemSong: songList,
          //             //     action:
          //             //         widget.action.toLowerCase() == 'true'
          //             //             ? true
          //             //             : false,
          //             //     playlist: widget.playlist,
          //             //     onRemoveCallBack: (Playlist playlist) {
          //             //       setState(() {
          //             //         addItemSong = songList[index];
          //             //       });
          //             //       authBloc.add(AddToPlaylistEvent(
          //             //           PlaylistsRequestModel(
          //             //               trackId: songList[index].id,
          //             //               playlistId: playlist.id!)));
          //             //     });
          //           });
          //     },
          //   ),
          // ),
          //         ],
          //       ),
          //     ]),
        ),
      ),
    );
  }
}
