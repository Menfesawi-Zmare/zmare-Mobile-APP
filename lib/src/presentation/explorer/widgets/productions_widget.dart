import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/core/enum/explorer_item_type.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zmare/src/app/routes.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/core/enum/grid_type.dart';
import 'package:zmare/src/utils/helper/ad_helper.dart';
import 'package:zmare/src/data/production/model/production.dart';
import 'package:zmare/src/presentation/widgets/dynamic_grid.dart';
import 'package:zmare/src/service_locator.dart';

class ProductionsWidget extends StatefulWidget {
  const ProductionsWidget(
      {super.key,
      required this.productions,
      required this.title,
      required this.type});
  final List<Production>? productions;
  final String title;
  final String type;
  @override
  State<ProductionsWidget> createState() => _ProductionsWidgetState();
}

class _ProductionsWidgetState extends State<ProductionsWidget> {
  int? limit = settings.get(explorerPerPage, defaultValue: 10);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(
            widget.title,
            style: context.titleLarge?.copyWith(
              color: context.onBackground,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Visibility(
            visible: widget.productions!.length >= limit! ? true : false,
            child: IconButton(
                onPressed: () {
                  AdHelper.showInterstitialAd();
                  widget.type == ExplorerItemType.custom.name
                      ? context.pushNamed(customProductionPath,
                          extra: widget.productions,
                          pathParameters: {'title': widget.title})
                      : context.pushNamed(allProductionPath,
                          extra: widget.title);
                },
                icon: SizedBox(
                  width: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("See All",
                          textAlign: TextAlign.start,
                          style: context.titleMedium?.copyWith(
                              color: context.colorScheme.onSurface,
                              fontSize: 14)),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                      )
                    ],
                  ),
                )),
          )),
      ValueListenableBuilder<Box<dynamic>>(
          valueListenable: locator
              .get<Box<dynamic>>(instanceName: BoxType.settings.name)
              .listenable(keys: [productionGridKey]),
          builder: (context, value, child) {
            int gridStyleId = 2;
            return SizedBox(
              height: gridStyleId != 3 ? 200 : 130,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.productions!.length > limit!
                      ? widget.productions!.sublist(0, limit).length
                      : widget.productions!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return DynamicGrid(
                      title: widget.productions![index].name!,
                      image: widget.productions![index].image!,
                      gridStyleId: gridStyleId,
                      onTap: () => context.pushNamed(viewProductionAlbumsPath,
                          extra: widget.productions![index]),
                    );
                  }),
            );
          })
    ]);
  }
}
