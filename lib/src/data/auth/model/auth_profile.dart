import 'package:flutter_music_pro/src/data/profile/model/profile.dart';

class AuthProfile {
  bool? status;
  Profile? profile;
  String? message;

  AuthProfile({this.status, this.profile, this.message});

  AuthProfile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    profile = json['data'] != null ? Profile.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (profile != null) {
      data['data'] = profile!.toJson();
    }
    data['message'] = message;
    return data;
  }
}