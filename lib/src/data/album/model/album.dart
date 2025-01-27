class Album {
  int? id;
  String? name;
  String? image;
  int? trackTotal;

  Album({this.id, this.name, this.image, this.trackTotal});

  Album.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    trackTotal = json['track_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['track_total'] = trackTotal;
    return data;
  }
}