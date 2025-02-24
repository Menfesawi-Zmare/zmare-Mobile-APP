import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:zmare/src/core/error/error.dart';
import 'package:zmare/src/data/account/model/account.dart';
import 'package:zmare/src/data/auth/model/auth_profile.dart';
import 'package:zmare/src/data/auth/model/login_response.dart';
import 'package:zmare/src/data/auth/model/logout_model.dart';
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

abstract class IAuthRepository {
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
  Future<Either<Failure, UpdateAccountResponse>> changePassword(
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
}
