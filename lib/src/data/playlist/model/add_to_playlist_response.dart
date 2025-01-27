class AddToPlaylistResponse {
  bool? status;
  List<Data>? data;
  String? message;

  AddToPlaylistResponse({this.status, this.data, this.message});

  AddToPlaylistResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  int? id;
  int? by;
  String? name;
  dynamic description;
  int? public;
  String? time;

  Data({this.id, this.by, this.name, this.description, this.public, this.time});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    by = json['by'];
    name = json['name'];
    description = json['description'];
    public = json['public'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['by'] = by;
    data['name'] = name;
    data['description'] = description;
    data['public'] = public;
    data['time'] = time;
    return data;
  }
}