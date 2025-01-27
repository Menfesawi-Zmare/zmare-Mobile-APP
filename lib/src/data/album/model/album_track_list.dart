import 'package:flutter_music_pro/src/data/song/model/item_song_model.dart';

class AlbumTrackListModel {
  List<ItemSongModel>? songList;

  AlbumTrackListModel({this.songList});

  AlbumTrackListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      songList = <ItemSongModel>[];
      json['data'].forEach((v) {
        songList!.add(ItemSongModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (songList != null) {
      data['data'] = songList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}