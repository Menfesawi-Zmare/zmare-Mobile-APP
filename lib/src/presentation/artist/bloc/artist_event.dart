part of 'artist_bloc.dart';

abstract class ArtistEvent {
  const ArtistEvent();
}

class GetArtistAlbumEvent extends ArtistEvent {
  final int artistId;
  final int page;
  final String filter;
  const GetArtistAlbumEvent(this.artistId, this.page, this.filter);
}

class GetArtistTrackListsEvent extends ArtistEvent {
  final int artistId;
  final String filter;
  const GetArtistTrackListsEvent(this.artistId, this.filter);
}

class GetArtistAllTrackListsEvent extends ArtistEvent {
  final int artistId;
  final String filter;
  const GetArtistAllTrackListsEvent(this.artistId, this.filter);
}

class GetArtistDetailEvent extends ArtistEvent {
  final int artistId;
  const GetArtistDetailEvent(this.artistId);
}

class GetAllArtistEvent extends ArtistEvent {
  final int page;
  final String filter;
  const GetAllArtistEvent(this.page, this.filter);
}
class GetArtistSubscribers extends ArtistEvent {
  final int profileId;
  final int page;

  const GetArtistSubscribers(this.profileId, this.page);
}
