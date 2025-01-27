part of 'track_bloc.dart';

abstract class TrackState extends Equatable {
  const TrackState();

  @override
  List<Object> get props => [];
}

class TrackInitial extends TrackState {}

class TrackFetchSuccess extends TrackState {
  final TrackList trackListModel;
  const TrackFetchSuccess(this.trackListModel);
}

class AddTrackCommentState extends TrackState {
  final CommentResponse commentResponse;
  const AddTrackCommentState(this.commentResponse);
}

class EditTrackCommentState extends TrackState {
  final CommentResponse commentResponse;
  const EditTrackCommentState(this.commentResponse);
}

class DeleteTrackCommentState extends TrackState {
  final bool result;
  const DeleteTrackCommentState(this.result);
}

class LoadTrackCommentState extends TrackState {
  final LoadCommentResponse loadCommentResponse;
  const LoadTrackCommentState(this.loadCommentResponse);
}

class TrackFailedState extends TrackState {
  const TrackFailedState();
}

class TrackLoading extends TrackState {}
class TrackNoData extends TrackState {}

class TrackReportState extends TrackState {
  final bool result;
  const TrackReportState(this.result);
}

class TrackReportFaildState extends TrackState {
  final String message;
  const TrackReportFaildState(this.message);
}