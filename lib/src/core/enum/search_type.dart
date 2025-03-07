import 'package:flutter/material.dart';
import 'package:zmare/src/utils/ext/common.dart';

enum SearchType {
  // all,
  songs,
  artists,
  albums,
  playlists,
  profiles;

  int get toIndex {
    switch (this) {
      // case SearchType.all:
      //   return 0;
      case SearchType.songs:
        return 0;
      case SearchType.artists:
        return 1;
      case SearchType.albums:
        return 2;
      case SearchType.playlists:
        return 3;
      case SearchType.profiles:
        return 4;
    }
  }

  String name(BuildContext context) {
    switch (this) {
      // case SearchType.all:
      //   return context.loc.all;
      case SearchType.songs:
        return context.loc.tracks;
      case SearchType.artists:
        return context.loc.artists;
      case SearchType.albums:
        return context.loc.albums;
      case SearchType.playlists:
        return context.loc.playlists;
      case SearchType.profiles:
        return context.loc.profiles;
    }
  }
}
