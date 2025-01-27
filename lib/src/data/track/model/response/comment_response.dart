class CommentResponse {
  bool? status;
  Data? data;
  String? message;

  CommentResponse({this.status, this.data, this.message});

  CommentResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }
}

class Data {
  String? tid;
  int? uid;
  String? message;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.tid,
      this.uid,
      this.message,
      this.updatedAt,
      this.createdAt,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    tid = json['tid'];
    uid = json['uid'];
    message = json['message'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tid'] = tid;
    data['uid'] = uid;
    data['message'] = message;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}