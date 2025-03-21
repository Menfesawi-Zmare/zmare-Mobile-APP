import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/core/resources/resources.dart';

class ZmareImage extends StatelessWidget {
  const ZmareImage(
      {super.key,
      required this.imageUrl,
      this.placeholderImage = Images.defalutCover,
      this.boxFit = BoxFit.cover});
  final String imageUrl;
  final String placeholderImage;
  final BoxFit boxFit;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: boxFit,
      errorWidget: (context, _, __) => Image(
        fit: BoxFit.cover,
        image: AssetImage(placeholderImage),
      ),
      imageUrl: imageUrl,
      placeholder: (context, url) =>
          Image(fit: BoxFit.cover, image: AssetImage(placeholderImage)),
    );
  }
}
