part of 'track_bloc.dart';

abstract class TrackEvent extends Equatable {
  const TrackEvent();

  @override
  List<Object> get props => [];
}

class TrackFetch extends TrackEvent {
  final int page;
  final String type;
  const TrackFetch(this.page, this.type);
}

class StreamFetch extends TrackEvent {
  final int page;
  final int artistId;

  const StreamFetch(this.page, this.artistId);
}
class LoadTrackCommentEvent extends TrackEvent {
  final int trackId;
  final int page;

  const LoadTrackCommentEvent(this.trackId, this.page);
}
class AddTrackCommentEvent extends TrackEvent {
  final int trackId;
  final String comment;

  const AddTrackCommentEvent(this.trackId, this.comment);
}
class EditTrackCommentEvent extends TrackEvent {
  final int commentId;
  final String comment;

  const EditTrackCommentEvent(this.commentId, this.comment);
}
class DeleteTrackCommentEvent extends TrackEvent {
  final int commentId;

  const DeleteTrackCommentEvent(this.commentId);
}
class GetArtistTrackListsEvent extends TrackEvent {
  final int artistId;
  final int page;
  const GetArtistTrackListsEvent(this.artistId, this.page);
}
class TrackReportEvent extends TrackEvent {
  final TrackReportRequestModel trackReportRequestModel;
  final int trackId;

  const TrackReportEvent(this.trackReportRequestModel, this.trackId);
}
