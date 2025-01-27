import 'package:dartz/dartz.dart';
import 'package:flutter_music_pro/src/core/error/error.dart';
import 'package:flutter_music_pro/src/data/album/model/album_list.dart';
import 'package:flutter_music_pro/src/data/artist/data_source/artist_data_source.dart';
import 'package:flutter_music_pro/src/data/artist/model/artist_detail.dart';
import 'package:flutter_music_pro/src/data/artist/model/artist_list.dart';
import 'package:flutter_music_pro/src/data/artist/model/artist_song_list.dart';
import 'package:flutter_music_pro/src/data/profile/model/profile_list.dart';
import 'package:flutter_music_pro/src/domain/artist/repository/artist_repository.dart';

class ArtistRepositoryImpl extends IArtistRepository {
  ArtistRepositoryImpl({required this.iArtistDataSource});
  final IArtistDataSource iArtistDataSource;

  @override
  Future<Either<Failure,AlbumList>> getArtistAlbums(int uid, int page, String filter) async {
    final response = await iArtistDataSource.getArtistAlbums(uid, page, filter);
    return response.fold(
      (failure) => Left(failure),
      (artistAlbumsResponse) {
        if (artistAlbumsResponse.albumList?.isEmpty ?? true) {
          return Left(NoDataFailure());
        }
        return Right(artistAlbumsResponse);
      },
    );
  }

  @override
  Future<Either<Failure,ArtistTrackList>> getArtistTracks(int uid, String filter) async {
    final response = await iArtistDataSource.getArtistTracks(uid, filter);
    return response.fold(
      (failure) => Left(failure),
      (artistTracksResponse) {
        if (artistTracksResponse.trackList?.isEmpty ?? true) {
          return Left(NoDataFailure());
        }
        return Right(artistTracksResponse);
      },
    );
  } 

  @override
  Future<Either<Failure,ArtistTrackList>> getArtistAllTracks(int uid, String filter) async {
    final response = await iArtistDataSource.getArtistAllTracks(uid, filter);
    return response.fold(
      (failure) => Left(failure),
      (artistTracksResponse) {
        if (artistTracksResponse.trackList?.isEmpty ?? true) {
          return Left(NoDataFailure());
        }
        return Right(artistTracksResponse);
      },
    );
  }

  @override
  Future<Either<Failure,ArtistDetail>> getArtistDetail(int uid) async{
    final response = await iArtistDataSource.getArtistDetail(uid);
    return response.fold(
      (failure) => Left(failure),
      (artistDetailResponse) {
        if (artistDetailResponse.artist?.name?.isEmpty ?? true){
          return Left(NoDataFailure());
        }
        return Right(artistDetailResponse);
      },
    );
  }

  @override
  Future<Either<Failure,ArtistList>> getAllArtist(int page, String filter) async{
    final response = await iArtistDataSource.getAllArtist(page,filter);
    return response.fold(
      (failure) => Left(failure),
      (allArtistResponse) {
        if (allArtistResponse.artistList?.isEmpty ?? true) {
          return Left(NoDataFailure());
        }
        return Right(allArtistResponse);
      },
    );
  }

  @override
  Future<Either<Failure,ProfileList>> getSubscribers(int profileId, int page) async {
    final response = await iArtistDataSource.getSubscribers(profileId, page);
    return response.fold(
      (failure) => Left(failure),
      (subscribersResponse) {
        if (subscribersResponse.profiles?.isEmpty ?? true) {
          return Left(NoDataFailure());
        }
        return Right(subscribersResponse);
      },
    );
  }
}
