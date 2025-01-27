import 'package:dartz/dartz.dart';
import 'package:flutter_music_pro/src/core/error/error.dart';
import 'package:flutter_music_pro/src/data/track/model/track_list_model.dart';

abstract class IPlaylistRepository {
  Future<Either<Failure,TrackList>> getPlaylistTracks(int playlistId);
}
