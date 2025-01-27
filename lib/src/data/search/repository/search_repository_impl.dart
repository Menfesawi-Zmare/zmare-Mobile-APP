import 'package:dartz/dartz.dart';
import 'package:flutter_music_pro/src/core/error/error.dart';
import 'package:flutter_music_pro/src/data/album/model/album_list.dart';
import 'package:flutter_music_pro/src/data/artist/model/artist_list.dart';
import 'package:flutter_music_pro/src/data/playlist/model/playlist_list.dart';
import 'package:flutter_music_pro/src/data/profile/model/profile_list.dart';
import 'package:flutter_music_pro/src/data/search/data_sources/search_data_source.dart';
import 'package:flutter_music_pro/src/data/suggestion/model.suggestion_list.dart';
import 'package:flutter_music_pro/src/data/track/model/track_list_model.dart';
import 'package:flutter_music_pro/src/domain/search/repository/search_repository.dart';

class SearchRepositoryImpl extends ISearchRepository {
  SearchRepositoryImpl({required this.iSearchDataSources});
  final ISearchDataSources iSearchDataSources;

  @override
  Future<Either<Failure,TrackList>> fetchSongSearchResults(
      String query, int page) async {
    final response = await iSearchDataSources.fetchSongSearchResults(query, page);
    return response.fold(
      (failure) => Left(failure),
      (tracksResponse) {
        return Right(tracksResponse);
      },
    );
  }

  @override
  Future<Either<Failure,AlbumList>> fetchAlbumSearchResults(String query, int page) async {
    final response = await iSearchDataSources.fetchAlbumSearchResults(query, page);
    return response.fold(
      (failure) => Left(failure),
      (albumsResponse) {
        return Right(albumsResponse);
      },
    );
  }

  @override
  Future<Either<Failure,ArtistList>> fetchArtistSearchResults(String query, int page) async {
    final response = await iSearchDataSources.fetchArtistSearchResults(query, page);
    return response.fold(
      (failure) => Left(failure),
      (artistsResponse) {
        if(artistsResponse.artistList?.isEmpty ?? true){
          left(NoDataFailure());
        }
        return Right(artistsResponse);
      },
    );
  }

  @override
  Future<Either<Failure,PlaylistList>> fetchPlaylistSearchResults(
      String query, int page) async {
    final response = await iSearchDataSources.fetchPlaylistSearchResults(query, page);
    return response.fold(
      (failure) => Left(failure),
      (playlistsResponse) {
        return Right(playlistsResponse);
      },
    );
  }

  @override
  Future<Either<Failure,ProfileList>> fetchProfileSearchResults(
      String query, int page) async {
    final response = await iSearchDataSources.fetchProfileSearchResults(query, page);
    return response.fold(
      (failure) => Left(failure),
      (profilesResponse) {
        return Right(profilesResponse);
      },
    );
  }

  @override
  Future<Either<Failure, SuggestionList>> fetchSearchSuggestionResults(String query) async{
    final response = await iSearchDataSources.fetchSearchSuggestionResults(query);
    return response.fold(
      (failure) => Left(failure),
      (suggestionResponse) {
        return Right(suggestionResponse);
      },
    );
  }
}
