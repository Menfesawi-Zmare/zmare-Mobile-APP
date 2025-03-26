import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zmare/src/data/playlist/model/playlist.dart';
import 'package:zmare/src/presentation/explorer/widgets/admob_banner_widget.dart';
import 'package:zmare/src/presentation/explorer/widgets/carousel_widget.dart';
import 'package:zmare/src/presentation/explorer/widgets/image_banner_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/data/album/model/album.dart';
import 'package:zmare/src/data/artist/model/artist.dart';
import 'package:zmare/src/data/production/model/production.dart';
import 'package:zmare/src/presentation/explorer/bloc/bloc/explorer_bloc.dart';
import 'package:zmare/src/presentation/explorer/widgets/albums_widget.dart';
import 'package:zmare/src/presentation/explorer/widgets/artists_widget.dart';
import 'package:zmare/src/presentation/explorer/widgets/productions_widget.dart';
import 'package:zmare/src/presentation/player/pages/audioplayer.dart';
import 'package:zmare/src/presentation/widgets/no_result_widget.dart';
import 'package:zmare/src/service_locator.dart';
import 'package:zmare/src/utils/ext/build_context_extension.dart';
import '../../../data/explorer/model/explorer_model.dart';
import '../widgets/playlists_widget.dart';

class ExplorerMobilePage extends StatefulWidget {
  const ExplorerMobilePage({super.key});

  @override
  State<ExplorerMobilePage> createState() => _ExplorerMobilePageState();
}

class _ExplorerMobilePageState extends State<ExplorerMobilePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  AudioPlayerHandler audioHandler = locator<AudioPlayerHandler>();
  Box<dynamic> playerSettings = locator.get(
    instanceName: BoxType.player.name,
  );
  final ExplorerBloc explorerBloc = locator.get<ExplorerBloc>();
  ExplorerModel? explorerModel;
  @override
  void initState() {
    explorerBloc.add(GetExplorerEvent());
    super.initState();
  }

  void refresh() {
    explorerBloc.add(GetExplorerEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      strokeWidth: 2.0,
      onRefresh: () {
        refresh();
        didChangeDependencies();
        return Future<void>.delayed(const Duration(seconds: 1));
      },
      child: BlocProvider(
        create: (context) => explorerBloc,
        child: BlocConsumer(
          bloc: explorerBloc,
          listener: (context, state) {
            if (state is ExplorerLoaded) {
              explorerModel = state.explorerModel;
            }
          },
          builder: (context, state) {
            if (state is ExplorerLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ExplorerFailedState || state is NoDataFailure) {
              return Center(
                child:
                    NoResultWidget(showRefresh: true, onTap: () => refresh()),
              );
            }
            if (state is ExplorerLoaded) {
              // Check if ALL data lists are empty (or null)
              bool isAllDataEmpty = explorerModel!.data!.every((item) {
                return (item.carousels?.isEmpty ?? true) &&
                    (item.artists?.isEmpty ?? true) &&
                    (item.albums?.isEmpty ?? true) &&
                    (item.playlists?.isEmpty ?? true) &&
                    (item.productions?.isEmpty ?? true) &&
                    (item.banners == null) &&
                    (item.ads == null);
              });

              // If ALL data is empty, show NoResultWidget
              if (isAllDataEmpty) {
                return Center(
                  child:
                      NoResultWidget(showRefresh: true, onTap: () => refresh()),
                );
              }

              // Otherwise, build the ListView
              return ListView(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: explorerModel?.data?.length,
                    itemBuilder: (context, i) {
                      final item = explorerModel?.data?[i];
                      if (item == null) return const SizedBox.shrink();

                      if (item.carousels is List<BannerModel> &&
                          item.carousels!.isNotEmpty) {
                        return CarouselWidget(banners: item.carousels);
                      } else if (item.artists is List<Artist> &&
                          item.artists!.isNotEmpty) {
                        return ArtistsWidget(
                          artists: item.artists,
                          title: context.loc.artists,
                          type: "0",
                        );
                      } else if (item.albums is List<Album> &&
                          item.albums!.isNotEmpty) {
                        return AlbumsWidget(
                          albums: item.albums,
                          title: context.loc.albums,
                          type: "1",
                        );
                      } else if (item.playlists is List<Playlist> &&
                          item.playlists!.isNotEmpty) {
                        return PlaylistsWidget(
                          playlists: item.playlists,
                          title: context.loc.playlist,
                        );
                      } else if (item.productions is List<Production> &&
                          item.productions!.isNotEmpty) {
                        return ProductionsWidget(
                          productions: item.productions,
                          title: item.title ?? "",
                          type: "2",
                        );
                      } else if (item.banners is Banners &&
                          item.banners!.image != null) {
                        return ImageBannerWidget(
                          image: item.banners!.image!,
                          link: item.banners!.link!,
                        );
                      } else if (item.ads is Ads) {
                        return AdmobBannerWidget(
                          androidAds: item.ads!.android!,
                          iosAds: item.ads!.ios!,
                        );
                      } else {
                        return const SizedBox.shrink(); // Skip empty sections
                      }
                    },
                  ),
                ],
              );
            }

            // Fallback (should not reach here if all states are handled)
            return Center(
              child: NoResultWidget(showRefresh: true, onTap: () => refresh()),
            );
          },
        ),
      ),
    );
  }
}
