import 'package:dartz/dartz.dart';
import 'package:zmare/src/core/api/api.dart';
import 'package:zmare/src/core/error/error.dart';
import 'package:zmare/src/data/track/model/track_list_model.dart';

abstract class IPlaylistDataSource {
  Future<Either<Failure, TrackList>> getPlaylistTracks(int playlistId);
}

class PlaylistDataSource extends IPlaylistDataSource {
  PlaylistDataSource(this._client);
  final DioClient _client;

  @override
  Future<Either<Failure, TrackList>> getPlaylistTracks(int playlistId) async {
    final response = await _client.getRequest(
      '${ListAPI.playlistTracks}$playlistId',
      converter: (response) =>
          TrackList.fromJson(response as Map<String, dynamic>),
    );
    return response;
  }
}
