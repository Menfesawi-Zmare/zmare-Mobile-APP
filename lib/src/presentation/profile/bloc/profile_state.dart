part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileDetailLoaded extends ProfileState {}

class ProfileFailed extends ProfileState {
  final String message;

  const ProfileFailed(this.message);
}

class ProfileLoaded extends ProfileState {
  final FollowResponseModel profileList;

  const ProfileLoaded(this.profileList);
}

class ProfileLikes extends ProfileState {
  final TrackList trackList;

  const ProfileLikes(this.trackList);
}

class ProfilePlaylists extends ProfileState {
  final PlaylistList playlistList;
  const ProfilePlaylists(this.playlistList);
}

class NoData extends ProfileState {}