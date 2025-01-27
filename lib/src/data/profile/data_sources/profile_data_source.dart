import 'package:dartz/dartz.dart';
import 'package:flutter_music_pro/src/core/api/api.dart';
import 'package:flutter_music_pro/src/core/error/error.dart';
import 'package:flutter_music_pro/src/data/follow/model/follow_response_model.dart';
import 'package:flutter_music_pro/src/data/playlist/model/playlist_list.dart';
import 'package:flutter_music_pro/src/data/track/model/track_list_model.dart';

abstract class IProfileDataSource {
  Future<Either<Failure, FollowResponseModel>> getSubscriptions(
      int profileId,int page);
  Future<Either<Failure, FollowResponseModel>> getSubscribers(
      int profileId,int page);
  Future<Either<Failure, TrackList>> getLikes(int profileId, int page);
  Future<Either<Failure, PlaylistList>> getPlaylists(
      int profileId, int page);
}

class ProfileDataSource extends IProfileDataSource {
  ProfileDataSource(this._client);
  final DioClient _client;

  @override
  Future<Either<Failure, FollowResponseModel>> getSubscribers(
      int profileId,int page) async {
    final response = await _client.getRequest(
      '${ListAPI.subscribers}$profileId',
      queryParameters: {"page": page},
      converter: (response) =>
          FollowResponseModel.fromJson(response as Map<String, dynamic>),
    );
    return response;
  }

  @override
  Future<Either<Failure, FollowResponseModel>> getSubscriptions(
      int profileId,int page) async {
    final response = await _client.getRequest(
     '${ListAPI.subscriptions}$profileId',
      queryParameters: {"page": page},
      converter: (response) =>
          FollowResponseModel.fromJson(response as Map<String, dynamic>),
    );
    return response;
  }

  @override
  Future<Either<Failure, TrackList>> getLikes(int profileId, int page) async {
    final response = await _client.getRequest(
      '${ListAPI.loadLikes}$profileId',
      queryParameters: {"page": page},
      converter: (response) =>
          TrackList.fromJson(response as Map<String, dynamic>),
    );
    return response;
  }

  @override
  Future<Either<Failure, PlaylistList>> getPlaylists(
      int profileId, int page) async {
    final response = await _client.getRequest(
      '${ListAPI.userPlaylists}$profileId',
      queryParameters: {'page': page},
      converter: (response) =>
          PlaylistList.fromJson(response as Map<String, dynamic>),
    );
    return response;
  }
}
