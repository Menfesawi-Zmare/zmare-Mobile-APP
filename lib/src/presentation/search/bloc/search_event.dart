part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class FetchSongSearchEvent extends SearchEvent {
  final String query;
  final int page;

  const FetchSongSearchEvent(this.query, this.page);
}

class FetchAlbumSearchEvent extends SearchEvent {
  final String query;
  final int page;

  const FetchAlbumSearchEvent(this.query, this.page);
}

class FetchArtistSearchEvent extends SearchEvent {
  final String query;
  final int page;

  const FetchArtistSearchEvent(this.query, this.page);
}

class FetchPlaylistSearchEvent extends SearchEvent {
  final String query;
  final int page;

  const FetchPlaylistSearchEvent(this.query, this.page);
}

class FetchProfileSearchEvent extends SearchEvent {
  final String query;
  final int page;

  const FetchProfileSearchEvent(this.query, this.page);
}

class FetchSearchSuggestionEvent extends SearchEvent {
  final String query;

  const FetchSearchSuggestionEvent(this.query);
}

class FetchAllSearchEvent extends SearchEvent {
  final String query;
  final int page;

  const FetchAllSearchEvent(this.query, this.page);
}
