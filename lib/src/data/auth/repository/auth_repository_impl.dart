import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:zmare/src/core/error/failure.dart';
import 'package:zmare/src/data/account/model/account.dart';
import 'package:zmare/src/data/auth/data_sources/auth_data_source.dart';
import 'package:zmare/src/data/auth/model/auth_profile.dart';
import 'package:zmare/src/data/auth/model/login_response.dart';
import 'package:zmare/src/data/auth/model/logout_model.dart';
import 'package:zmare/src/data/auth/model/resend_email_model.dart';
import 'package:zmare/src/data/auth/model/update_account_response.dart';
import 'package:zmare/src/data/like/model/like_dislike.dart';
import 'package:zmare/src/data/playlist/model/add_to_playlist_response.dart';
import 'package:zmare/src/data/playlist/model/create_playlist_model.dart';
import 'package:zmare/src/data/playlist/model/playlist_list.dart';
import 'package:zmare/src/data/playlist/model/playlist_update_request_model.dart';
import 'package:zmare/src/data/playlist/model/playlists_request_model.dart';
import 'package:zmare/src/data/playlist/model/response/create_playlist_response.dart';
import 'package:zmare/src/data/register/model/register_response.dart';
import 'package:zmare/src/data/register/model/register_social_request.dart';
import 'package:zmare/src/data/setting/model/setting.dart';
import 'package:zmare/src/domain/auth/repository/auth_repository.dart';
import 'package:zmare/src/core/error/error.dart';

class AuthRepositoryImpl extends IAuthRepository {
  AuthRepositoryImpl({required this.iAuthDataSource});
  final IAuthDataSource iAuthDataSource;
  @override
  Future<Either<Failure, AuthProfile>> authProfile() async {
    final response = await iAuthDataSource.authProfile();
    return response.fold(
      (failure) => Left(failure),
      (authResponse) {
        return Right(authResponse);
      },
    );
  }

  @override
  Future<Either<Failure, RegisterResponse>> loginWithSocial(
      RegisterSocialRequest registerSocialRequest) async {
    final response =
        await iAuthDataSource.loginWithSocial(registerSocialRequest);
    return response.fold(
      (failure) => Left(failure),
      (registerResponse) {
        return Right(registerResponse);
      },
    );
  }

  @override
  Future<Either<Failure, UpdateAccountResponse>> updateBio(
      ProfileData profile) async {
    final response = await iAuthDataSource.updateBio(profile);
    return response.fold(
      (failure) => Left(failure),
      (message) {
        return Right(message);
      },
    );
  }

  @override
  Future<Either<Failure, UpdateAccountResponse>> updateSocial(
      ProfileData profile) async {
    final response = await iAuthDataSource.updateSocial(profile);
    return response.fold(
      (failure) => Left(failure),
      (message) {
        return Right(message);
      },
    );
  }

  @override
  Future<Either<Failure, UpdateAccountResponse>> updateImage(
      File file, String imageType) async {
    final response = await iAuthDataSource.updateImage(file, imageType);
    return response.fold(
      (failure) => Left(failure),
      (message) {
        return Right(message);
      },
    );
  }

