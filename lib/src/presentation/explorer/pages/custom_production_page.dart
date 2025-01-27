import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/data/production/model/production.dart';
import 'package:flutter_music_pro/src/presentation/widgets/item_production.dart';


class CustomProductionPage extends StatelessWidget {
  const CustomProductionPage(
      {super.key, required this.listProductions, required this.title});
  final List<Production>? listProductions;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.materialYouAppBar(
        title,
      ),
      body: GridView.builder(
          itemCount: listProductions!.length,
          padding: const EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.7),
          ),
          itemBuilder: (_, index) {
            return ItemProduction(production: listProductions![index]);
          }),
      
    );
  }
}
