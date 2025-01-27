import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/data/playlist/model/playlist.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/presentation/widgets/item_explorer_playlist.dart';


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
