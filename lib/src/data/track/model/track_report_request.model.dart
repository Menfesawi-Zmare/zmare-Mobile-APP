class TrackReportRequestModel {
  int? type;
  int? reason;
  String? description;
  String? signature;

  TrackReportRequestModel({this.type, this.reason, this.description, this.signature});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['reason'] = reason;
    data['description'] = description;
    data['signature'] = signature;
    return data;
  }
}