class Account {
  int? status;
  ProfileData? profileData;

  Account({this.status, this.profileData});

  Account.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    profileData =
        json['profile'] != null ? ProfileData.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (profileData != null) {
      data['profile'] = profileData!.toJson();
    }
    return data;
  }
}

class ProfileData {
  String? idu;
  String? username;
  String? password;
  String? email;
  String? firstName;
  String? lastName;
  String? country;
  String? city;
  String? website;
  String? description;
  String? date;
  String? facebook;
  String? gplus;
  String? twitter;
  String? instagram;
  String? youtube;
  String? vimeo;
  String? tumblr;
  String? soundcloud;
  String? myspace;
  String? lastfm;
  String? image;
  String? private;
  String? suspended;
  String? salted;
  String? loginToken;
  String? authId;
  String? cover;
  String? gender;
  String? online;
  String? offline;
  String? ip;
  String? notificationl;
  String? notificationc;
  String? notificationd;
  String? notificationf;
  String? emailComment;
  String? emailLike;
  String? emailNewFriend;
  String? emailNewsletter;
  String? nameKhmer;
  String? artistType;

  ProfileData(
      {this.idu,
      this.username,
      this.password,
      this.email,
      this.firstName,
      this.lastName,
      this.country,
      this.city,
      this.website,
      this.description,
      this.date,
      this.facebook,
      this.gplus,
      this.twitter,
      this.instagram,
      this.youtube,
      this.vimeo,
      this.tumblr,
      this.soundcloud,
      this.myspace,
      this.lastfm,
      this.image,
      this.private,
      this.suspended,
      this.salted,
      this.loginToken,
      this.authId,
      this.cover,
      this.gender,
      this.online,
      this.offline,
      this.ip,
      this.notificationl,
      this.notificationc,
      this.notificationd,
      this.notificationf,
      this.emailComment,
      this.emailLike,
      this.emailNewFriend,
      this.emailNewsletter,
      this.nameKhmer,
      this.artistType});

  ProfileData.fromJson(Map<String, dynamic> json) {
    idu = json['idu'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    country = json['country'];
    city = json['city'];
    website = json['website'];
    description = json['description'];
    date = json['date'];
    facebook = json['facebook'];
    gplus = json['gplus'];
    twitter = json['twitter'];
    instagram = json['instagram'];
    youtube = json['youtube'];
    vimeo = json['vimeo'];
    tumblr = json['tumblr'];
    soundcloud = json['soundcloud'];
    myspace = json['myspace'];
    lastfm = json['lastfm'];
    image = json['image'];
    private = json['private'];
    suspended = json['suspended'];
    salted = json['salted'];
    loginToken = json['login_token'];
    authId = json['auth_id'];
    cover = json['cover'];
    gender = json['gender'];
    online = json['online'];
    offline = json['offline'];
    ip = json['ip'];
    notificationl = json['notificationl'];
    notificationc = json['notificationc'];
    notificationd = json['notificationd'];
    notificationf = json['notificationf'];
    emailComment = json['email_comment'];
    emailLike = json['email_like'];
    emailNewFriend = json['email_new_friend'];
    emailNewsletter = json['email_newsletter'];
    nameKhmer = json['name_khmer'];
    artistType = json['artist_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idu'] = idu;
    data['username'] = username;
    data['password'] = password;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['country'] = country;
    data['city'] = city;
    data['website'] = website;
    data['description'] = description;
    data['date'] = date;
    data['facebook'] = facebook;
    data['gplus'] = gplus;
    data['twitter'] = twitter;
    data['instagram'] = instagram;
    data['youtube'] = youtube;
    data['vimeo'] = vimeo;
    data['tumblr'] = tumblr;
    data['soundcloud'] = soundcloud;
    data['myspace'] = myspace;
    data['lastfm'] = lastfm;
    data['image'] = image;
    data['private'] = private;
    data['suspended'] = suspended;
    data['salted'] = salted;
    data['login_token'] = loginToken;
    data['auth_id'] = authId;
    data['cover'] = cover;
    data['gender'] = gender;
    data['online'] = online;
    data['offline'] = offline;
    data['ip'] = ip;
    data['notificationl'] = notificationl;
    data['notificationc'] = notificationc;
    data['notificationd'] = notificationd;
    data['notificationf'] = notificationf;
    data['email_comment'] = emailComment;
    data['email_like'] = emailLike;
    data['email_new_friend'] = emailNewFriend;
    data['email_newsletter'] = emailNewsletter;
    data['name_khmer'] = nameKhmer;
    data['artist_type'] = artistType;
    return data..removeWhere((key, value) => value == null);
  }
}
