import 'package:dartz/dartz.dart';
import 'package:zmare/src/core/error/error.dart';
import 'package:zmare/src/data/track/model/response/comment_response.dart';
import 'package:zmare/src/data/track/model/response/load_comment_response.dart';
import 'package:zmare/src/data/track/model/track_list_model.dart';
import 'package:zmare/src/data/track/model/track_report_request.model.dart';

abstract class ITrackRepository {
  Future<Either<Failure, TrackList>> getTrack(int page, String type);
  Future<Either<Failure, TrackList>> getStreamTrack(int page, int artistId);
  Future<Either<Failure, TrackList>> getArtistTracks(int uid, int page);
  Future<Either<Failure, CommentResponse>> addTrackComment(
      int trackId, String comment);
  Future<Either<Failure, LoadCommentResponse>> loadTrackComment(
      int trackId, int page);
  Future<Either<Failure, CommentResponse>> editTrackComment(
      int commentId, String comment);
  Future<Either<Failure, bool>> deleteTrackComment(int commentId);
  Future<Either<Failure, bool>> trackReport(
      TrackReportRequestModel trackReportRequestModel, int trackId);
}
