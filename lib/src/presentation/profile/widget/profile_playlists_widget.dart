import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:zmare/src/presentation/profile/bloc/profile_bloc.dart';
import 'package:zmare/src/presentation/widgets/item_playlist.dart';
import 'package:zmare/src/presentation/widgets/no_result_widget.dart';
import 'package:zmare/src/service_locator.dart';

import '../../../data/playlist/model/playlist.dart';

class ProfilePlaylistsWidget extends StatefulWidget {
  const ProfilePlaylistsWidget(
      {super.key,
      required this.profileId,
      this.action = false,
      this.username = ""});
  final int profileId;
  final bool action;
  final String username;
  @override
  State<ProfilePlaylistsWidget> createState() => _ProfilePlaylistsWidgetState();
}

class _ProfilePlaylistsWidgetState extends State<ProfilePlaylistsWidget> {
  final ProfileBloc profileBloc = locator.get<ProfileBloc>();
  final PagingController<int, Playlist> _pagingController =
      PagingController(firstPageKey: 1);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Playlist>? playlists = [];
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      profileBloc.add(GetProfilePlaylists(widget.profileId, pageKey));
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
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      strokeWidth: 2.0,
      onRefresh: () async {
        _pagingController.refresh();
        profileBloc.add(GetProfilePlaylists(widget.profileId, 1));
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
                _pagingController.appendPage(playlists!,
                    state.playlistList.pagination!.currentPage! + 1);
              }
            }
            if (state is ProfileFailed) {
              _pagingController.error = state.message;
            }
            if (state is NoData) {
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
                itemExtent: 75,
                builderDelegate: PagedChildBuilderDelegate<Playlist>(
                    noItemsFoundIndicatorBuilder: (context) => NoResultWidget(
                        onTap: () => _pagingController.refresh()),
                    itemBuilder: (context, item, index) =>
                        ItemPlaylist(playlist: item, action: widget.action)));
          },
        ),
      ),
    );
  }
}
