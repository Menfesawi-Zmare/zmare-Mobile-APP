import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/data/profile/model/profile.dart';
import 'package:flutter_music_pro/src/presentation/profile/bloc/profile_bloc.dart';
import 'package:flutter_music_pro/src/presentation/widgets/item_playlist_big.dart';

import 'package:flutter_music_pro/src/service_locator.dart';

import '../../../data/playlist/model/playlist.dart';

class UserPlaylistPage extends StatefulWidget {
  const UserPlaylistPage({super.key, required this.profile});
  final Profile profile;
  @override
  State<UserPlaylistPage> createState() => _UserPlaylistPageState();
}

class _UserPlaylistPageState extends State<UserPlaylistPage> {
  final ProfileBloc profileBloc = locator.get<ProfileBloc>();
  final PagingController<int, Playlist> _pagingController =
      PagingController(firstPageKey: 1);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Playlist>? playlists = [];
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      profileBloc.add(GetProfilePlaylists(widget.profile.id!, pageKey));
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(    
      appBar: context.materialYouAppBar(context.loc.playlists),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        strokeWidth: 2.0,
        onRefresh: () async {
          _pagingController.refresh();
          profileBloc.add(GetProfilePlaylists(widget.profile.id!, 1));
          return Future<void>.delayed(const Duration(seconds: 1));
        },
        child: BlocProvider(
          create: (context) => profileBloc,
          child: BlocConsumer(
            bloc: profileBloc,
            listener: (context, state) {
              if (state is ProfilePlaylists) {
                playlists = state.playlistList.playlist!;
                final isLastPage =
                    playlists!.length < state.playlistList.pagination!.perPage!;
                if (isLastPage) {
                  _pagingController.appendLastPage(playlists!);
                } else {
                  _pagingController.appendPage(
                      playlists!, state.playlistList.pagination!.currentPage! + 1);
                }
              }
              if (state is ProfileFailed) {
                _pagingController.error = state.message;
              }
              if(state is NoData){
                _pagingController.appendLastPage([]);
              }
            },
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return PagedListView(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Playlist>(
                      itemBuilder: (context, item, index) =>
                          ItemPlaylistBig(playlist: item, action: true)));
            },
          ),
        ),
      ),
    );
  }
}
