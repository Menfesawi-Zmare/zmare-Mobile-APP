import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/data/production/model/production.dart';
import 'package:zmare/src/presentation/explorer/bloc/bloc/explorer_bloc.dart';
import 'package:zmare/src/presentation/widgets/item_production.dart';

import 'package:zmare/src/presentation/widgets/no_result_widget.dart';
import 'package:zmare/src/service_locator.dart';

class AllProductionPage extends StatefulWidget {
  const AllProductionPage({super.key, required this.title});
  final String title;
  @override
  State<AllProductionPage> createState() => _AllProductionPageState();
}

class _AllProductionPageState extends State<AllProductionPage> {
  final ExplorerBloc explorerBloc = locator.get<ExplorerBloc>();
  final PagingController<int, Production> _pagingController =
      PagingController(firstPageKey: 1);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Production> listProduction = [];
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      explorerBloc.add(GetAllProductionEvent(pageKey));
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
        explorerBloc.add(const GetAllProductionEvent(1));
        _pagingController.refresh();
        return Future<void>.delayed(const Duration(seconds: 1));
      },
      child: Scaffold(
        appBar: context.materialYouAppBar(
          widget.title,
        ),
        body: BlocProvider(
            create: (context) => explorerBloc,
            child: BlocConsumer(
              bloc: explorerBloc,
              listener: (context, state) {
                if (state is ProductionLoaded) {
                  listProduction = state.productionList.production!;
                  final isLastPage = listProduction.length <
                      state.productionList.pagination!.perPage!;
                  if (isLastPage) {
                    _pagingController.appendLastPage(listProduction);
                  } else {
                    _pagingController.appendPage(listProduction,
                        state.productionList.pagination!.currentPage! + 1);
                  }
                }
                if (state is ExplorerFailedState) {
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
                      childAspectRatio: 0.8,
                    ),
                    padding: const EdgeInsets.all(16),
                    pagingController: _pagingController,
                    showNewPageProgressIndicatorAsGridChild: false,
                    builderDelegate: PagedChildBuilderDelegate<Production>(
                        noItemsFoundIndicatorBuilder: (context) =>
                            NoResultWidget(
                                onTap: () => _pagingController.refresh()),
                        itemBuilder: (context, item, index) =>
                            ItemProduction(production: item)));
              },
            )),
      ),
    );
  }
}
