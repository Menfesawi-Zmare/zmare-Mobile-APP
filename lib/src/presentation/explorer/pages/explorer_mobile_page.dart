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
            return ListView(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: explorerModel?.data!.length,
                      itemBuilder: (
                        context,
                        i,
                      ) {
                        if (explorerModel?.data![i].carousels
                            is List<BannerModel>) {
                          return CarouselWidget(
                              banners: explorerModel?.data![i].carousels);
                        } else if (explorerModel?.data![i].artists
                            is List<Artist>) {
                          return ArtistsWidget(
                              artists: explorerModel?.data![i].artists,
                              title: explorerModel!.data![i].title!,
                              type: explorerModel!.data![i].type!);
                        } else if (explorerModel?.data![i].albums
                            is List<Album>) {
                          return AlbumsWidget(
                              albums: explorerModel?.data![i].albums,
                              title: explorerModel!.data![i].title!,
                              type: explorerModel!.data![i].type!);
                        } else if (explorerModel?.data![i].playlists
                            is List<Playlist>) {
                          return PlaylistsWidget(
                            playlists: explorerModel?.data![i].playlists,
                            title: explorerModel!.data![i].title!,
                          );
                        } else if (explorerModel?.data![i].productions
                            is List<Production>) {
                          return ProductionsWidget(
                              productions: explorerModel?.data![i].productions,
                              title: explorerModel!.data![i].title!,
                              type: explorerModel!.data![i].type!);
                        } else if (explorerModel?.data![i].banners is Banners) {
                          return ImageBannerWidget(
                              image: explorerModel!.data![i].banners!.image!,
                              link: explorerModel!.data![i].banners!.link!);
                        } else if (explorerModel?.data![i].ads is Ads) {
                          return AdmobBannerWidget(
                              androidAds: explorerModel?.data![i].ads!.android!,
                              iosAds: explorerModel?.data![i].ads!.ios!);
                        }
                        return null;
                      }),
                ]);
          },
        ),
      ),
    );
  }
}
