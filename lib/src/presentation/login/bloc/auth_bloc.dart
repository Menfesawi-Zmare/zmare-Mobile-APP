import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/data/auth/model/auth_profile.dart';
import 'package:zmare/src/data/auth/model/update_account_response.dart';
import 'package:zmare/src/data/playlist/model/add_to_playlist_response.dart';
import 'package:zmare/src/data/playlist/model/create_playlist_model.dart';
import 'package:zmare/src/data/playlist/model/playlist_list.dart';
import 'package:zmare/src/data/playlist/model/response/create_playlist_response.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zmare/src/app/routes.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/login_type.dart';
import 'package:zmare/src/core/error/error.dart';
import 'package:zmare/src/data/account/model/account.dart';
import 'package:zmare/src/data/like/model/like_dislike.dart';
import 'package:zmare/src/data/playlist/model/playlist_update_request_model.dart';
import 'package:zmare/src/data/playlist/model/playlists_request_model.dart';
import 'package:zmare/src/data/register/model/register_response.dart';
import 'package:zmare/src/data/register/model/register_social_request.dart';
import 'package:zmare/src/domain/auth/repository/auth_repository.dart';
import 'package:logging/logging.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository iAuthRepository;
  AuthBloc({required this.iAuthRepository}) : super(UnAuthenticated()) {
    on<LoginWithSocial>((event, emit) async {
      emit(Loading());
      final data =
          await iAuthRepository.loginWithSocial(event.registerSocialRequest);
      data.fold(
        (l) {
          if (l is ServerFailure) {
            emit(Failure(l.message ?? ''));
          }
        },
        (r) {
          settings.put(loginType, LoginType.google.name);
          settings.put(accessToken, r.data!.token);
          settings.put(userIntroKey, true);
          emit(LoginWithGmail(r));
        },
      );
    });

    on<SignInRequestedEvent>((event, emit) async {
      emit(Loading());
      final data = await iAuthRepository.loginWithUsernameAndPassword(
          event.email, event.password);
      data.fold(
        (l) {
          if (l is ServerFailure) {
            emit(Failure(l.message ?? ''));
          }
        },
        (r) {
          //Suspended Account
          if (r.status == false) {
            emit(Failure(r.message!));
          } else {
            settings.put(loginType, LoginType.normal);
            settings.put(accessToken, r.data!.token);
            settings.put(userIntroKey, true);
            emit(LoginWithUserNameAndPasswordState());
          }
        },
      );
    });

    on<SignUpRequestedEvent>((event, emit) async {
      emit(Loading());
      final data = await iAuthRepository.registerNormal(
          event.username, event.password, event.email);
      data.fold(
        (l) {
          if (l is ServerFailure) {
            emit(Failure(l.message!));
          }
        },
        (r) {
          settings.put(loginType, LoginType.normal);
          settings.put(accessToken, r.data!.token);
          settings.put(userIntroKey, true);
          emit(RegisterNormalState(r));
        },
      );
    });

    on<GetProfileEvent>((event, emit) async {
      emit(Loading());
      String? authToken = settings.get(accessToken, defaultValue: null);
      if (authToken != null) {
        final data = await iAuthRepository.authProfile();
        data.fold((l) {
          if (l is ServerFailure) {
            settings.put(accessToken, null);
            account.put(accountDetail, '');
            emit(UnAuthenticated());
          }
        }, (r) {
          if (r.status == false) {
            settings.put(accessToken, null);
            account.put(accountDetail, '');
            emit(UnAuthenticated());
          } else {
            account.put(accountDetail, r.profile?.toJson());
            emit(Authenticated(r));
          }
        });
      } else {
        emit(UnAuthenticated());
      }
    });
    //Update General
    on<UpdateBioEvent>((event, emit) async {
      emit(Loading());
      final data = await iAuthRepository.updateBio(event.profile);
      data.fold((l) {
        if (l is ServerFailure) {
          emit(Failure(l.message ?? ""));
        }
      }, (r) {
        emit(UpdateBioState(r));
      });
    });
    //Update Social
    on<UpdateSocialEvent>((event, emit) async {
      emit(Loading());
      final data = await iAuthRepository.updateSocial(event.profile);
      data.fold((l) {
        if (l is ServerFailure) {
          emit(Failure(l.message ?? ""));
        }
      }, (r) {
        emit(UpdateBioState(r));
      });
    });
    //Update Avatar & Cover Profile
    on<UpdateImageEvent>((event, emit) async {
      emit(Loading());
      final data = await iAuthRepository.updateImage(event.file, event.type);
      data.fold((l) {
        if (l is ServerFailure) {
          emit(Failure(l.message ?? ""));
        }
      }, (r) {
        emit(UpdateImageState(r));
      });
    });
    //Change Password
    on<ChangePasswordEvent>((event, emit) async {
      emit(Loading());
      final data = await iAuthRepository.changePassword(
          event.currentPassword, event.newPassword, event.repeatPassword);
      data.fold((l) {
        if (l is ServerFailure) {
          emit(Failure(l.message ?? ""));
        }
      }, (r) {
        emit(UpdatePasswordState(r));
      });
    });
    //Check Subscribe
    on<GetSubsEvent>((event, emit) async {
      emit(Loading());
      final data =
          await iAuthRepository.checkSubscribe(event.profileId, event.type);
      data.fold((l) {
        if (l is ServerFailure) {
          emit(Failure(l.message ?? ""));
        }
      }, (r) {
        emit(GetSubsState(r));
      });
    });
    //Add Subscribe
    on<AddSubsEvent>((event, emit) async {
      emit(Loading());
      final data =
          await iAuthRepository.addSubscribe(event.profileId, event.type);
      data.fold((l) {
        if (l is ServerFailure) {
          emit(Failure(l.message ?? ""));
        }
      }, (r) {
        emit(GetSubsState(r));
      });
    });
    //Get All Playlists
    on<GetAllPlaylistsEvent>((event, emit) async {
      emit(Loading());
      final data = await iAuthRepository.accountPlaylists();
      data.fold((l) {
        if (l is ServerFailure) {
          emit(Failure(l.message ?? ""));
        }
      }, (r) {
        emit(GetAllPlaylistsState(r));
      });
    });
    //Check Track In Playlists
    on<CheckTrackInPlaylistsEvent>((event, emit) async {
      emit(Loading());
      final data = await iAuthRepository.checkTrackInPlaylist(event.trackId);
      data.fold((l) {
        if (l is ServerFailure) {
          emit(Failure(l.message ?? ""));
        }
        if (l is NoDataFailure) {
          emit(NoData());
        }
      }, (r) {
        emit(GetAllPlaylistsState(r));
      });
    });
    //Create Playlist
    on<CreatePlaylistEvent>((event, emit) async {
      emit(Loading());
      final data =
          await iAuthRepository.createPlaylist(event.createPlaylistModel);
      data.fold((l) {
        if (l is ServerFailure) {
          emit(Failure(l.message ?? ""));
        }
      }, (r) {
        emit(CreatePlaylistState(r));
      });
    });
    //Add to Playlist
    on<AddToPlaylistEvent>((event, emit) async {
      final data =
          await iAuthRepository.addToPlaylist(event.playlistsRequestModel);
      Logger.root.info(data);
      data.fold((l) {
        if (l is ServerFailure) {
          emit(Failure(l.message ?? ""));
        }
      }, (r) {
        emit(AddToPlaylistState(r));
      });
    });
    //Update Playlist
    on<UpdatePlaylistEvent>((event, emit) async {
      emit(Loading());
      final data = await iAuthRepository
          .updatePlaylist(event.playlistUpdateRequestModel);
      data.fold((l) {
        if (l is ServerFailure) {
          emit(Failure(l.message ?? ""));
        }
      }, (r) {
        emit(UpdatePlaylistState(r));
      });
    });
    //Delete
    on<DeletePlaylistEvent>((event, emit) async {
      emit(Loading());
      final data = await iAuthRepository.deletePlaylist(event.playlistId);
      data.fold((l) {
        if (l is ServerFailure) {
          emit(Failure(l.message ?? ""));
        }
      }, (r) {
        emit(DeletePlaylistState(r));
      });
    });
    //Add Download
    on<AddDownloadEvent>((event, emit) async {
      emit(Loading());
      final data = await iAuthRepository.addDownload(event.trackId);
      data.fold((l) {
        if (l is ServerFailure) {
          emit(Failure(l.message ?? ""));
        }
      }, (r) {
        emit(AddDownloadState());
      });
    });
    //Add View
    on<AddViewEvent>((event, emit) async {
      emit(Loading());
      final data = await iAuthRepository.addView(event.trackId);
      data.fold((l) {
        if (l is ServerFailure) {
          emit(Failure(l.message ?? ""));
        }
      }, (r) {
        emit(AddViewState());
      });
    });
    //Check Favorite
    on<CheckFavoriteEvent>((event, emit) async {
      emit(Loading());
      final data = await iAuthRepository.checkFavorite(event.trackId);
      data.fold((l) {
        if (l is ServerFailure) {
          emit(Failure(l.message ?? ""));
        }
      }, (r) {
        emit(CheckFavoriteState(r));
      });
    });
    //Like Track
    on<LikeTrackEvent>((event, emit) async {
      emit(Loading());
      final data = await iAuthRepository.like(event.likeAndDislike);
      data.fold((l) {
        if (l is ServerFailure) {
          emit(Failure(l.message ?? ""));
        }
      }, (r) {
        emit(LikeState(r));
      });
    });
    //Logout
    on<LogoutEvent>((event, emit) async {
      emit(Loading());
      final data = await iAuthRepository.logout();
      data.fold((l) {
        if (l is ServerFailure) {
          emit(Failure(l.message ?? ""));
        }
      }, (r) {
        var getLoginType = settings.get(loginType, defaultValue: false);
        if (getLoginType == LoginType.google.name) {
          GoogleSignIn().signOut();
        }
        settings.put(accessToken, null);
        account.put(accountDetail, '');
        emit(UnAuthenticated());
      });
    });
    on<ValidateFieldsEvent>((event, emit) async {
      if (event.key.currentState?.validate() ?? false) {
        if (event.acceptEula) {
          event.key.currentState!.save();
          emit(ValidFields());
        } else {
          emit(Failure('Please accept our terms of use.'));
        }
      } else {
        emit(Failure('Please fill required fields.'));
      }
    });
    on<ToggleEulaCheckboxEvent>(
        (event, emit) => emit(EulaToggleState(event.eulaAccepted)));
    //Delete Account
    on<DeleteAccountEvent>((event, emit) async {
      emit(Loading());
      final data = await iAuthRepository.deleteAccount(event.currentPassword);
      data.fold((l) {
        if (l is ServerFailure) {
          emit(Failure(l.message ?? ""));
        }
      }, (r) {
        var getLoginType = settings.get(loginType, defaultValue: false);
        if (getLoginType == LoginType.google.name) {
          GoogleSignIn().signOut();
        }
        settings.put(accessToken, '');
        account.put(accountDetail, '');
        emit(DeleteAccountState(r));
      });
    });
    //App Settings
    on<AppSettingsEvent>((event, emit) async {
      final data = await iAuthRepository.appSettings();
      data.fold((l) {
        if (l is ServerFailure) {
          emit(Failure(l.message ?? ""));
        }
      }, (r) {
        settings.put(explorerPerPage, r.ePerPage);
        settings.put(facebookUrl, r.facebook);
        settings.put(youtubeUrl, r.youtube);
        settings.put(telegramUrl, r.telegram);
        settings.put(instagramUrl, r.instagram);
        settings.put(twitterUrl, r.twitter);
        settings.put(playStoreUrl, r.psUrl);
        settings.put(appStoreUrl, r.asUrl);
        settings.put(tosUrl, r.tosUrl);
        settings.put(privacyUrl, r.privacyUrl);
        settings.put(androidExplorerAd, r.androidExplorerAd);
        settings.put(androidInterstitialAd, r.androidInterstitialAd);
        settings.put(
            androidMaxInterstitialAdClick, r.androidMaxInterstitialAdClick);
        settings.put(androidAppOpenAd, r.androidAppOpenAd);
        settings.put(iosExplorerAd, r.iosExplorerAd);
        settings.put(iosInterstitialAd, r.iosInterstitialAd);
        settings.put(iosMaxInterstitialAdClick, r.iosMaxInterstitialAdClick);
        settings.put(iosAppOpenAd, r.iosAppOpenAd);
        settings.put(androidExplorerStatus, r.androidExplorerStatus);
        settings.put(androidAppOpenStatus, r.androidAppOpenStatus);
        settings.put(iosExplorerStatus, r.iosExplorerStatus);
        settings.put(androidInterstitialStatus, r.androidInterstitialStatus);
        settings.put(iosInterstitialStatus, r.iosInterstitialStatus);
        settings.put(iosAppOpenStatus, r.iosAppOpenStatus);
      });
    });
  }
}
