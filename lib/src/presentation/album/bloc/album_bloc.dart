// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_music_pro/src/core/error/error.dart';
import 'package:flutter_music_pro/src/data/album/model/album_list.dart';
import 'package:flutter_music_pro/src/data/album/model/album_track_list.dart';
import 'package:flutter_music_pro/src/domain/album/repository/album_repository.dart';

part 'album_event.dart';
part 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final IAlbumRepository iAlbumRepository;
  AlbumBloc({required this.iAlbumRepository}) : super(AlbumInitial()) {
    on<AlbumEvent>((event, emit) {});
    on<GetAlbumTrackEvent>(_loadAlbumSongs);
    on<GetProductionAlbumsEvent>(_loadProductionAlbums);
    on<GetArtistAlbumsEvent>(_loadArtistAlbums);
    on<GetAllAlbumEvent>(_loadAllAlbum);
  }

  void _loadAlbumSongs(
      GetAlbumTrackEvent event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    final data = await iAlbumRepository.getAlbumTrackList(event.albumId);
      data.fold(
      (l) {
        if (l is ServerFailure) {
          emit(AlbumLoadFailed(l.message ?? ""));
        }
      },
      (r) {
        emit(AlbumLoaded(r));
      });
  }

  void _loadProductionAlbums(
      GetProductionAlbumsEvent event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    final data = await iAlbumRepository.getProductionAlbums(event.pId, event.page);
      data.fold(
      (l) {
        if (l is ServerFailure) {
          emit(AlbumLoadFailed(l.message ?? ""));
        }
      },
      (r) {
        emit(ProductionAlbumsLoaded(r));
      });
  }
   void _loadArtistAlbums(
      GetArtistAlbumsEvent event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    final data = await iAlbumRepository.getArtistAlbums(event.artistId,event.page);
      data.fold(
      (l) {
        if (l is ServerFailure) {
          emit(AlbumLoadFailed(l.message ?? ""));
        }
      },
      (r) {
        emit(ArtistAlbum(r));
      });
  }
  void _loadAllAlbum(
      GetAllAlbumEvent event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    final data = await iAlbumRepository.getAllAlbum(event.page);
      data.fold(
      (l) {
        if (l is ServerFailure) {
          emit(AlbumLoadFailed(l.message ?? ""));
        }
      },
      (r) {
        emit(AllAlbum(r));
      });
  }
}
