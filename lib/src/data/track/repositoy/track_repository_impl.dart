import 'package:dartz/dartz.dart';
import 'package:flutter_music_pro/src/core/error/error.dart';
import 'package:flutter_music_pro/src/data/track/model/response/comment_response.dart';
import 'package:flutter_music_pro/src/data/track/model/response/load_comment_response.dart';
import 'package:flutter_music_pro/src/data/track/model/track_list_model.dart';
import 'package:flutter_music_pro/src/data/track/data_sources/track_data_source.dart';
import 'package:flutter_music_pro/src/data/track/model/track_report_request.model.dart';
import 'package:flutter_music_pro/src/domain/track/repository/track_repository.dart';

class TrackRepositoryImpl extends ITrackRepository {
  TrackRepositoryImpl({required this.iTrackDataSource});
  final ITrackDataSource iTrackDataSource;

  @override
  Future<Either<Failure,TrackList>> getTrack(int page, String type) async {
    final response = await iTrackDataSource.getTrack(page, type);
    return response.fold(
      (failure) => Left(failure),
      (tracksResponse) {
        if(tracksResponse.songList?.isEmpty ?? true){
          return Left(NoDataFailure());
        }
        return Right(tracksResponse);
      },
    );
  }
  
  @override
  Future<Either<Failure, TrackList>> getStreamTrack(int page, int artistId) async{
    final response = await iTrackDataSource.getStreamTrack(page, artistId);
    return response.fold(
      (failure) => Left(failure),
      (tracksResponse) {
        if(tracksResponse.songList?.isEmpty ?? true){
          return Left(NoDataFailure());
        }
        return Right(tracksResponse);
      },
    );
  }
  
  @override
  Future<Either<Failure, TrackList>> getArtistTracks(int uid, int page) async{
    final response = await iTrackDataSource.getArtistTracks(uid, page);
    return response.fold(
      (failure) => Left(failure),
      (tracksResponse) {
        if(tracksResponse.songList?.isEmpty ?? true){
          return Left(NoDataFailure());
        }
        return Right(tracksResponse);
      },
    );
  }

  @override
  Future<Either<Failure, CommentResponse>> addTrackComment(int trackId, String comment) async{
    final response = await iTrackDataSource.addTrackComment(trackId, comment);
    return response.fold(
      (failure) => Left(failure),
      (comment) {
        return Right(comment);
      },
    );
  }

  @override
  Future<Either<Failure, LoadCommentResponse>> loadTrackComment(int trackId, int page) async{
    final response = await iTrackDataSource.loadTrackComment(trackId, page);
    return response.fold(
      (failure) => Left(failure),
      (comment) {
        return Right(comment);
      },
    );
  }
  
  @override
  Future<Either<Failure, bool>> deleteTrackComment(int commentId) async{
    final response = await iTrackDataSource.deleteTrackComment(commentId);
    return response.fold(
      (failure) => Left(failure),
      (comment) {
        return Right(comment);
      },
    );
  }
  
  @override
  Future<Either<Failure, CommentResponse>> editTrackComment(int commentId, String comment) async{
    final response = await iTrackDataSource.editTrackComment(commentId,comment);
    return response.fold(
      (failure) => Left(failure),
      (comment) {
        return Right(comment);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> trackReport(TrackReportRequestModel trackReportRequestModel, int trackId) async{
    final response = await iTrackDataSource.trackReport(trackReportRequestModel,trackId);
    return response.fold(
      (failure) => Left(failure),
      (report) {
        return Right(report);
      },
    );
  }
}
