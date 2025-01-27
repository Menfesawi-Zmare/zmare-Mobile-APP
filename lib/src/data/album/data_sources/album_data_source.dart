import 'package:dartz/dartz.dart';
import 'package:flutter_music_pro/src/core/api/api.dart';
import 'package:flutter_music_pro/src/core/error/error.dart';
import 'package:flutter_music_pro/src/data/album/model/album_list.dart';
import 'package:flutter_music_pro/src/data/album/model/album_track_list.dart';

abstract class IAlbumDataSource {
  Future<Either<Failure,AlbumTrackListModel>> getAlbumTrackList(int albumId);
  Future<Either<Failure,AlbumList>> getProductionAlbums(int pId, int page);
  Future<Either<Failure,AlbumList>> getArtistAlbums(int artistId, int page);
  Future<Either<Failure,AlbumList>> getAllAlbum(int page);
}

class AlbumDataSource extends IAlbumDataSource {
  AlbumDataSource(this._client);
  final DioClient _client;

  @override
  Future<Either<Failure,AlbumTrackListModel>> getAlbumTrackList(int albumId) async {
    final response = await _client.getRequest(
      '${ListAPI.albumDetail}$albumId',
      converter: (response) =>
          AlbumTrackListModel.fromJson(response as Map<String, dynamic>),
    );

    return response;
  }

  @override
  Future<Either<Failure,AlbumList>> getProductionAlbums(int pId, int page) async {
    final response = await _client.getRequest(
      '${ListAPI.productionAlbums}$pId',
      queryParameters: {'page' : page},
      converter: (response) =>
          AlbumList.fromJson(response as Map<String, dynamic>),
    );

    return response;
  }
  
  @override
  Future<Either<Failure,AlbumList>> getArtistAlbums(int artistId, int page) async{
    final response = await _client.getRequest(
      '${ListAPI.artistAlbums}$artistId',
      queryParameters: {'page' : page},
      converter: (response) =>
          AlbumList.fromJson(response as Map<String, dynamic>),
    );

    return response;
  }
  
  @override
  Future<Either<Failure,AlbumList>> getAllAlbum(int page) async{
    final response = await _client.getRequest(
      ListAPI.album,
      queryParameters: {'page' : page},
      converter: (response) =>
          AlbumList.fromJson(response as Map<String, dynamic>),
    );
    return response;
  }
}
