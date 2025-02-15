import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/data/artist/model/artist.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ModalArtists extends StatelessWidget {
  const ModalArtists(
      {super.key,
      required this.artistName,
      required this.artistId,
      this.isPlayingPage = false});
  final String artistName;
  final String artistId;
  final bool isPlayingPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        ListTile(
          contentPadding: const EdgeInsets.only(left: 20, right: 10),
          title: Text(context.loc.chooseArtist,
              style: context.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          trailing: IconButton(
              onPressed: () => GoRouter.of(context).pop(),
              icon: const Icon(Icons.close)),
        ),
        ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: artistName.split(',').length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(artistName.split(',')[index],
                    style: context.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                leading: Icon(MdiIcons.accountMusicOutline),
                onTap: () {
                  GoRouter.of(context).pop();
                  if (isPlayingPage) {
                    context.pop();
                  }
                  context.pushNamed(artistPath,
                      extra: Artist(
                        id: int.parse(artistId.split(',')[index]),
                        name: artistName.split(',')[index],
                        image: '',
                        description: '',
                        albumTotal: 0,
                        listener: 0,
                        subscribers: 0,
                        trackTotal: 0,
                      ));
                },
              );
            }),
      ],
    );
  }
}
