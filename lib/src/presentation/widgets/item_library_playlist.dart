import 'package:flutter/material.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/playlist_privacy_type.dart';
import 'package:zmare/src/data/playlist/model/playlist.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_image.dart';

class ItemLibraryPlaylist extends StatelessWidget {
  const ItemLibraryPlaylist(
      {super.key,
      required this.icon,
      required this.onPressed,
      required this.playlist});
  final IconData icon;
  final VoidCallback onPressed;
  final Playlist? playlist;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                // ignore: sized_box_for_whitespace
                child: Container(
                  width: 140,
                  height: 80,
                  child: Stack(children: [
                    SizedBox(
                      width: 140,
                      child: KhmertracksImage(
                        imageUrl: playlist!.image!,
                        placeholderImage: Images.defalutCover,
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 140,
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3)),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2, bottom: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  icon,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                Text(playlist!.trackTotal!.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: context.bodySmall),
                              ],
                            ),
                          ),
                        )),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  width: 140,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(playlist!.name!,
                          overflow: TextOverflow.ellipsis,
                          style: context.bodyLarge),
                      RichText(
                        text: TextSpan(
                            text: PlaylistPrivacyType.values
                                .firstWhere(
                                    (e) => e.toIndex == playlist!.public!)
                                .name(context),
                            style: context.bodySmall),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
