class PlaylistsRequestModel {
  int? trackId;
  int? playlistId;

  PlaylistsRequestModel({this.trackId, this.playlistId});

  PlaylistsRequestModel.fromJson(Map<String, dynamic> json) {
    trackId = json['tid'];
    playlistId = json['pid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tid'] = trackId;
    data['pid'] = playlistId;
    return data;
  }
}