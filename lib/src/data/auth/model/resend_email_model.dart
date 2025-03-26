class ResendEmailModel {
  String? message;

  ResendEmailModel({this.message});

  ResendEmailModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['message'] = message;
    return data;
  }
}

class RequestEmailResponse {
  String? message;

  RequestEmailResponse({this.message});

  RequestEmailResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['message'] = message;
    return data;
  }
}

class OtpVerifyResponse {
  String? message;

  OtpVerifyResponse({this.message});

  OtpVerifyResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['message'] = message;
    return data;
  }
}

class ResetPasswordResponse {
  String? message;

  ResetPasswordResponse({this.message});

  ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['message'] = message;
    return data;
  }
}
