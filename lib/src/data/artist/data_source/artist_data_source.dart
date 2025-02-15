import 'package:dartz/dartz.dart';
import 'package:zmare/src/core/api/api.dart';
import 'package:zmare/src/core/error/error.dart';
import 'package:zmare/src/data/album/model/album_list.dart';
import 'package:zmare/src/data/artist/model/artist_detail.dart';
import 'package:zmare/src/data/artist/model/artist_list.dart';
import 'package:zmare/src/data/artist/model/artist_song_list.dart';
import 'package:zmare/src/data/profile/model/profile_list.dart';

abstract class IArtistDataSource {
  Future<Either<Failure, AlbumList>> getArtistAlbums(
      int uid, int page, String filter);
  Future<Either<Failure, ArtistTrackList>> getArtistTracks(
      int uid, String filter);
  Future<Either<Failure, ArtistTrackList>> getArtistAllTracks(
      int uid, String filter);
  Future<Either<Failure, ArtistDetail>> getArtistDetail(int uid);
  Future<Either<Failure, ArtistList>> getAllArtist(int page, String filter);
  Future<Either<Failure, ProfileList>> getSubscribers(int profileId, int page);
}

class ArtistDataSource extends IArtistDataSource {
  ArtistDataSource(this._client);
  final DioClient _client;

  @override
  Future<Either<Failure, AlbumList>> getArtistAlbums(
      int uid, int page, String filter) async {
    final response = await _client.getRequest(
      '${ListAPI.artistAlbums}$uid',
      queryParameters: {'page': page},
      converter: (response) =>
          AlbumList.fromJson(response as Map<String, dynamic>),
    );
    return response;
  }

  @override
  Future<Either<Failure, ArtistTrackList>> getArtistTracks(
      int uid, String filter) async {
    final response = await _client.getRequest(
      '${ListAPI.artistTracks}$uid',
      converter: (response) =>
          ArtistTrackList.fromJson(response as Map<String, dynamic>),
    );
    return response;
  }

  @override
  Future<Either<Failure, ArtistTrackList>> getArtistAllTracks(
      int uid, String filter) async {
    final response = await _client.getRequest(
      '${ListAPI.artistTracks}$uid',
      queryParameters: {'type': filter},
      converter: (response) =>
          ArtistTrackList.fromJson(response as Map<String, dynamic>),
    );
    return response;
  }

  @override
  Future<Either<Failure, ArtistDetail>> getArtistDetail(int uid) async {
    final response = await _client.getRequest(
      '${ListAPI.artistDetail}$uid',
      converter: (response) =>
          ArtistDetail.fromJson(response as Map<String, dynamic>),
    );
    return response;
  }

  @override
  Future<Either<Failure, ArtistList>> getAllArtist(
      int page, String filter) async {
    final response = await _client.getRequest(
      ListAPI.allArtist,
      queryParameters: {'page': page},
      converter: (response) =>
          ArtistList.fromJson(response as Map<String, dynamic>),
    );
    return response;
  }

  @override
  Future<Either<Failure, ProfileList>> getSubscribers(
      int profileId, int page) async {
    final response = await _client.getRequest(
      '${ListAPI.artistSubscribers}$profileId',
      queryParameters: {"page": page},
      converter: (response) =>
          ProfileList.fromJson(response as Map<String, dynamic>),
    );
    return response;
  }
}
