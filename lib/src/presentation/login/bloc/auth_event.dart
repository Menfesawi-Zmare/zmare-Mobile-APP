part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignInRequestedEvent extends AuthEvent {
  final String email;
  final String password;

  SignInRequestedEvent(this.email, this.password);
}

class SignUpRequestedEvent extends AuthEvent {
  final String username;
  final String confirmPassword;
  final String password;
  final String email;

  SignUpRequestedEvent(
      this.username, this.confirmPassword, this.password, this.email);
}

class AppSettingsEvent extends AuthEvent {}

class GoogleSignInRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class LoginWithSocial extends AuthEvent {
  final RegisterSocialRequest registerSocialRequest;
  LoginWithSocial(this.registerSocialRequest);
}

class GetProfileEvent extends AuthEvent {}

class UpdateBioEvent extends AuthEvent {
  final ProfileData profile;

  UpdateBioEvent(this.profile);
}

class UpdateSocialEvent extends AuthEvent {
  final ProfileData profile;

  UpdateSocialEvent(this.profile);
}

class UpdateImageEvent extends AuthEvent {
  final File file;
  final String type;
  UpdateImageEvent(this.file, this.type);
}

class ChangePasswordEvent extends AuthEvent {
  final String currentPassword;
  final String newPassword;
  final String repeatPassword;
  ChangePasswordEvent(
      this.currentPassword, this.newPassword, this.repeatPassword);
}

class GetSubsEvent extends AuthEvent {
  final int profileId;
  final String type;
  GetSubsEvent(this.profileId, this.type);
}

class AddSubsEvent extends AuthEvent {
  final int profileId;
  final String type;
  AddSubsEvent(this.profileId, this.type);
}

class CheckTrackInPlaylistsEvent extends AuthEvent {
  final int trackId;
  CheckTrackInPlaylistsEvent(this.trackId);
}

class GetAllPlaylistsEvent extends AuthEvent {}

class CreatePlaylistEvent extends AuthEvent {
  final CreatePlaylistModel createPlaylistModel;
  CreatePlaylistEvent(this.createPlaylistModel);
}

class AddToPlaylistEvent extends AuthEvent {
  final PlaylistsRequestModel playlistsRequestModel;
  AddToPlaylistEvent(this.playlistsRequestModel);
}

class UpdatePlaylistEvent extends AuthEvent {
  final PlaylistUpdateRequestModel playlistUpdateRequestModel;
  UpdatePlaylistEvent(this.playlistUpdateRequestModel);
}

class DeletePlaylistEvent extends AuthEvent {
  final int playlistId;
  DeletePlaylistEvent(this.playlistId);
}

class AddDownloadEvent extends AuthEvent {
  final String trackId;
  AddDownloadEvent(this.trackId);
}

class AddViewEvent extends AuthEvent {
  final String trackId;
  AddViewEvent(this.trackId);
}

class CheckFavoriteEvent extends AuthEvent {
  final int trackId;
  CheckFavoriteEvent(this.trackId);
}

class LikeTrackEvent extends AuthEvent {
  final LikeAndDislike likeAndDislike;
  LikeTrackEvent(this.likeAndDislike);
}

class LogoutEvent extends AuthEvent {}

// ignore: must_be_immutable
class ValidateFieldsEvent extends AuthEvent {
  GlobalKey<FormState> key;
  bool acceptEula;

  ValidateFieldsEvent(this.key, {required this.acceptEula});
}

// ignore: must_be_immutable
class ToggleEulaCheckboxEvent extends AuthEvent {
  bool eulaAccepted;

  ToggleEulaCheckboxEvent({required this.eulaAccepted});
}

class DeleteAccountEvent extends AuthEvent {
  final String currentPassword;
  DeleteAccountEvent(this.currentPassword);
}

class ResendEmailEvent extends AuthEvent {
  final String email;
  ResendEmailEvent(this.email);
}

class RequestResetPassworEvent extends AuthEvent {
  final String email;
  RequestResetPassworEvent(this.email);
}

class VerifyOtpEvent extends AuthEvent {
  final String otp;
  final String email;
  VerifyOtpEvent(this.email, this.otp);
}

class ResetPasswordEvent extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;
  ResetPasswordEvent(this.email, this.password, this.confirmPassword);
}
