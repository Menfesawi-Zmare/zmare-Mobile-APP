import 'package:zmare/src/data/artist/model/artist.dart';
import 'package:zmare/src/data/pagination/pagination_model.dart';
import 'package:zmare/src/data/profile/model/profile.dart';

class FollowResponseModel {
  List<Follow>? data;
  Pagination? pagination;

  FollowResponseModel({this.data, this.pagination});

  FollowResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Follow>[];
      json['data'].forEach((v) {
        data!.add(Follow.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class Follow {
  Profile? user;
  Artist? artist;

  Follow({this.user, this.artist});

  Follow.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? Profile.fromJson(json['user']) : null;
    artist = json['artist'] != null ? Artist.fromJson(json['artist']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (artist != null) {
      data['artist'] = artist!.toJson();
    }
    return data;
  }
}
