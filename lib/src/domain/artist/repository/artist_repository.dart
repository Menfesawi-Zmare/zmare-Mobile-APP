import 'package:dartz/dartz.dart';
import 'package:zmare/src/core/error/error.dart';
import 'package:zmare/src/data/album/model/album_list.dart';
import 'package:zmare/src/data/artist/model/artist_detail.dart';
import 'package:zmare/src/data/artist/model/artist_list.dart';
import 'package:zmare/src/data/artist/model/artist_song_list.dart';
import 'package:zmare/src/data/profile/model/profile_list.dart';

abstract class IArtistRepository {
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
