import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zmare/src/core/api/api.dart';
import 'package:zmare/src/core/enum/profile_image_type.dart';
import 'package:zmare/src/core/error/error.dart';
import 'package:zmare/src/data/account/model/account.dart';
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

abstract class IAuthDataSource {
  Future<Either<Failure, RegisterResponse>> loginWithSocial(
      RegisterSocialRequest registerSocialRequest);
  Future<Either<Failure, RegisterResponse>> registerNormal(
      String username, String password, String email);
  Future<Either<Failure, LoginResponse>> loginWithUsernameAndPassword(
      String username, String password);
  Future<Either<Failure, AuthProfile>> authProfile();
  Future<Either<Failure, UpdateAccountResponse>> updateBio(ProfileData profile);
  Future<Either<Failure, UpdateAccountResponse>> updateSocial(
      ProfileData profile);
  Future<Either<Failure, UpdateAccountResponse>> updateImage(
      File file, String imageType);
  Future<Either<Failure, UpdateAccountResponse>> updatePassword(
      String currentPassword, String newPassword, String repeatPassword);
  Future<Either<Failure, bool>> checkSubscribe(int profileId, String type);
  Future<Either<Failure, bool>> addSubscribe(int profileId, String type);
  Future<Either<Failure, PlaylistList>> accountPlaylists();
  Future<Either<Failure, PlaylistList>> checkTrackInPlaylist(int trackId);
  Future<Either<Failure, CreatePlaylistResponse>> createPlaylist(
      CreatePlaylistModel createPlaylistModel);
  Future<Either<Failure, AddToPlaylistResponse>> addToPlaylist(
      PlaylistsRequestModel playlistsRequestModel);
  Future<Either<Failure, bool>> updatePlaylist(
      PlaylistUpdateRequestModel playlistUpdateRequestModel);
  Future<Either<Failure, bool>> deletePlaylist(int playlistId);
  Future<Either<Failure, bool>> deleteAccount(String currentPassword);
  Future<Either<Failure, String>> addDownload(String trackId);
  Future<Either<Failure, String>> addView(String trackId);
  Future<Either<Failure, bool>> checkFavorite(int trackId);
  Future<Either<Failure, bool>> like(LikeAndDislike likeAndDislike);
  Future<Either<Failure, AppSetting>> appSettings();
  Future<Either<Failure, LogoutModel>> logout();
  Future<Either<Failure, ResendEmailModel>> resendEmail(String email);
}

class AuthDataSource extends IAuthDataSource {
  AuthDataSource(this._client);
  final DioClient _client;
  @override
  Future<Either<Failure, AuthProfile>> authProfile() async {
    final response = await _client.getRequest(
      ListAPI.account,
      converter: (response) =>
          AuthProfile.fromJson(response as Map<String, dynamic>),
    );
    return response;
  }

  @override
  Future<Either<Failure, RegisterResponse>> loginWithSocial(
      RegisterSocialRequest registerSocialRequest) async {
    final response = await _client.postRequest(
      ListAPI.loginWithSocial,
      data: registerSocialRequest.toJson(),
      converter: (response) =>
          RegisterResponse.fromJson(response as Map<String, dynamic>),
    );

    return response;
  }

  @override
  Future<Either<Failure, UpdateAccountResponse>> updateBio(
      ProfileData profile) async {
    final response = await _client.putRequest(
      ListAPI.updateBio,
      data: profile.toJson(),
      converter: (response) => UpdateAccountResponse.fromJson(response),
    );

    return response;
  }

  @override
  Future<Either<Failure, UpdateAccountResponse>> updateSocial(
      ProfileData profile) async {
    final response = await _client.putRequest(
      ListAPI.updateSocial,
      data: profile.toJson(),
      converter: (response) => UpdateAccountResponse.fromJson(response),
    );

    return response;
  }

  @override
  Future<Either<Failure, UpdateAccountResponse>> updateImage(
      File file, String imageType) async {
    String fileName = file.path.split('/').last;
    var formData = FormData.fromMap({
      imageType == ProfileImageType.avatar.name ? "image" : "cover":
          await MultipartFile.fromFile(file.path, filename: fileName),
    });
    final response = await _client.postRequest(
      imageType == ProfileImageType.avatar.name
          ? ListAPI.updateAvatar
          : ListAPI.updateCover,
      data: formData,
      converter: (response) => UpdateAccountResponse.fromJson(response),
    );

    return response;
  }

  @override
  Future<Either<Failure, UpdateAccountResponse>> updatePassword(
      String currentPassword, String newPassword, String repeatPassword) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_password'] = currentPassword;
    data['password'] = newPassword;
    data['password_confirmation'] = repeatPassword;
    final response = await _client.putRequest(
      ListAPI.updatePassword,
      data: data,
      converter: (response) => UpdateAccountResponse.fromJson(response),
    );

