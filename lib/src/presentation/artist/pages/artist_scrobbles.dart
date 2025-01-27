import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/data/artist/model/artist.dart';
import 'package:flutter_music_pro/src/data/profile/model/profile.dart';
import 'package:flutter_music_pro/src/presentation/artist/bloc/artist_bloc.dart';
import 'package:flutter_music_pro/src/presentation/widgets/item_profile.dart';

import 'package:flutter_music_pro/src/presentation/widgets/no_result_widget.dart';
import 'package:flutter_music_pro/src/service_locator.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ArtistScrobbles extends StatefulWidget {
  const ArtistScrobbles({super.key, required this.artist});
  final Artist artist;
  @override
  State<ArtistScrobbles> createState() => _ArtistScrobblesState();
}

class _ArtistScrobblesState extends State<ArtistScrobbles> {
  final ArtistBloc artistBloc = locator.get<ArtistBloc>();
  final PagingController<int, Profile> _pagingController =
      PagingController(firstPageKey: 1);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Profile>? profileList = [];
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      artistBloc.add(GetArtistSubscribers(widget.artist.id!, pageKey));
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
      appBar: context.materialYouAppBar(context.loc.subscribers),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        strokeWidth: 2.0,
        onRefresh: () async {
          _pagingController.refresh();
          artistBloc.add(GetArtistSubscribers(widget.artist.id!, 1));
          return Future<void>.delayed(const Duration(seconds: 1));
        },
        child: BlocProvider(
          create: (context) => artistBloc,
          child: BlocConsumer(
            bloc: artistBloc,
            listener: (context, state) {
              if (state is ProfileLoaded) {
                profileList = state.profileList.profiles!;
                final isLastPage = profileList!.length <
                    state.profileList.pagination!.perPage!;
                if (isLastPage) {
                  _pagingController.appendLastPage(profileList!);
                } else {
                  _pagingController.appendPage(profileList!,
                      state.profileList.pagination!.currentPage! + 1);
                }
              }
              if (state is ArtistFailed) {
                _pagingController.error = state.message;
              }
              if (state is NoData) {
              _pagingController.appendLastPage([]);
            }
            },
            builder: (context, state) {
              return PagedListView(
                  physics: const BouncingScrollPhysics(),
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Profile>(
                      noItemsFoundIndicatorBuilder: (context) => NoResultWidget(
                          onTap: () => _pagingController.refresh()),
                      itemBuilder: (context, item, index) =>
                          ItemProfile(profile: item)));
            },
          ),
        ),
      ),
      
    );
  }
}

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: context.materialYouAppBar(context.loc.subscribers),
  //     body: SubscribersWidget(profileId: widget.artist.id!),
  //     
  //   );
  // }
// }
