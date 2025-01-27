class LikeAndDislike {
  String? trackId;
  int? type;

  LikeAndDislike({this.trackId, this.type});

  LikeAndDislike.fromJson(Map<String, dynamic> json) {
    trackId = json['track_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['track_id'] = trackId;
    data['type'] = type;
    return data;
  }
}
