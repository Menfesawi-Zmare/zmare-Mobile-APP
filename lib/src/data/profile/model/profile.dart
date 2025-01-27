class Profile {
  int? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  String? country;
  String? city;
  String? image;
  String? cover;
  String? description;
  String? website;
  String? date;
  String? facebook;
  String? twitter;
  String? instagram;
  String? youtube;
  int? private;
  String? url;

  Profile(
      {this.id,
      this.username,
      this.email,
      this.firstName,
      this.lastName,
      this.country,
      this.city,
      this.image,
      this.cover,
      this.description,
      this.website,
      this.date,
      this.facebook,
      this.twitter,
      this.instagram,
      this.youtube,
      this.private,
      this.url});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    country = json['country'];
    city = json['city'];
    image = json['image'];
    cover = json['cover'];
    description = json['description'];
    website = json['website'];
    date = json['date'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    instagram = json['instagram'];
    youtube = json['youtube'];
    private = json['private'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['country'] = country;
    data['city'] = city;
    data['image'] = image;
    data['cover'] = cover;
    data['description'] = description;
    data['website'] = website;
    data['date'] = date;
    data['facebook'] = facebook;
    data['twitter'] = twitter;
    data['instagram'] = instagram;
    data['youtube'] = youtube;
    data['private'] = private;
    data['url'] = url;
    return data;
  }
}