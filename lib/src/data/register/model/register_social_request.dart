class RegisterSocialRequest {
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? type;
  String? image;

  RegisterSocialRequest(
      {this.firstName,
      this.lastName,
      this.username,
      this.email,
      this.type,
      this.image});

  RegisterSocialRequest.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    email = json['email'];
    type = json['type'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['username'] = username;
    data['email'] = email;
    data['type'] = type;
    data['image'] = image;
    return data;
  }
}
