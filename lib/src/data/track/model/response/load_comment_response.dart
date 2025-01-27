import 'package:flutter_music_pro/src/data/pagination/pagination_model.dart';
import 'package:flutter_music_pro/src/data/profile/model/profile.dart';

class LoadCommentResponse {
  List<Comment>? data;
  Pagination? pagination;

  LoadCommentResponse({this.data, this.pagination});

  LoadCommentResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Comment>[];
      json['data'].forEach((v) {
        data!.add(Comment.fromJson(v));
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

class Comment {
  int? id;
  int? tid;
  String? message;
  String? time;
  bool? action;
  Profile? user;

  Comment({this.id, this.tid, this.message, this.time, this.action, this.user});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tid = json['tid'];
    message = json['message'];
    time = json['time'];
    action = json['action'];
    user = json['user'] != null ? Profile.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tid'] = tid;
    data['message'] = message;
    data['time'] = time;
    data['action'] = action;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}