class CreatePlaylistModel {
  String? name;
  int? public;
  String? trackIdList;

  CreatePlaylistModel({this.name, this.public, this.trackIdList});

  CreatePlaylistModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    public = json['public'];
    trackIdList = json['trackIdList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['public'] = public;
    data['trackIdList'] = trackIdList;
    return data;
  }
}