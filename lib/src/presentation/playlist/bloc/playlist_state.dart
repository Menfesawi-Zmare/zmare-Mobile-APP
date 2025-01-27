part of 'playlist_bloc.dart';

abstract class PlaylistState extends Equatable {
  const PlaylistState();

  @override
  List<Object> get props => [];
}

class PlaylistInitial extends PlaylistState {}

class PlaylistLoaded extends PlaylistState {
  final TrackList trackList;

  const PlaylistLoaded(this.trackList);
}

class PlaylistLoading extends PlaylistState {}

class PlaylistFailed extends PlaylistState {
  final String message;

  const PlaylistFailed(this.message);
}
