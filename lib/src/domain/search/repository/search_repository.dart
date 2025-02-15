import 'package:dartz/dartz.dart';
import 'package:zmare/src/core/error/error.dart';
import 'package:zmare/src/data/album/model/album_list.dart';
import 'package:zmare/src/data/artist/model/artist_list.dart';
import 'package:zmare/src/data/playlist/model/playlist_list.dart';
import 'package:zmare/src/data/profile/model/profile_list.dart';
import 'package:zmare/src/data/suggestion/model.suggestion_list.dart';
import 'package:zmare/src/data/track/model/track_list_model.dart';

abstract class ISearchRepository {
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
