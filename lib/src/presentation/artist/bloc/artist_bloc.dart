// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zmare/src/core/error/error.dart';
import 'package:zmare/src/data/album/model/album_list.dart';
import 'package:zmare/src/data/artist/model/artist_detail.dart';
import 'package:zmare/src/data/artist/model/artist_list.dart';
import 'package:zmare/src/data/artist/model/artist_song_list.dart';
import 'package:zmare/src/data/profile/model/profile_list.dart';
import 'package:zmare/src/domain/artist/repository/artist_repository.dart';

part 'artist_event.dart';
part 'artist_state.dart';

class ArtistBloc extends Bloc<ArtistEvent, ArtistState> {
  final IArtistRepository iArtistRepository;
  ArtistBloc({required this.iArtistRepository}) : super(ArtistInitial()) {
    on<ArtistEvent>((event, emit) {});
    on<GetArtistAlbumEvent>(_loadArtistAlbums);
    on<GetArtistTrackListsEvent>(_loadArtistTracks);
    on<GetArtistAllTrackListsEvent>(_loadArtistAllTracks);
    on<GetArtistDetailEvent>(_loadArtistDetail);
    on<GetAllArtistEvent>(_loadAllArtist);
    on<GetArtistSubscribers>(_loadArtistSubsribers);
  }

  void _loadArtistSubsribers(
      GetArtistSubscribers event, Emitter<ArtistState> emit) async {
    emit(ArtistLoading());
    final data =
        await iArtistRepository.getSubscribers(event.profileId, event.page);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(ArtistFailed(l.message ?? ""));
      }
      if (l is NoDataFailure) {
        emit(NoData());
      }
    }, (r) {
      emit(ProfileLoaded(r));
    });
  }

  void _loadArtistAlbums(
      GetArtistAlbumEvent event, Emitter<ArtistState> emit) async {
    emit(ArtistLoading());
    final data = await iArtistRepository.getArtistAlbums(
        event.artistId, event.page, event.filter);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(ArtistFailed(l.message ?? ""));
      }
    }, (r) {
      emit(ArtistAlbumsLoaded(r));
    });
  }

  //Load with Pagination
  void _loadArtistTracks(
      GetArtistTrackListsEvent event, Emitter<ArtistState> emit) async {
    emit(ArtistLoading());
    final data =
        await iArtistRepository.getArtistTracks(event.artistId, event.filter);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(ArtistFailed(l.message ?? ""));
      }
    }, (r) {
      emit(ArtistTrackLoaded(r));
    });
  }

  //Load All Tracks
  void _loadArtistAllTracks(
      GetArtistAllTrackListsEvent event, Emitter<ArtistState> emit) async {
    emit(ArtistLoading());
    final data = await iArtistRepository.getArtistAllTracks(
        event.artistId, event.filter);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(ArtistFailed(l.message ?? ""));
      }
    }, (r) {
      emit(ArtistTrackLoaded(r));
    });
  }

  void _loadArtistDetail(
      GetArtistDetailEvent event, Emitter<ArtistState> emit) async {
    emit(ArtistLoading());
    final data = await iArtistRepository.getArtistDetail(event.artistId);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(ArtistFailed(l.message ?? ""));
      }
    }, (r) {
      emit(ArtistDetailLoaded(r));
    });
  }

  void _loadAllArtist(
      GetAllArtistEvent event, Emitter<ArtistState> emit) async {
    emit(ArtistLoading());
    final data = await iArtistRepository.getAllArtist(event.page, event.filter);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(ArtistFailed(l.message ?? ""));
      }
    }, (r) {
      emit(ArtistLoaded(r));
    });
  }
}