  @override
  Future<Either<Failure, UpdateAccountResponse>> changePassword(
      String currentPassword, String newPassword, String repeatPassword) async {
    final response = await iAuthDataSource.updatePassword(
        currentPassword, newPassword, repeatPassword);
    return response.fold(
      (failure) => Left(failure),
      (message) {
        return Right(message);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> checkSubscribe(
      int profileId, String type) async {
    final response = await iAuthDataSource.checkSubscribe(profileId, type);
    return response.fold(
      (failure) => Left(failure),
      (message) {
        return Right(message);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> addSubscribe(int profileId, String type) async {
    final response = await iAuthDataSource.addSubscribe(profileId, type);
    return response.fold(
      (failure) => Left(failure),
      (message) {
        return Right(message);
      },
    );
  }

  @override
  Future<Either<Failure, PlaylistList>> checkTrackInPlaylist(
      int trackId) async {
    final response = await iAuthDataSource.checkTrackInPlaylist(trackId);
    return response.fold(
      (failure) => Left(failure),
      (playlistModel) {
        if (playlistModel.playlist?.isEmpty ?? true) {
          return Left(NoDataFailure());
        }
        return Right(playlistModel);
      },
    );
  }

  @override
  Future<Either<Failure, PlaylistList>> accountPlaylists() async {
    final response = await iAuthDataSource.accountPlaylists();
    return response.fold(
      (failure) => Left(failure),
      (playlistModel) {
        if (playlistModel.playlist?.isEmpty ?? true) {
          return Left(NoDataFailure());
        }
        return Right(playlistModel);
      },
    );
  }

  @override
  Future<Either<Failure, CreatePlaylistResponse>> createPlaylist(
      CreatePlaylistModel createPlaylistModel) async {
    final response = await iAuthDataSource.createPlaylist(createPlaylistModel);
    return response.fold(
      (failure) => Left(failure),
      (playlistModel) {
        return Right(playlistModel);
      },
    );
  }

  @override
  Future<Either<Failure, AddToPlaylistResponse>> addToPlaylist(
      PlaylistsRequestModel playlistsRequestModel) async {
    final response = await iAuthDataSource.addToPlaylist(playlistsRequestModel);
    return response.fold(
      (failure) => Left(failure),
      (playlistResponse) {
        return Right(playlistResponse);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> updatePlaylist(
      PlaylistUpdateRequestModel playlistUpdateRequestModel) async {
    final response =
        await iAuthDataSource.updatePlaylist(playlistUpdateRequestModel);
    return response.fold(
      (failure) => Left(failure),
      (playlistUpdate) {
        return Right(playlistUpdate);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> deletePlaylist(int playlistId) async {
    final response = await iAuthDataSource.deletePlaylist(playlistId);
    return response.fold(
      (failure) => Left(failure),
      (response) {
        return Right(response);
      },
    );
  }

  @override
  Future<Either<Failure, String>> addDownload(String trackId) async {
    final response = await iAuthDataSource.addDownload(trackId);
    return response.fold(
      (failure) => Left(failure),
      (message) {
        return Right(message);
      },
    );
  }

  @override
  Future<Either<Failure, String>> addView(String trackId) async {
    final response = await iAuthDataSource.addView(trackId);
    return response.fold(
      (failure) => Left(failure),
      (message) {
        return Right(message);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> checkFavorite(int trackId) async {
    final response = await iAuthDataSource.checkFavorite(trackId);
    return response.fold(
      (failure) => Left(failure),
      (message) {
        return Right(message);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> like(LikeAndDislike likeAndDislike) async {
    final response = await iAuthDataSource.like(likeAndDislike);
    return response.fold(
      (failure) => Left(failure),
      (message) {
        return Right(message);
      },
    );
  }

  @override
  Future<Either<Failure, LoginResponse>> loginWithUsernameAndPassword(
      String username, String password) async {
    final response =
        await iAuthDataSource.loginWithUsernameAndPassword(username, password);
    return response.fold(
      (failure) => Left(failure),
      (loginResponse) {
        return Right(loginResponse);
      },
    );
  }

  @override
  Future<Either<Failure, RegisterResponse>> registerNormal(
      String username, String password, String email) async {
    final response =
        await iAuthDataSource.registerNormal(username, password, email);
    return response.fold(
      (failure) => Left(failure),
      (registerResponse) {
        return Right(registerResponse);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> deleteAccount(String currentPassword) async {
    final response = await iAuthDataSource.deleteAccount(currentPassword);
    return response.fold(
      (failure) => Left(failure),
      (message) {
        return Right(message);
      },
    );
  }

  @override
  Future<Either<Failure, LogoutModel>> logout() async {
    final response = await iAuthDataSource.logout();
    return response.fold(
      (failure) => Left(failure),
      (message) {
        return Right(message);
      },
    );
  }

  @override
  Future<Either<Failure, AppSetting>> appSettings() async {
    final response = await iAuthDataSource.appSettings();
    return response.fold(
      (failure) => Left(failure),
      (message) {
        return Right(message);
      },
    );
  }

  @override
  Future<Either<Failure, ResendEmailModel>> resendEmail(email) async {
    final response = await iAuthDataSource.resendEmail(email);
    return response.fold(
      (failure) => Left(failure),
      (message) {
        return Right(message);
      },
    );
  }
}
