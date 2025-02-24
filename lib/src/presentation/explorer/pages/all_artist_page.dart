// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:zmare/src/presentation/widgets/no_result_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/data/artist/model/artist.dart';
import 'package:zmare/src/presentation/artist/bloc/artist_bloc.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_image.dart';

import 'package:zmare/src/service_locator.dart';

class AllArtistPage extends StatefulWidget {
  const AllArtistPage({super.key, required this.title});
  final String title;
  @override
  State<AllArtistPage> createState() => _AllArtistPageState();
}

class _AllArtistPageState extends State<AllArtistPage> {
  final ArtistBloc artistBloc = locator.get<ArtistBloc>();
  List<Artist> listArtists = [];
  final PagingController<int, Artist> _pagingController =
      PagingController(firstPageKey: 1);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      artistBloc.add(GetAllArtistEvent(pageKey, ''));
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
        extendBody: true,
        appBar: context.materialYouAppBar(
          widget.title,
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          strokeWidth: 2.0,
          onRefresh: () async {
            // artistBloc.add(const GetAllArtistEvent(1, ''));
            _pagingController.refresh();
            return Future<void>.delayed(const Duration(seconds: 1));
          },
          child: BlocProvider(
              create: (context) => artistBloc,
              child: BlocConsumer(
                bloc: artistBloc,
                listener: (context, state) {
                  if (state is ArtistLoaded) {
                    listArtists = state.artistList.artistList!;
                    final isLastPage =
                        state.artistList.pagination!.currentPage! >=
                            state.artistList.pagination!.totalPages!;

                    if (isLastPage) {
                      _pagingController.appendLastPage(listArtists);
                    } else {
                      _pagingController.appendPage(listArtists,
                          state.artistList.pagination!.currentPage! + 1);
                    }
                  }
                  if (state is ArtistFailed) {
                    _pagingController.error = state.message;
                  }
                },
                builder: (context, state) {
                  return PagedGridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 3.2,
                      ),
                      padding: const EdgeInsets.all(16),
                      pagingController: _pagingController,
                      showNewPageProgressIndicatorAsGridChild: false,
                      builderDelegate: PagedChildBuilderDelegate<Artist>(
                          noItemsFoundIndicatorBuilder: (context) =>
                              NoResultWidget(
                                  onTap: () => _pagingController.refresh()),
                          itemBuilder: (context, item, index) => InkWell(
                                onTap: () =>
                                    context.pushNamed(artistPath, extra: item),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.2)),
                                  child: Row(
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 1 / 1,
                                        child: ClipOval(
                                            child: KhmertracksImage(
                                          imageUrl: item.image!,
                                          placeholderImage:
                                              Images.defalultArtistCover,
                                        )),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            Text(
                                              "${item.subscribers} followers",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )));
                },
              )),
        ));
  }
}
