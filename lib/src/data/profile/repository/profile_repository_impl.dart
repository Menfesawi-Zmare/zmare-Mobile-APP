import 'package:dartz/dartz.dart';
import 'package:zmare/src/core/error/error.dart';
import 'package:zmare/src/data/follow/model/follow_response_model.dart';
import 'package:zmare/src/data/playlist/model/playlist_list.dart';
import 'package:zmare/src/data/profile/data_sources/profile_data_source.dart';
import 'package:zmare/src/data/track/model/track_list_model.dart';
import 'package:zmare/src/domain/profile/repository/profile_repository.dart';

class ProfileRepositoryImpl extends IProfileRepository {
  ProfileRepositoryImpl({required this.iProfileDataSource});
  final IProfileDataSource iProfileDataSource;

  @override
  Future<Either<Failure, FollowResponseModel>> getSubscribers(
      int profileId, int page) async {
    final response = await iProfileDataSource.getSubscribers(profileId, page);
    return response.fold(
      (failure) => Left(failure),
      (subscribersResponse) {
        return Right(subscribersResponse);
      },
    );
  }

  @override
  Future<Either<Failure, FollowResponseModel>> getSubscriptions(
      int profileId, int page) async {
    final response = await iProfileDataSource.getSubscriptions(profileId, page);
    return response.fold(
      (failure) => Left(failure),
      (subscriptionsResponse) {
        return Right(subscriptionsResponse);
      },
    );
  }

  @override
  Future<Either<Failure, TrackList>> getLikes(int profileId, int page) async {
    final response = await iProfileDataSource.getLikes(profileId, page);
    return response.fold(
      (failure) => Left(failure),
      (likesResponse) {
        if (likesResponse.songList?.isEmpty ?? true) {
          return Left(NoDataFailure());
        }
        return Right(likesResponse);
      },
    );
  }

  @override
  Future<Either<Failure, PlaylistList>> getPlaylists(
      int profileId, int page) async {
    final response = await iProfileDataSource.getPlaylists(profileId, page);
    return response.fold(
      (failure) => Left(failure),
      (playlistsResponse) {
        if (playlistsResponse.playlist?.isEmpty ?? true) {
          return Left(NoDataFailure());
        }
        return Right(playlistsResponse);
      },
    );
  }
}
