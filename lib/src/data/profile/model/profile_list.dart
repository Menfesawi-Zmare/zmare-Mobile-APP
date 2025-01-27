import 'package:flutter_music_pro/src/data/pagination/pagination_model.dart';
import 'package:flutter_music_pro/src/data/profile/model/profile.dart';

class ProfileList {
  List<Profile>? profiles;
  Pagination? pagination;

  ProfileList({this.profiles, this.pagination});

  ProfileList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      profiles = <Profile>[];
      json['data'].forEach((v) {
        profiles!.add(Profile.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (profiles != null) {
      data['data'] = profiles!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}