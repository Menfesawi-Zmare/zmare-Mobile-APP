import 'package:flutter_music_pro/src/data/song/model/item_song_model.dart';

class ArtistTrackList {
  List<ItemSongModel>? trackList;

  ArtistTrackList({this.trackList});

  ArtistTrackList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      trackList = <ItemSongModel>[];
      json['data'].forEach((v) {
        trackList!.add(ItemSongModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (trackList != null) {
      data['data'] = trackList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}