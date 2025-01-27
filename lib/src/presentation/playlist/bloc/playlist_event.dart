part of 'playlist_bloc.dart';

abstract class PlaylistEvent extends Equatable {
  const PlaylistEvent();

  @override
  List<Object> get props => [];
}

class GetPlaylistEvent extends PlaylistEvent {
  final int playlistId;

  const GetPlaylistEvent(this.playlistId);
}

class GetKhmertrackPlaylistTracks extends PlaylistEvent{
  final int playlistId;
  final int type;

  const GetKhmertrackPlaylistTracks(this.playlistId, this.type);
}