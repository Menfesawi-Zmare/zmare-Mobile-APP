import 'package:audio_service/audio_service.dart';

// ignore: avoid_classes_with_only_static_members
class MediaItemConverter {
  static Map mediaItemToMap(MediaItem mediaItem) {
    return {
      'id': mediaItem.id,
      'album': mediaItem.album.toString(),
      'album_cover': mediaItem.extras?['album_cover'],
      'album_id': mediaItem.extras?['album_id'],
      'artist_id': mediaItem.extras?['artist_id'],
      'artist': mediaItem.artist.toString(),
      'duration': mediaItem.duration?.inSeconds.toString(),
      'genre': mediaItem.genre,
      'lyrics': mediaItem.extras!['lyrics'],
      'image': mediaItem.artUri.toString(),
      'title': mediaItem.title,
      'url': mediaItem.extras!['url'].toString(),
      'link': mediaItem.extras!['link'].toString(),
      'download': mediaItem.extras!['download'],
      'year': mediaItem.extras?['year'].toString(),
      'perma_url': mediaItem.extras?['perma_url'],
    };
  }

  static MediaItem mapToMediaItem(
    Map song, {
    bool addedByAutoplay = false,
    bool autoplay = true,
    String? playlistBox,
  }) {
    return MediaItem(
      id: song['id'].toString(),
      album: song['album'].toString(),
      artist: song['artist'].toString(),
      duration: Duration(
        seconds: int.parse(
          (song['duration'] == null ||
                  song['duration'] == 'null' ||
                  song['duration'] == '')
              ? '180'
              : song['duration'].toString(),
        ),
      ),
      title: song['title'].toString(),
      artUri: Uri.parse(song['image'].toString()),
      genre: song['genre'].toString(),
      extras: {
        'artist_id': song['artist_id'],
        'url': song['url'],
        'link': song['link'],
        'download': song['download'],
        'year': song['year'],
        'lyrics': song['lyrics'],
        'album_id': song['album_id'],
        'album_cover': song['album_cover'],
        'addedByAutoplay': addedByAutoplay,
        'autoplay': autoplay,
        'playlistBox': playlistBox,
      },
    );
  }

  static MediaItem downMapToMediaItem(Map song) {
    return MediaItem(
      id: song['id'].toString(),
      album: song['album'].toString(),
      artist: song['artist'].toString(),
      duration: Duration(
        seconds: int.parse(
          (song['duration'] == null ||
                  song['duration'] == 'null' ||
                  song['duration'] == '')
              ? '180'
              : song['duration'].toString(),
        ),
      ),
      title: song['title'].toString(),
      artUri: Uri.file(song['image'].toString()),
      genre: song['genre'].toString(),
      extras: {
        'lyrics': song['lyrics'].toString(),
        'url': song['path'].toString(),
        'link': song['link'].toString(),
        'year': song['year'],
        'language': song['genre'],
        'album_id': song['album_id'],
        'artist_id': song['artist_id']
      },
    );
  }
}
