import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_pro/src/data/artist/model/artist.dart';
import 'package:flutter_music_pro/src/data/follow/model/follow_response_model.dart';
import 'package:flutter_music_pro/src/presentation/widgets/item_artist.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_music_pro/src/presentation/profile/bloc/profile_bloc.dart';
import 'package:flutter_music_pro/src/presentation/widgets/item_profile.dart';
import 'package:flutter_music_pro/src/presentation/widgets/no_result_widget.dart';
import 'package:flutter_music_pro/src/service_locator.dart';

class SubscribersWidget extends StatefulWidget {
  const SubscribersWidget({super.key, required this.profileId});
  final int profileId;
  @override
  State<SubscribersWidget> createState() => _SubscribersWidgetState();
}

class _SubscribersWidgetState extends State<SubscribersWidget> {
  final ProfileBloc profileBloc = locator.get<ProfileBloc>();
  final PagingController<int, Follow> _pagingController =
      PagingController(firstPageKey: 1);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Follow>? profileList = [];
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      profileBloc.add(GetProfileSubscribers(widget.profileId, pageKey));
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
        profileBloc.add(GetProfileSubscribers(widget.profileId, 1));
        return Future<void>.delayed(const Duration(seconds: 1));
      },
      child: BlocProvider(
        create: (context) => profileBloc,
        child: BlocConsumer(
          bloc: profileBloc,
          listener: (context, state) {
            if (state is ProfileLoaded) {
              profileList = state.profileList.data!;
              final isLastPage =
                  profileList!.length < state.profileList.pagination!.perPage!;
              if (isLastPage) {
                _pagingController.appendLastPage(profileList!);
              } else {
                _pagingController.appendPage(profileList!,
                    state.profileList.pagination!.currentPage! + 1);
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
            return PagedListView(
                physics: const BouncingScrollPhysics(),
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Follow>(
                    noItemsFoundIndicatorBuilder: (context) => NoResultWidget(
                        onTap: () => _pagingController.refresh()),
                    itemBuilder: (context, item, index) {
                      if (item.artist is Artist) {
                        return ItemArtist(artists: item.artist!);
                      } else {
                        return ItemProfile(profile: item.user!);
                      }
                    }));
          },
        ),
      ),
    );
  }
}
