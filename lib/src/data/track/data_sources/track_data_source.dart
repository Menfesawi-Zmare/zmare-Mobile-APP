import 'package:dartz/dartz.dart';
import 'package:zmare/src/core/api/api.dart';
import 'package:zmare/src/core/error/error.dart';
import 'package:zmare/src/data/track/model/response/comment_response.dart';
import 'package:zmare/src/data/track/model/response/load_comment_response.dart';
import 'package:zmare/src/data/track/model/track_list_model.dart';
import 'package:zmare/src/data/track/model/track_report_request.model.dart';

abstract class ITrackDataSource {
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

class TrackDataSource extends ITrackDataSource {
  TrackDataSource(this._client);
  final DioClient _client;

  @override
  Future<Either<Failure, TrackList>> getTrack(int page, String type) async {
    final response = await _client.getRequest(
      ListAPI.homePageTracks + type,
      queryParameters: {'page': page},
      converter: (response) => TrackList.fromJson(response),
    );

    return response;
  }

  @override
  Future<Either<Failure, TrackList>> getStreamTrack(
      int page, int artistId) async {
    final response = await _client.getRequest(
      ListAPI.streamTracks,
      queryParameters: {'page': page, 'filter': artistId},
      converter: (response) => TrackList.fromJson(response),
    );

    return response;
  }

  @override
  Future<Either<Failure, TrackList>> getArtistTracks(int uid, int page) async {
    final response = await _client.getRequest(
      '${ListAPI.artistTracks}$uid',
      queryParameters: {'page': page},
      converter: (response) =>
          TrackList.fromJson(response as Map<String, dynamic>),
    );
    return response;
  }

  @override
  Future<Either<Failure, CommentResponse>> addTrackComment(
      int trackId, String comment) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comment'] = comment;
    final response = await _client.postRequest(
      '${ListAPI.addComment}$trackId',
      data: data,
      converter: (response) => CommentResponse.fromJson(response),
    );
    return response;
  }

  @override
  Future<Either<Failure, CommentResponse>> editTrackComment(
      int commentId, String comment) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comment'] = comment;
    final response = await _client.postRequest(
      '${ListAPI.editComment}$commentId',
      data: data,
      converter: (response) => CommentResponse.fromJson(response),
    );
    return response;
  }

  @override
  Future<Either<Failure, bool>> deleteTrackComment(int commentId) async {
    final response = await _client.deleteRequest(
        '${ListAPI.deleteComment}$commentId',
        converter: (response) => response['status'] as bool);
    return response;
  }

  @override
  Future<Either<Failure, LoadCommentResponse>> loadTrackComment(
      int trackId, int page) async {
    final response = await _client.getRequest(
      '${ListAPI.loadComment}$trackId',
      queryParameters: {'page': page},
      converter: (response) => LoadCommentResponse.fromJson(response),
    );
    return response;
  }

  @override
  Future<Either<Failure, bool>> trackReport(
      TrackReportRequestModel trackReportRequestModel, int trackId) async {
    final response = await _client.postRequest('${ListAPI.report}$trackId',
        data: trackReportRequestModel.toJson(),
        converter: (response) => response['status'] as bool);
    return response;
  }
}
