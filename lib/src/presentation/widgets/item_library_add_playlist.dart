import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/presentation/widgets/texts/khmertracks_title.dart';

class ItemLibraryAddPlaylist extends StatelessWidget {
  const ItemLibraryAddPlaylist(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPressed});
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: onPressed,
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
                    child: Center(
                        child: ClipOval(
                      child: Material(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest, // Button color
                        child:
                            SizedBox(width: 56, height: 56, child: Icon(icon)),
                      ),
                    )),
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SizedBox(
                width: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [KhmertracksTitle(context.loc.createNewPlaylist)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
