import 'package:flutter_music_pro/src/data/pagination/pagination_model.dart';
import 'package:flutter_music_pro/src/data/playlist/model/playlist.dart';

class PlaylistList {
  List<Playlist>? playlist;
  Pagination? pagination;

  PlaylistList({this.playlist, this.pagination});

  PlaylistList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      playlist = <Playlist>[];
      json['data'].forEach((v) {
        playlist!.add(Playlist.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (playlist != null) {
      data['data'] = playlist!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}