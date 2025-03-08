// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zmare/src/core/error/error.dart';
import 'package:zmare/src/data/album/model/album_list.dart';
import 'package:zmare/src/data/artist/model/artist_list.dart';
import 'package:zmare/src/data/playlist/model/playlist_list.dart';
import 'package:zmare/src/data/profile/model/profile_list.dart';
import 'package:zmare/src/data/suggestion/model.suggestion_list.dart';
import 'package:zmare/src/data/track/model/track_list_model.dart';
import 'package:zmare/src/domain/search/repository/search_repository.dart';

import '../../../data/pagination/pagination_model.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ISearchRepository iSearchRepository;
  SearchBloc({required this.iSearchRepository}) : super(SearchInitial()) {
    on<SearchEvent>((event, emit) {});
    on<FetchSongSearchEvent>(_loadSearchSong);
    on<FetchAlbumSearchEvent>(_loadSearchAlbum);
    on<FetchArtistSearchEvent>(_loadSearchArtist);
    on<FetchPlaylistSearchEvent>(_loadSearchPlaylist);
    on<FetchProfileSearchEvent>(_loadSearchProfile);
    on<FetchSearchSuggestionEvent>(_loadSearchSuggestion);
    on<FetchAllSearchEvent>(_loadSearchAll);
  }

  void _loadSearchSong(
      FetchSongSearchEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    final data =
        await iSearchRepository.fetchSongSearchResults(event.query, event.page);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(SearchFailed(l.message ?? ""));
      }
    }, (r) {
      emit(SearchTracks(r));
    });
  }

  void _loadSearchAlbum(
      FetchAlbumSearchEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    final data = await iSearchRepository.fetchAlbumSearchResults(
        event.query, event.page);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(SearchFailed(l.message ?? ""));
      }
    }, (r) {
      emit(SearchAlbumsLoaded(r));
    });
  }

  void _loadSearchArtist(
      FetchArtistSearchEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    final data = await iSearchRepository.fetchArtistSearchResults(
        event.query, event.page);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(SearchFailed(l.message ?? ""));
      }
    }, (r) {
      emit(SearchArtists(r));
    });
  }

  void _loadSearchPlaylist(
      FetchPlaylistSearchEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    final data = await iSearchRepository.fetchPlaylistSearchResults(
        event.query, event.page);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(SearchFailed(l.message ?? ""));
      }
    }, (r) {
      emit(SearchPlaylists(r));
    });
  }

  void _loadSearchProfile(
      FetchProfileSearchEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    final data = await iSearchRepository.fetchProfileSearchResults(
        event.query, event.page);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(SearchFailed(l.message ?? ""));
      }
    }, (r) {
      emit(SearchProfile(r));
    });
  }

  void _loadSearchSuggestion(
      FetchSearchSuggestionEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    final data =
        await iSearchRepository.fetchSearchSuggestionResults(event.query);
    data.fold((l) {
      if (l is ServerFailure) {
        emit(SearchFailed(l.message ?? ""));
      }
    }, (r) {
      emit(SearchSuggestion(r));
    });
  }

  void _loadSearchAll(
      FetchAllSearchEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoading());

    // Fetch all data types concurrently
    final songResult =
        await iSearchRepository.fetchSongSearchResults(event.query, event.page);
    final albumResult = await iSearchRepository.fetchAlbumSearchResults(
        event.query, event.page);
    final artistResult = await iSearchRepository.fetchArtistSearchResults(
        event.query, event.page);
    final playlistResult = await iSearchRepository.fetchPlaylistSearchResults(
        event.query, event.page);
    final profileResult = await iSearchRepository.fetchProfileSearchResults(
        event.query, event.page);

    // Check for failures
    if (songResult.isLeft() ||
        albumResult.isLeft() ||
        artistResult.isLeft() ||
        playlistResult.isLeft() ||
        profileResult.isLeft()) {
      emit(SearchFailed("Failed to fetch some data"));
      return;
    }

    // Extract the data
    final songList = songResult.getOrElse(() => TrackList(
        songList: [], pagination: Pagination(currentPage: 1, perPage: 10)));
    final albumList = albumResult.getOrElse(() => AlbumList(
        albumList: [], pagination: Pagination(currentPage: 1, perPage: 10)));
    final artistList = artistResult.getOrElse(() => ArtistList(
        artistList: [], pagination: Pagination(currentPage: 1, perPage: 10)));
    final playlistList = playlistResult.getOrElse(() => PlaylistList(
        playlist: [], pagination: Pagination(currentPage: 1, perPage: 10)));
    final profileList = profileResult.getOrElse(() => ProfileList(
        profiles: [], pagination: Pagination(currentPage: 1, perPage: 10)));

    // Emit the combined state
    emit(SearchAll(
      songList: songList,
      albumList: albumList,
      artistList: artistList,
      playlistList: playlistList,
      profileList: profileList,
    ));
  }
}
