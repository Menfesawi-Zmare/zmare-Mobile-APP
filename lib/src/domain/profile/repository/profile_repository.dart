import 'package:dartz/dartz.dart';
import 'package:zmare/src/core/error/error.dart';
import 'package:zmare/src/data/follow/model/follow_response_model.dart';
import 'package:zmare/src/data/playlist/model/playlist_list.dart';
import 'package:zmare/src/data/track/model/track_list_model.dart';

abstract class IProfileRepository {
  Future<Either<Failure, FollowResponseModel>> getSubscriptions(
      int profileId, int page);
  Future<Either<Failure, FollowResponseModel>> getSubscribers(
      int profileId, int page);
  Future<Either<Failure, TrackList>> getLikes(int profileId, int page);
  Future<Either<Failure, PlaylistList>> getPlaylists(int profileId, int page);
}
