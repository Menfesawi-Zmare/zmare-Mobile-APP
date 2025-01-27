import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_pro/src/core/resources/resources.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/data/album/model/album.dart';
import 'package:flutter_music_pro/src/presentation/album/bloc/album_bloc.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_image.dart';

import 'package:flutter_music_pro/src/presentation/widgets/texts/khmertracks_title.dart';
import 'package:flutter_music_pro/src/service_locator.dart';

class AllAlbumPage extends StatefulWidget {
  const AllAlbumPage({super.key});

  @override
  State<AllAlbumPage> createState() => _AllAlbumPageState();
}

class _AllAlbumPageState extends State<AllAlbumPage> {
  final AlbumBloc albumBloc = locator.get<AlbumBloc>();
  List<Album>? listAlbum = [];
  final PagingController<int, Album> _pagingController =
      PagingController(firstPageKey: 1);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      albumBloc.add(GetAllAlbumEvent(pageKey));
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
        context.loc.albumsLabel,
      ),
      body: RefreshIndicator(
          key: _refreshIndicatorKey,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          strokeWidth: 2.0,
          onRefresh: () async {
            albumBloc.add(const GetAllAlbumEvent(1));
            _pagingController.refresh();
            return Future<void>.delayed(const Duration(seconds: 1));
          },
          child: BlocProvider(
            create: (context) => albumBloc,
            child: BlocListener(
              bloc: albumBloc,
              listener: (context, state) {
                if (state is AllAlbum) {
                  listAlbum = state.all.albumList;
                  final isLastPage = listAlbum!.length < state.all.pagination!.perPage!;
                  if (isLastPage) {
                    _pagingController.appendLastPage(listAlbum!);
                  } else {
                    _pagingController.appendPage(
                        listAlbum!, state.all.pagination!.currentPage! + 1);
                  }
                }
                if (state is AlbumLoadFailed) {
                  _pagingController.error = state.message;
                }
              },
              child: PagedGridView<int, Album>(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.87,
                ),
                padding: const EdgeInsets.all(16),
                pagingController: _pagingController,
                showNewPageProgressIndicatorAsGridChild: false,
                builderDelegate: PagedChildBuilderDelegate<Album>(
                  itemBuilder: (context, item, index) => Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(16.0),
                        onTap: () {
                          context.pushNamed(albumSongsPath, extra: item);
                        },
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: KhmertracksImage(
                                imageUrl: item.image!,
                                placeholderImage: Images.defalutAlbumCover,
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: KhmertracksTitle(
                          item.name!,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
      
    );
  }
}
