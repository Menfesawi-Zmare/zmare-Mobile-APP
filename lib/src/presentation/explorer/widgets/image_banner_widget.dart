import 'package:flutter/material.dart';
import 'package:zmare/src/presentation/widgets/zmare_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageBannerWidget extends StatelessWidget {
  const ImageBannerWidget({super.key, required this.image, required this.link});
  final String image;
  final String link;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchUrl(
        Uri.parse(link),
        mode: LaunchMode.externalApplication,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
              width: double.infinity,
              height: 160,
              child: ZmareImage(
                imageUrl: image,
              )),
        ),
      ),
    );
  }
}
