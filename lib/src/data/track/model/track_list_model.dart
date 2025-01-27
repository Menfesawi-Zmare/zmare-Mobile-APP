import 'package:flutter_music_pro/src/data/pagination/pagination_model.dart';
import 'package:flutter_music_pro/src/data/song/model/item_song_model.dart';

class TrackList {
  List<ItemSongModel>? songList;
  Pagination? pagination;

  TrackList({this.songList, this.pagination});

  TrackList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      songList = <ItemSongModel>[];
      json['data'].forEach((v) {
        songList!.add(ItemSongModel.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (songList != null) {
      data['data'] = songList!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}