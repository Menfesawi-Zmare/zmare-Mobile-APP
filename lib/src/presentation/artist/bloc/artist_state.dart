part of 'artist_bloc.dart';

abstract class ArtistState extends Equatable {
  const ArtistState();
  @override
  List<Object> get props => [];
}

class ArtistInitial extends ArtistState {}

class ArtistLoading extends ArtistState {}

class ArtistFailed extends ArtistState {
  final String message;
  const ArtistFailed(this.message);
}

class ArtistAlbumsLoaded extends ArtistState {
  final AlbumList all;
  const ArtistAlbumsLoaded(this.all);
}

class ArtistTrackLoaded extends ArtistState {
  final ArtistTrackList artistTrackList;
  const ArtistTrackLoaded(this.artistTrackList);
}
class ArtistDetailLoaded extends ArtistState {
  final ArtistDetail artistDetail;
  const ArtistDetailLoaded(this.artistDetail);
}
class ArtistLoaded extends ArtistState {
  final ArtistList artistList;
  const ArtistLoaded(this.artistList);
}
class ProfileLoaded extends ArtistState {
  final ProfileList profileList;

  const ProfileLoaded(this.profileList);
}
class NoData extends ArtistState {}
