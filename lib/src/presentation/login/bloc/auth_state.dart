part of 'auth_bloc.dart';

abstract class AuthState {}

class Loading extends AuthState {}

// ignore: must_be_immutable
class Authenticated extends AuthState {
  AuthProfile account;
  Authenticated(this.account);
}

class NoData extends AuthState {}

class Failure extends AuthState {
  final String message;
  Failure(this.message);
}

class UnAuthenticated extends AuthState {}

class AuthError extends AuthState {
  final String error;

  AuthError(this.error);
}

class RegisterState extends AuthState {
  final RegisterResponse registerResponse;

  RegisterState(this.registerResponse);
}

class LoginWithGmail extends AuthState {
  final RegisterResponse registerResponse;

  LoginWithGmail(this.registerResponse);
}

class UpdateBioState extends AuthState {
  List<Object?> get props => [];
  final UpdateAccountResponse updateAccountResponse;

  UpdateBioState(this.updateAccountResponse);
}

class UpdateImageState extends AuthState {
  List<Object?> get props => [];
  final UpdateAccountResponse updateAccountResponse;

  UpdateImageState(this.updateAccountResponse);
}

class UpdatePasswordState extends AuthState {
  List<Object?> get props => [];
  final UpdateAccountResponse updateAccountResponse;

  UpdatePasswordState(this.updateAccountResponse);
}

class GetSubsState extends AuthState {
  List<Object?> get props => [];
  final bool result;

  GetSubsState(this.result);
}

class GetAllPlaylistsState extends AuthState {
  List<Object?> get props => [];
  final PlaylistList all;
  GetAllPlaylistsState(this.all);
}

class CreatePlaylistState extends AuthState {
  List<Object?> get props => [];
  final CreatePlaylistResponse createPlaylistResponse;
  CreatePlaylistState(this.createPlaylistResponse);
}

class AddToPlaylistState extends AuthState {
  List<Object?> get props => [];
  final AddToPlaylistResponse addToPlaylistResponse;
  AddToPlaylistState(this.addToPlaylistResponse);
}

class UpdatePlaylistState extends AuthState {
  final bool result;
  UpdatePlaylistState(this.result);
}

class DeletePlaylistState extends AuthState {
  final bool result;
  DeletePlaylistState(this.result);
}

class DeleteAccountState extends AuthState {
  final bool result;
  DeleteAccountState(this.result);
}

class AddDownloadState extends AuthState {
  AddDownloadState();
}

class AddViewState extends AuthState {
  AddViewState();
}

class CheckFavoriteState extends AuthState {
  final bool favorite;
  CheckFavoriteState(this.favorite);
}

class LikeState extends AuthState {
  final bool result;
  LikeState(this.result);
}

class LoginWithUserNameAndPasswordState extends AuthState {
  LoginWithUserNameAndPasswordState();
}

class RegisterNormalState extends AuthState {
  final RegisterResponse registerResponse;

  RegisterNormalState(this.registerResponse);
}

class EulaToggleState extends AuthState {
  bool eulaAccepted;

  EulaToggleState(this.eulaAccepted);
}

class ValidFields extends AuthState {}
