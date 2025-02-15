import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/utils/helper/color_ultil.dart';
import 'package:zmare/src/utils/helper/khmertracks_palette.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_image.dart';

class DynamicGrid extends StatelessWidget {
  const DynamicGrid(
      {super.key,
      required this.title,
      required this.image,
      required this.gridStyleId,
      required this.onTap});
  final String title;
  final String image;
  final int gridStyleId;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: dynamicWidget(context, gridStyleId)),
      ),
    );
  }

  Widget dynamicWidget(BuildContext context, int type) {
    switch (type) {
      case 0:
        return circular(context);
      case 1:
        return colorCard(context);
      case 2:
        return card(context);
      case 3:
        return tinyCard(context);
      case 4:
        return squareCard(context);
      default:
        return const SizedBox();
    }
  }

  Widget circular(BuildContext context) {
    return Column(children: [
      SizedBox(
        width: 160,
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: ClipOval(
              child: KhmertracksImage(
            imageUrl: image,
            placeholderImage: Images.defalultArtistCover,
          )),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 12),
        child: SizedBox(
          width: 160,
          child: Text(title,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: context.titleMedium
                  ?.copyWith(color: context.colorScheme.onSurface)),
        ),
      )
    ]);
  }

  Widget colorCard(BuildContext context) {
    return FutureBuilder<List<Color?>?>(
        future: paletteGenerator(
            imageProvider:
                CachedNetworkImageProvider(image, maxWidth: 80, maxHeight: 80)),
        builder: (context, snapshot) {
          final textColor = Theme.of(context).brightness == Brightness.dark
              ? lighten(
                  snapshot.data?[6]! ?? Theme.of(context).colorScheme.surface,
                  0.4)
              : darken(
                  snapshot.data?[6]! ?? Theme.of(context).colorScheme.surface,
                  0.4);
          return AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 156,
                color: snapshot.data?[6]!.withOpacity(
                    Theme.of(context).brightness == Brightness.dark
                        ? 0.3
                        : 0.4),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 156,
                        height: 160,
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Card(
                              elevation: 0,
                              margin: const EdgeInsets.all(0),
                              child: KhmertracksImage(
                                imageUrl: image,
                                placeholderImage: Images.defalultArtistCover,
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: Text(title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style:
                                context.bodyLarge?.copyWith(color: textColor)),
                      )
                    ]),
              ),
            ),
          );
        });
  }

  Widget card(BuildContext context) {
    return SizedBox(
      width: 156,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox.square(
              dimension: 156,
              child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: KhmertracksImage(
                    imageUrl: image,
                    placeholderImage: Images.defalultArtistCover,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Text(title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.titleMedium),
            )
          ],
        ),
      ),
    );
  }

  Widget tinyCard(BuildContext context) {
    return FutureBuilder<List<Color?>?>(
        future: paletteGenerator(
            imageProvider:
                CachedNetworkImageProvider(image, maxWidth: 80, maxHeight: 80)),
        builder: (context, snapshot) {
          final textColor = Theme.of(context).brightness == Brightness.dark
              ? lighten(
                  snapshot.data?[6] ?? Theme.of(context).colorScheme.surface,
                  0.4)
              : darken(
                  snapshot.data?[6] ?? Theme.of(context).colorScheme.surface,
                  0.4);
          return SizedBox(
            width: 128,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                color: snapshot.data?[6]!.withOpacity(
                    Theme.of(context).brightness == Brightness.dark
                        ? 0.3
                        : 0.4),
                margin: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16, left: 16),
                      child: SizedBox.square(
                        dimension: 42,
                        child: ClipOval(
                            child: KhmertracksImage(
                          imageUrl: image,
                          placeholderImage: Images.defalultArtistCover,
                        )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                              color: textColor)),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget squareCard(BuildContext context) {
    return SizedBox(
      width: 156,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox.square(
            dimension: 156,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: KhmertracksImage(
                  imageUrl: image,
                  placeholderImage: Images.defalutAlbumCover,
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: context.bodyLarge
                    ?.copyWith(color: context.colorScheme.onSurface)),
          ),
        ],
      ),
    );
  }
}
