part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfileDetailEvent extends ProfileEvent {}

class GetProfileLikes extends ProfileEvent {
  final int profileId;
  final int page;

  const GetProfileLikes(this.profileId, this.page);
}

class GetProfileSubscriptions extends ProfileEvent {
  final int profileId;
  final int page;

  const GetProfileSubscriptions(this.profileId, this.page);
}

class GetProfileSubscribers extends ProfileEvent {
  final int profileId;
  final int page;

  const GetProfileSubscribers(this.profileId, this.page);
}

class GetProfilePlaylists extends ProfileEvent {
  final int profileId;
  final int page;
  const GetProfilePlaylists(this.profileId, this.page);
}
