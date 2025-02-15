import 'package:zmare/src/data/artist/model/artist.dart';
import 'package:zmare/src/data/pagination/pagination_model.dart';

class ArtistList {
  List<Artist>? artistList;
  Pagination? pagination;

  ArtistList({this.artistList, this.pagination});

  ArtistList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      artistList = <Artist>[];
      json['data'].forEach((v) {
        artistList!.add(Artist.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (artistList != null) {
      data['data'] = artistList!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}
