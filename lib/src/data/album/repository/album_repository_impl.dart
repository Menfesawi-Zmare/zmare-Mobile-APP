import 'package:dartz/dartz.dart';
import 'package:flutter_music_pro/src/core/error/error.dart';
import 'package:flutter_music_pro/src/data/album/data_sources/album_data_source.dart';
import 'package:flutter_music_pro/src/data/album/model/album_list.dart';
import 'package:flutter_music_pro/src/data/album/model/album_track_list.dart';
import 'package:flutter_music_pro/src/domain/album/repository/album_repository.dart';

class AlbumRepositoryImpl extends IAlbumRepository {
  AlbumRepositoryImpl({required this.iAlbumDataSource});
  final IAlbumDataSource iAlbumDataSource;

  @override
  Future<Either<Failure,AlbumTrackListModel>> getAlbumTrackList(int albumId) async {
    final response = await iAlbumDataSource.getAlbumTrackList(albumId);
    return response.fold(
      (failure) => Left(failure),
      (albumTrackListResponse) {
        if(albumTrackListResponse.songList?.isEmpty ?? true){
          Left(NoDataFailure());
        }
        return Right(albumTrackListResponse);
      },
    );
  }

  @override
  Future<Either<Failure,AlbumList>> getProductionAlbums(int pId, int page) async {
    final response = await iAlbumDataSource.getProductionAlbums(pId, page);
    return response.fold(
      (failure) => Left(failure),
      (productionAlbumResponse) {
        if(productionAlbumResponse.albumList?.isEmpty ?? true){
          Left(NoDataFailure());
        }
        return Right(productionAlbumResponse);
      },
    );
  }
  
  @override
  Future<Either<Failure,AlbumList>> getArtistAlbums(int artistId, int page) async{
    final response = await iAlbumDataSource.getArtistAlbums(artistId, page);
    return response.fold(
      (failure) => Left(failure),
      (artistAlbumResponse) {
        if(artistAlbumResponse.albumList?.isEmpty ?? true){
          Left(NoDataFailure());
        }
        return Right(artistAlbumResponse);
      },
    );
  }
  
  @override
  Future<Either<Failure,AlbumList>> getAllAlbum(int page) async{
    final response = await iAlbumDataSource.getAllAlbum(page);
    return response.fold(
      (failure) => Left(failure),
      (allAlbumResponse) {
        if(allAlbumResponse.albumList?.isEmpty ?? true){
          Left(NoDataFailure());
        }
        return Right(allAlbumResponse);
      },
    );
  }
}
