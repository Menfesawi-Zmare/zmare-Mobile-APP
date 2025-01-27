class Playlist {
  int? id;
  String? name;
  int? ownerId;
  String? ownerName;
  String? description;
  String? time;
  int? public;
  String? url;
  int? trackTotal;
  String? image;
  bool? active;

  Playlist(
      {this.id,
      this.name,
      this.ownerId,
      this.ownerName,
      this.description,
      this.time,
      this.public,
      this.url,
      this.trackTotal,
      this.image,
      this.active});

  Playlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    ownerId = json['ownerId'];
    ownerName = json['ownerName'];
    description = json['description'] ?? "";
    time = json['time'];
    public = json['public'];
    url = json['url'];
    trackTotal = json['track_total'];
    image = json['image'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['ownerId'] = ownerId;
    data['ownerName'] = ownerName;
    data['description'] = description;
    data['time'] = time;
    data['public'] = public;
    data['url'] = url;
    data['track_total'] = trackTotal;
    data['image'] = image;
    data['active'] = active;
    return data;
  }
}