    return response;
  }

  @override
  Future<Either<Failure, bool>> checkSubscribe(
      int profileId, String type) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    final response = await _client.postRequest(
      '${ListAPI.checkSubscribe}$profileId',
      data: data,
      converter: (response) => response['data'] as bool,
    );

    return response;
  }

  @override
  Future<Either<Failure, bool>> addSubscribe(int profileId, String type) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    final response = await _client.postRequest(
      '${ListAPI.subscribe}$profileId',
      data: data,
      converter: (response) => response['data'] as bool,
    );

    return response;
  }

  @override
  Future<Either<Failure, PlaylistList>> checkTrackInPlaylist(
      int? trackId) async {
    final response = await _client.getRequest(
      '${ListAPI.checkTrackInPlaylist}$trackId',
      converter: (response) => PlaylistList.fromJson(response),
    );

    return response;
  }

  @override
  Future<Either<Failure, PlaylistList>> accountPlaylists() async {
    final response = await _client.getRequest(
      ListAPI.accountPlaylists,
      converter: (response) => PlaylistList.fromJson(response),
    );

    return response;
  }

  @override
  Future<Either<Failure, CreatePlaylistResponse>> createPlaylist(
      CreatePlaylistModel createPlaylistModel) async {
    final response = await _client.postRequest(
      ListAPI.createPlaylist,
      data: createPlaylistModel.toJson(),
      converter: (response) => CreatePlaylistResponse.fromJson(response),
    );

    return response;
  }

  @override
  Future<Either<Failure, AddToPlaylistResponse>> addToPlaylist(
      PlaylistsRequestModel playlistsRequestModel) async {
    final response = await _client.postRequest(
      ListAPI.addToPlaylist,
      data: playlistsRequestModel.toJson(),
      converter: (response) => AddToPlaylistResponse.fromJson(response),
    );

    return response;
  }

  @override
  Future<Either<Failure, bool>> updatePlaylist(
      PlaylistUpdateRequestModel playlistUpdateRequestModel) async {
    final response = await _client.postRequest(
      ListAPI.updatePlaylist,
      data: playlistUpdateRequestModel.toJson(),
      converter: (response) => response['status'] as bool,
    );

    return response;
  }

  @override
  Future<Either<Failure, bool>> deletePlaylist(int playlistId) async {
    final response = await _client.deleteRequest(
      '${ListAPI.deletePlaylist}$playlistId',
      converter: (response) => response['status'] as bool,
    );

    return response;
  }

  @override
  Future<Either<Failure, String>> addDownload(String trackId) async {
    final response = await _client.postRequest(
      '${ListAPI.addDownload}$trackId',
      converter: (response) => response['message'] as String,
    );

    return response;
  }

  @override
  Future<Either<Failure, String>> addView(String trackId) async {
    final response = await _client.postRequest(
      '${ListAPI.addView}$trackId',
      converter: (response) => response['message'] as String,
    );

    return response;
  }

  @override
  Future<Either<Failure, bool>> checkFavorite(int trackId) async {
    final response = await _client.postRequest(
      '${ListAPI.checkFavorite}$trackId',
      converter: (response) => response['data'] as bool,
    );

    return response;
  }

  @override
  Future<Either<Failure, bool>> like(LikeAndDislike likeAndDislike) async {
    final response = await _client.postRequest(
      ListAPI.like,
      data: likeAndDislike.toJson(),
      converter: (response) => response['data'] as bool,
    );

    return response;
  }

  @override
  Future<Either<Failure, LoginResponse>> loginWithUsernameAndPassword(
      String username, String password) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    final response = await _client.postRequest(
      ListAPI.login,
      data: data,
      converter: (response) => LoginResponse.fromJson(response),
    );

    return response;
  }

  @override
  Future<Either<Failure, RegisterResponse>> registerNormal(
      String username, String password, String email) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    data['password_confirmation'] = password;
    data['email'] = email;
    data['type'] = 'normal';
    data['image'] = '';
    final response = await _client.postRequest(
      ListAPI.register,
      data: data,
      converter: (response) => RegisterResponse.fromJson(response),
    );

    return response;
  }

  @override
  Future<Either<Failure, bool>> deleteAccount(String currentPassword) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['password'] = currentPassword;
    final response = await _client.deleteRequest(
      ListAPI.deleteAccount,
      data: data,
      converter: (response) => response['status'] as bool,
    );
    return response;
  }

  @override
  Future<Either<Failure, LogoutModel>> logout() async {
    final response = await _client.postRequest(
      ListAPI.logout,
      converter: (response) => LogoutModel.fromJson(response),
    );
    return response;
  }

  @override
  Future<Either<Failure, AppSetting>> appSettings() async {
    final response = await _client.getRequest(
      ListAPI.settings,
      converter: (response) => AppSetting.fromJson(response),
    );
    return response;
  }

  @override
  Future<Either<Failure, ResendEmailModel>> resendEmail(String email) async {
    final response = await _client.postRequest(
      data: {"email": email},
      ListAPI.resendEmail,
      converter: (response) => ResendEmailModel.fromJson(response),
    );
    return response;
  }
}
