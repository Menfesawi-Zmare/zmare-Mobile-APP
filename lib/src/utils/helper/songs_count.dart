import 'package:hive/hive.dart';
import 'package:zmare/src/core/enum/box_types.dart';

void addSongsCount(String playlistName, int len, List images) {
  final Map playlistDetails = Hive.box(BoxType.playlists.name)
      .get('playlistDetails', defaultValue: {}) as Map;
  if (playlistDetails.containsKey(playlistName)) {
    playlistDetails[playlistName].addAll({'count': len, 'imagesList': images});
  } else {
    playlistDetails.addEntries([
      MapEntry(playlistName, {'count': len, 'imagesList': images})
    ]);
  }
  Hive.box(BoxType.playlists.name).put('playlistDetails', playlistDetails);
}
