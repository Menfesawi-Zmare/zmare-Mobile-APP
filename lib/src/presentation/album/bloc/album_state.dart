part of 'album_bloc.dart';

abstract class AlbumState extends Equatable {
  const AlbumState();

  @override
  List<Object> get props => [];
}

class AlbumInitial extends AlbumState {}

class AlbumLoading extends AlbumState {}

class AlbumLoaded extends AlbumState {
  final AlbumTrackListModel albumTrack;

  const AlbumLoaded(this.albumTrack);
}

class AlbumLoadFailed extends AlbumState {
  final String message;

  const AlbumLoadFailed(this.message);
}

class ProductionAlbumsLoaded extends AlbumState {
  final AlbumList productionAlbums;

  const ProductionAlbumsLoaded(this.productionAlbums);
}

class ArtistAlbum extends AlbumState {
  final AlbumList albumList;

  const ArtistAlbum(this.albumList);
}

class AllAlbum extends AlbumState {
  final AlbumList all;

  const AllAlbum(this.all);
}