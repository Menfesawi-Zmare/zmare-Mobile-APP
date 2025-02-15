import 'package:dartz/dartz.dart';
import 'package:zmare/src/core/error/error.dart';
import 'package:zmare/src/data/album/model/album_list.dart';
import 'package:zmare/src/data/album/model/album_track_list.dart';

abstract class IAlbumRepository {
  Future<Either<Failure, AlbumTrackListModel>> getAlbumTrackList(int albumId);
  Future<Either<Failure, AlbumList>> getProductionAlbums(int pId, int page);
  Future<Either<Failure, AlbumList>> getArtistAlbums(int artistId, int page);
  Future<Either<Failure, AlbumList>> getAllAlbum(int page);
}
