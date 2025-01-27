class PlaylistUpdateRequestModel {
  String? name;
  String? description;
  int? playlistId;
  int? public;
  PlaylistUpdateRequestModel({this.name, this.description, this.playlistId, this.public});

  PlaylistUpdateRequestModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    playlistId = json['id'];
    public = json['public'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['id'] = playlistId;
    data['public'] = public;
    return data;
  }
}