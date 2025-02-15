import 'package:flutter/material.dart';
import 'package:zmare/src/data/playlist/model/playlist.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/presentation/widgets/item_explorer_playlist.dart';

class AllPlaylistsPage extends StatelessWidget {
  const AllPlaylistsPage(
      {super.key, required this.listPlaylists, required this.title});
  final List<Playlist> listPlaylists;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.materialYouAppBar(
        title,
      ),
      body: GridView.builder(
          itemCount: listPlaylists.length,
          padding: const EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.7),
          ),
          itemBuilder: (_, index) {
            return ItemExplorerPlaylist(playlist: listPlaylists[index]);
          }),
    );
  }
}
