import 'package:flutter/material.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/data/artist/model/artist.dart';
import 'package:zmare/src/presentation/widgets/zmare_image.dart';

import 'package:go_router/go_router.dart';

class CustomArtistPage extends StatelessWidget {
  const CustomArtistPage(
      {super.key, required this.listArtists, required this.title});
  final List<Artist>? listArtists;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.materialYouAppBar(
        title,
      ),
      body: GridView.builder(
          itemCount: listArtists!.length,
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
                  context.pushNamed(artistPath, extra: listArtists![index]),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1 / 1,
                    child: ClipOval(
                        child: ZmareImage(
                      imageUrl: listArtists![index].image!,
                      placeholderImage: Images.defalultArtistCover,
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      listArtists![index].name!,
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
