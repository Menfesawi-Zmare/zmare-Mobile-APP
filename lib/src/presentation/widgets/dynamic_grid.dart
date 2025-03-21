// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/utils/helper/color_ultil.dart';

import 'package:zmare/src/presentation/widgets/zmare_image.dart';

import '../../utils/helper/zmare_palette.dart';

class DynamicGrid extends StatelessWidget {
  const DynamicGrid(
      {super.key,
      required this.title,
      required this.image,
      required this.gridStyleId,
      required this.onTap,
      this.subscribers,
      this.tracksInAlbum});
  final String title;
  final String image;
  final int gridStyleId;
  final int? subscribers;
  final int? tracksInAlbum;
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 5,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(40),
      ),
      height: 60,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          width: 50,
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: ClipOval(
                child: ZmareImage(
              imageUrl: image,
              placeholderImage: Images.defalultArtistCover,
            )),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Text(title,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: context.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.colorScheme.onSurface,
                      fontSize: 12)),
            ),
            if (subscribers != null)
              SizedBox(
                width: 100,
                child: Text("$subscribers ${context.loc.followersLables}",
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: context.titleMedium?.copyWith(
                        color: context.colorScheme.onSurface, fontSize: 10)),
              ),
          ],
        )
      ]),
    );
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
          final cardColor =
              snapshot.data?[6] ?? Theme.of(context).colorScheme.surface;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 156,
                color: snapshot.data?[6]!.withOpacity(
                    Theme.of(context).brightness == Brightness.dark
                        ? 0.3
                        : 0.4),
                child: Stack(children: [
                  AspectRatio(
                    aspectRatio: 1 / 1.28,
                    child: ZmareImage(
                      imageUrl: image,
                      placeholderImage: Images.defalultArtistCover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                          cardColor.withOpacity(0.9),
                          Colors.transparent
                        ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter)),
                  ),
                  Positioned(
                    bottom: 20,
                    child: Container(
                      width: 156,
                      color: context.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: context.bodyLarge?.copyWith(
                                  color: textColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                          if (tracksInAlbum != null)
                            Text("$tracksInAlbum ${context.loc.mezmursLables}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: context.bodyLarge?.copyWith(
                                    color: textColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300)),
                        ],
                      ),
                    ),
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
      child: Container(
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: SizedBox.square(
                dimension: 156,
                child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: ZmareImage(
                      imageUrl: image,
                      placeholderImage: Images.defalultArtistCover,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.titleMedium),
                  Icon(
                    Icons.arrow_circle_right_outlined,
                    color: Theme.of(context).colorScheme.surface,
                  )
                ],
              ),
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
                            child: ZmareImage(
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
                child: ZmareImage(
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
