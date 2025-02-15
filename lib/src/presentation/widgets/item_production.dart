import 'package:flutter/material.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:go_router/go_router.dart';
import 'package:zmare/src/data/production/model/production.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_image.dart';
import 'package:zmare/src/presentation/widgets/texts/khmertracks_title.dart';

class ItemProduction extends StatelessWidget {
  const ItemProduction({super.key, required this.production});
  final Production production;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          context.pushNamed(viewProductionAlbumsPath, extra: production),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1 / 1,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: KhmertracksImage(
                  imageUrl: production.image!,
                  placeholderImage: Images.defalutProductionCover,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: KhmertracksTitle(
              production.name!,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
