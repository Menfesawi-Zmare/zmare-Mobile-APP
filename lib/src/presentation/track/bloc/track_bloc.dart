// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zmare/src/core/error/error.dart';
import 'package:zmare/src/data/track/model/response/comment_response.dart';
import 'package:zmare/src/data/track/model/response/load_comment_response.dart';
import 'package:zmare/src/data/track/model/track_list_model.dart';
import 'package:zmare/src/data/track/model/track_report_request.model.dart';
import 'package:zmare/src/domain/track/repository/track_repository.dart';

part 'track_event.dart';
part 'track_state.dart';

class TrackBloc extends Bloc<TrackEvent, TrackState> {
  final ITrackRepository? iTrackRepository;
  TrackBloc({this.iTrackRepository}) : super(TrackInitial()) {
    on<TrackFetch>(_loadTracks);
    on<StreamFetch>(_loadStream);
    on<GetArtistTrackListsEvent>(_loadArtistTracks);
    on<LoadTrackCommentEvent>(_loadTrackComments);
    on<AddTrackCommentEvent>(_addTrackComments);
    on<EditTrackCommentEvent>(_editTrackComments);
    on<DeleteTrackCommentEvent>(_deleteTrackComments);
    on<TrackReportEvent>(_trackReport);
  }

  void _loadTracks(TrackFetch event, Emitter<TrackState> emit) async {
    emit(TrackLoading());
    final data = await iTrackRepository!.getTrack(event.page, event.type);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(const TrackFailedState());
      }
      if (l is NoDataFailure) {
        emit(TrackNoData());
      }
    }, (r) {
      emit(TrackFetchSuccess(r));
    });
  }

  void _loadStream(StreamFetch event, Emitter<TrackState> emit) async {
    emit(TrackLoading());
    final data =
        await iTrackRepository!.getStreamTrack(event.page, event.artistId);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(const TrackFailedState());
      }
      if (l is NoDataFailure) {
        emit(TrackNoData());
      }
    }, (r) {
      emit(TrackFetchSuccess(r));
    });
  }

  void _loadArtistTracks(
      GetArtistTrackListsEvent event, Emitter<TrackState> emit) async {
    emit(TrackLoading());
    final data =
        await iTrackRepository!.getArtistTracks(event.artistId, event.page);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(const TrackFailedState());
      }
    }, (r) {
      emit(TrackFetchSuccess(r));
    });
  }

  void _loadTrackComments(
      LoadTrackCommentEvent event, Emitter<TrackState> emit) async {
    emit(TrackLoading());
    final data =
        await iTrackRepository!.loadTrackComment(event.trackId, event.page);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(const TrackFailedState());
      }
    }, (r) {
      emit(LoadTrackCommentState(r));
    });
  }

  void _addTrackComments(
      AddTrackCommentEvent event, Emitter<TrackState> emit) async {
    emit(TrackLoading());
    final data =
        await iTrackRepository!.addTrackComment(event.trackId, event.comment);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(const TrackFailedState());
      }
    }, (r) {
      emit(AddTrackCommentState(r));
    });
  }

  void _editTrackComments(
      EditTrackCommentEvent event, Emitter<TrackState> emit) async {
    emit(TrackLoading());
    final data = await iTrackRepository!
        .editTrackComment(event.commentId, event.comment);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(const TrackFailedState());
      }
    }, (r) {
      emit(EditTrackCommentState(r));
    });
  }

  void _deleteTrackComments(
      DeleteTrackCommentEvent event, Emitter<TrackState> emit) async {
    emit(TrackLoading());
    final data = await iTrackRepository!.deleteTrackComment(event.commentId);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(const TrackFailedState());
      }
    }, (r) {
      emit(DeleteTrackCommentState(r));
    });
  }

  void _trackReport(TrackReportEvent event, Emitter<TrackState> emit) async {
    emit(TrackLoading());
    final data = await iTrackRepository!
        .trackReport(event.trackReportRequestModel, event.trackId);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(TrackReportFaildState(l.message!));
      }
    }, (r) {
      emit(TrackReportState(r));
    });
  }
}
