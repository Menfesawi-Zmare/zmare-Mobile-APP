import 'package:zmare/src/data/album/model/album.dart';
import 'package:zmare/src/data/pagination/pagination_model.dart';

class AlbumList {
  List<Album>? albumList;
  Pagination? pagination;

  AlbumList({this.albumList, this.pagination});

  AlbumList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      albumList = <Album>[];
      json['data'].forEach((v) {
        albumList!.add(Album.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (albumList != null) {
      data['data'] = albumList!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}
