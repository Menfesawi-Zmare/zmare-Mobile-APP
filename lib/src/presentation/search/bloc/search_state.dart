part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchTracks extends SearchState {
  final TrackList trackList;

  const SearchTracks(this.trackList);
}

class SearchAlbumsLoaded extends SearchState {
  final AlbumList allAlbums;

  const SearchAlbumsLoaded(this.allAlbums);
}

class SearchFailed extends SearchState {
  final String message;

  const SearchFailed(this.message);
}

class SearchArtists extends SearchState {
  final ArtistList artistList;
  const SearchArtists(this.artistList);
}

class SearchPlaylists extends SearchState {
  final PlaylistList playlistList;
  const SearchPlaylists(this.playlistList);
}

class SearchProfile extends SearchState {
  final ProfileList profileList;
  const SearchProfile(this.profileList);
}

class SearchAll extends SearchState {
  final TrackList songList;
  final ArtistList artistList;
  final AlbumList albumList;
  final PlaylistList playlistList;
  final ProfileList profileList;
  final Pagination? pagination;

  SearchAll({
    required this.songList,
    required this.artistList,
    required this.albumList,
    required this.playlistList,
    required this.profileList,
    this.pagination,
  });
}

class SearchSuggestion extends SearchState {
  final SuggestionList suggestionList;

  const SearchSuggestion(this.suggestionList);
}
