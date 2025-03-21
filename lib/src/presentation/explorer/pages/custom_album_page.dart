import 'package:flutter/material.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/data/album/model/album.dart';
import 'package:zmare/src/presentation/widgets/zmare_image.dart';

import 'package:go_router/go_router.dart';

class CustomAlbumPage extends StatelessWidget {
  const CustomAlbumPage(
      {super.key, required this.listAlbums, required this.title});
  final List<Album>? listAlbums;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.materialYouAppBar(
        title,
      ),
      body: GridView.builder(
          itemCount: listAlbums!.length,
          padding: const EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.7),
          ),
          itemBuilder: (_, index) {
            return InkWell(
              onTap: () =>
                  context.pushNamed(albumSongsPath, extra: listAlbums![index]),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1 / 1,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ZmareImage(
                          imageUrl: listAlbums![index].image!,
                          placeholderImage: Images.defalultArtistCover,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      listAlbums![index].name!,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
