class Artist {
  int? id;
  String? name;
  String? country;
  String? city;
  String? image;
  String? description;
  String? website;
  String? date;
  String? facebook;
  String? twitter;
  String? instagram;
  String? youtube;
  int? trackTotal;
  int? albumTotal;
  int? listener;
  int? subscribers;

  Artist(
      {this.id,
      this.name,
      this.country,
      this.city,
      this.image,
      this.description,
      this.website,
      this.date,
      this.facebook,
      this.twitter,
      this.instagram,
      this.youtube,
      this.trackTotal,
      this.albumTotal,
      this.listener,
      this.subscribers});

  Artist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    country = json['country'];
    city = json['city'];
    image = json['image'];
    description = json['description'];
    website = json['website'];
    date = json['date'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    instagram = json['instagram'];
    youtube = json['youtube'];
    trackTotal = json['track_total'];
    albumTotal = json['album_total'];
    listener = json['listener'];
    subscribers = json['subscribers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['country'] = country;
    data['city'] = city;
    data['image'] = image;
    data['description'] = description;
    data['website'] = website;
    data['date'] = date;
    data['facebook'] = facebook;
    data['twitter'] = twitter;
    data['instagram'] = instagram;
    data['youtube'] = youtube;
    data['track_total'] = trackTotal;
    data['album_total'] = albumTotal;
    data['listener'] = listener;
    data['subscribers'] = subscribers;
    return data;
  }
}