import 'package:dartz/dartz.dart';
import 'package:zmare/src/core/error/error.dart';
import 'package:zmare/src/data/playlist/data_sources/playlist_data_source.dart';
import 'package:zmare/src/data/track/model/track_list_model.dart';
import 'package:zmare/src/domain/playlist/repository/playlist_repository.dart';

class PlaylistRepositoryImpl extends IPlaylistRepository {
  PlaylistRepositoryImpl({required this.iPlaylistDataSource});
  final IPlaylistDataSource iPlaylistDataSource;

  @override
  Future<Either<Failure, TrackList>> getPlaylistTracks(int playlistId) async {
    final response = await iPlaylistDataSource.getPlaylistTracks(playlistId);
    return response.fold(
      (failure) => Left(failure),
      (playlistTracksResponse) {
        if (playlistTracksResponse.songList?.isEmpty ?? true) {
          Left(NoDataFailure());
        }
        return Right(playlistTracksResponse);
      },
    );
  }
}
