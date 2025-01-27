part of 'album_bloc.dart';

abstract class AlbumEvent extends Equatable {
  const AlbumEvent();

  @override
  List<Object> get props => [];
}

class GetAlbumTrackEvent extends AlbumEvent {
  final int albumId;
  const GetAlbumTrackEvent(this.albumId);
}

class GetProductionAlbumsEvent extends AlbumEvent {
  final int pId;
  final int page;
  const GetProductionAlbumsEvent(this.pId, this.page);
}

class GetArtistAlbumsEvent extends AlbumEvent {
  final int artistId;
  final int page;
  const GetArtistAlbumsEvent(this.artistId, this.page);
}

class GetAllAlbumEvent extends AlbumEvent {
  final int page;
  const GetAllAlbumEvent(this.page);
}