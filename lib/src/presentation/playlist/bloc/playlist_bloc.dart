// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zmare/src/core/error/error.dart';
import 'package:zmare/src/data/track/model/track_list_model.dart';
import 'package:zmare/src/domain/playlist/repository/playlist_repository.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final IPlaylistRepository iPlaylistRepository;
  PlaylistBloc({required this.iPlaylistRepository}) : super(PlaylistInitial()) {
    on<PlaylistEvent>((event, emit) {});
    on<GetPlaylistEvent>(_loadPlaylistTracks);
  }

  void _loadPlaylistTracks(
      GetPlaylistEvent event, Emitter<PlaylistState> emit) async {
    emit(PlaylistLoading());
    final data = await iPlaylistRepository.getPlaylistTracks(event.playlistId);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(PlaylistFailed(l.message ?? ""));
      }
    }, (r) {
      emit(PlaylistLoaded(r));
    });
  }
}
