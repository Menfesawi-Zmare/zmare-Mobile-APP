import 'package:dartz/dartz.dart';
import 'package:zmare/src/core/error/error.dart';
import 'package:zmare/src/data/track/model/track_list_model.dart';

abstract class IPlaylistRepository {
  Future<Either<Failure, TrackList>> getPlaylistTracks(int playlistId);
}
