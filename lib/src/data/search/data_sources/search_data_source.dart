import 'package:dartz/dartz.dart';
import 'package:zmare/src/core/api/api.dart';
import 'package:zmare/src/core/error/error.dart';
import 'package:zmare/src/data/album/model/album_list.dart';
import 'package:zmare/src/data/artist/model/artist_list.dart';
import 'package:zmare/src/data/playlist/model/playlist_list.dart';
import 'package:zmare/src/data/profile/model/profile_list.dart';
import 'package:zmare/src/data/suggestion/model.suggestion_list.dart';
import 'package:zmare/src/data/track/model/track_list_model.dart';

abstract class ISearchDataSources {
  Future<Either<Failure, TrackList>> fetchSongSearchResults(
      String query, int page);
  Future<Either<Failure, AlbumList>> fetchAlbumSearchResults(
      String query, int page);
  Future<Either<Failure, ArtistList>> fetchArtistSearchResults(
      String query, int page);
  Future<Either<Failure, PlaylistList>> fetchPlaylistSearchResults(
      String query, int page);
  Future<Either<Failure, ProfileList>> fetchProfileSearchResults(
      String query, int page);
  Future<Either<Failure, SuggestionList>> fetchSearchSuggestionResults(
      String query);
}

class SearchDataSources extends ISearchDataSources {
  SearchDataSources(this._client);
  final DioClient _client;

  @override
  Future<Either<Failure, TrackList>> fetchSongSearchResults(
      String query, int page) async {
    final response = await _client.getRequest(
      '${ListAPI.searchTracks}$query',
      queryParameters: {'page': page},
      converter: (response) =>
          TrackList.fromJson(response as Map<String, dynamic>),
    );

    return response;
  }

  @override
  Future<Either<Failure, AlbumList>> fetchAlbumSearchResults(
      String query, int page) async {
    final response = await _client.getRequest(
      '${ListAPI.searchAlbums}$query',
      queryParameters: {'page': page},
      converter: (response) =>
          AlbumList.fromJson(response as Map<String, dynamic>),
    );

    return response;
  }

  @override
  Future<Either<Failure, ArtistList>> fetchArtistSearchResults(
      String query, int page) async {
    final response = await _client.getRequest(
      '${ListAPI.searchArtists}$query',
      queryParameters: {'page': page},
      converter: (response) =>
          ArtistList.fromJson(response as Map<String, dynamic>),
    );

    return response;
  }

  @override
  Future<Either<Failure, PlaylistList>> fetchPlaylistSearchResults(
      String query, int page) async {
    final response = await _client.getRequest(
      '${ListAPI.searchPlaylists}$query',
      queryParameters: {'page': page},
      converter: (response) =>
          PlaylistList.fromJson(response as Map<String, dynamic>),
    );

    return response;
  }

  @override
  Future<Either<Failure, ProfileList>> fetchProfileSearchResults(
      String query, int page) async {
    final response = await _client.getRequest(
      '${ListAPI.searchUsers}$query',
      queryParameters: {'page': page},
      converter: (response) =>
          ProfileList.fromJson(response as Map<String, dynamic>),
    );

    return response;
  }

  @override
  Future<Either<Failure, SuggestionList>> fetchSearchSuggestionResults(
      String query) async {
    final response = await _client.getRequest(
      '${ListAPI.searchSuggestions}$query',
      converter: (response) =>
          SuggestionList.fromJson(response as Map<String, dynamic>),
    );

    return response;
  }
}
