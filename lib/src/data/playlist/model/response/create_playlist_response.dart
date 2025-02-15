import 'package:zmare/src/data/playlist/model/playlist.dart';

class CreatePlaylistResponse {
  bool? status;
  Playlist? data;
  String? message;

  CreatePlaylistResponse({this.status, this.data, this.message});

  CreatePlaylistResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Playlist.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}
