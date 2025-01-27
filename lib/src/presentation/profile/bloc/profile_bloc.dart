// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_music_pro/src/core/error/error.dart';
import 'package:flutter_music_pro/src/data/follow/model/follow_response_model.dart';
import 'package:flutter_music_pro/src/data/playlist/model/playlist_list.dart';
import 'package:flutter_music_pro/src/data/track/model/track_list_model.dart';
import 'package:flutter_music_pro/src/domain/profile/repository/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IProfileRepository iProfileRepository;
  ProfileBloc({required this.iProfileRepository}) : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) {});
    on<GetProfileSubscriptions>(_loadSubsriptions);
    on<GetProfileSubscribers>(_loadSubscribers);
    on<GetProfileLikes>(_loadLikes);
    on<GetProfilePlaylists>(_loadPlaylists);
  }

  void _loadSubsriptions(
      GetProfileSubscriptions event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final data = await iProfileRepository.getSubscriptions(
        event.profileId, event.page);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(ProfileFailed(l.message ?? ""));
      }
      if (l is NoDataFailure) {
        emit(NoData());
      }
    }, (r) {
      emit(ProfileLoaded(r));
    });
  }

  void _loadSubscribers(
      GetProfileSubscribers event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final data = await iProfileRepository.getSubscribers(
        event.profileId, event.page);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(ProfileFailed(l.message ?? ""));
      }
      if (l is NoDataFailure) {
        emit(NoData());
      }
    }, (r) {
      emit(ProfileLoaded(r));
    });
  }

  void _loadLikes(GetProfileLikes event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final data = await iProfileRepository.getLikes(event.profileId, event.page);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(ProfileFailed(l.message ?? "No Data"));
      }
      if (l is NoDataFailure) {
        emit(NoData());
      }
    }, (r) {
      emit(ProfileLikes(r));
    });
  }

  void _loadPlaylists(
      GetProfilePlaylists event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final data = await iProfileRepository.getPlaylists(
        event.profileId, event.page);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(ProfileFailed(l.message ?? "No Data"));
      }
      if (l is NoDataFailure) {
        emit(NoData());
      }
    }, (r) {
      emit(ProfilePlaylists(r));
    });
  }
}
