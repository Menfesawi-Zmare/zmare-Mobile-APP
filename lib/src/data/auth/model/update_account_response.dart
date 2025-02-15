import 'package:zmare/src/data/profile/model/profile.dart';

class UpdateAccountResponse {
  bool? status;
  Profile? data;
  String? message;

  UpdateAccountResponse({this.status, this.data, this.message});

  UpdateAccountResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Profile.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}
