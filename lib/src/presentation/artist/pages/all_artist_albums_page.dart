import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/data/album/model/album.dart';
import 'package:flutter_music_pro/src/data/artist/model/artist.dart';
import 'package:flutter_music_pro/src/presentation/album/bloc/album_bloc.dart';
import 'package:flutter_music_pro/src/presentation/widgets/item_artist_album.dart';
import 'package:flutter_music_pro/src/service_locator.dart';

class AllArtistAlbumsPage extends StatefulWidget {
  const AllArtistAlbumsPage({super.key, required this.artist});
  final Artist artist;
  @override
  State<AllArtistAlbumsPage> createState() => _AllArtistAlbumsPageState();
}

class _AllArtistAlbumsPageState extends State<AllArtistAlbumsPage> {
  final AlbumBloc albumBloc = locator.get<AlbumBloc>();
  List<Album>? listAlbum = [];
  final PagingController<int, Album> _pagingController =
      PagingController(firstPageKey: 1);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      albumBloc.add(GetArtistAlbumsEvent(widget.artist.id!, pageKey));
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
      appBar: context.materialYouAppBar(
        context.loc.allAlbums,
      ),
      body: RefreshIndicator(
          key: _refreshIndicatorKey,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          strokeWidth: 2.0,
          onRefresh: () async {
            albumBloc.add(GetArtistAlbumsEvent(widget.artist.id!, 1));
            _pagingController.refresh();
            return Future<void>.delayed(const Duration(seconds: 1));
          },
          child: BlocProvider(
            create: (context) => albumBloc,
            child: BlocListener(
              bloc: albumBloc,
              listener: (context, state) {
                if (state is ArtistAlbum) {
                  listAlbum = state.albumList.albumList;
                  final isLastPage =
                      listAlbum!.length < state.albumList.pagination!.perPage!;
                  if (isLastPage) {
                    _pagingController.appendLastPage(listAlbum!);
                  } else {
                    _pagingController.appendPage(listAlbum!,
                        state.albumList.pagination!.currentPage! + 1);
                  }
                }
                if (state is AlbumLoadFailed) {
                  _pagingController.error = state.message;
                }
              },
              child: BlocBuilder(
                  bloc: albumBloc,
                  builder: (context, state) => PagedGridView<int, Album>(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.87,
                        ),
                        padding: const EdgeInsets.all(16),
                        pagingController: _pagingController,
                        showNewPageProgressIndicatorAsGridChild: false,
                        builderDelegate: PagedChildBuilderDelegate<Album>(
                            itemBuilder: (context, item, index) =>
                                ItemArtistAlbum(item: item)),
                      )),
            ),
          )),
    );
  }
}
