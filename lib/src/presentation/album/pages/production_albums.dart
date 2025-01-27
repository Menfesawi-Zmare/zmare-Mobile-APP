import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/data/album/model/album.dart';
import 'package:flutter_music_pro/src/data/production/model/production.dart';
import 'package:flutter_music_pro/src/presentation/album/bloc/album_bloc.dart';
import 'package:flutter_music_pro/src/presentation/widgets/item_production_album.dart';

import 'package:flutter_music_pro/src/presentation/widgets/no_result_widget.dart';
import 'package:flutter_music_pro/src/service_locator.dart';

class ProductionAlbumsPage extends StatefulWidget {
  const ProductionAlbumsPage({super.key, required this.productions});
  final Production productions;

  @override
  State<ProductionAlbumsPage> createState() => _ProductionAlbumsPageState();
}

class _ProductionAlbumsPageState extends State<ProductionAlbumsPage> {
  final AlbumBloc albumBloc = locator.get<AlbumBloc>();
  final PagingController<int, Album> _pagingController =
      PagingController(firstPageKey: 1);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Album> albumlist = [];
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      albumBloc.add(GetProductionAlbumsEvent(widget.productions.id!, pageKey));
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
        widget.productions.name!,
      ),
      
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        strokeWidth: 2.0,
        onRefresh: () async {
          _pagingController.refresh();
          albumBloc.add(GetProductionAlbumsEvent(widget.productions.id!, 1));
          return Future<void>.delayed(const Duration(seconds: 1));
        },
        child: BlocProvider(
          create: (context) => albumBloc,
          child: BlocListener(
            bloc: albumBloc,
            listener: (context, state) {
              if (state is ProductionAlbumsLoaded) {
                albumlist = state.productionAlbums.albumList!;
                final isLastPage =
                    albumlist.length < state.productionAlbums.pagination!.perPage!;
                if (isLastPage) {
                  _pagingController.appendLastPage(albumlist);
                } else {
                  _pagingController.appendPage(
                      albumlist, state.productionAlbums.pagination!.currentPage! + 1);
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
                      builderDelegate: PagedChildBuilderDelegate<Album>(
                        noItemsFoundIndicatorBuilder: (context) => NoResultWidget(onTap: () => _pagingController.refresh()),
                          itemBuilder: (context, item, index) =>
                              ItemProductionAlbum(item: item)),
                    )),
          ),
        ),
      ),
    );
  }
}
