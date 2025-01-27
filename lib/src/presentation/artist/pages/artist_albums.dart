import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/core/resources/resources.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/data/album/model/album.dart';
import 'package:flutter_music_pro/src/data/artist/model/artist.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_image.dart';

class ArtistAlbums extends StatelessWidget {
  const ArtistAlbums(
      {super.key, required this.albumList, required this.artist});
  final List<Album> albumList;
  final Artist artist;
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
              contentPadding: const EdgeInsets.only(left: 16.0, right: 0.0),
              title: Text(context.loc.albumsLabel,
                  style: context.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              trailing: Visibility(
                visible: albumList.length >= 10 ? true : false,
                child: IconButton(
                  onPressed: () =>
                      context.pushNamed(allArtistAlbumsPath, extra: artist),
                  icon: Icon(
                    FluentIcons.arrow_right_28_regular,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              )),
          SizedBox(
            height: 200,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: albumList.isNotEmpty
                    ? (albumList.length > 10
                        ? albumList.sublist(0, 10).length
                        : albumList.length)
                    : albumList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(16.0),
                    onTap: () {
                      context.pushNamed(albumSongsPath,
                          extra: albumList[index]);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 156,
                          width: 156,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: KhmertracksImage(
                                imageUrl: albumList[index].image!,
                                placeholderImage: Images.defalutAlbumCover,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: SizedBox(
                            width: 170,
                            child: Text(albumList[index].name!,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: context.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ]);
  }
}
