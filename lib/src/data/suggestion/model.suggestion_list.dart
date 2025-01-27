class SuggestionList {
  int? status;
  List<String>? suggestions;

  SuggestionList({this.status, this.suggestions});

  SuggestionList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    suggestions = json['suggestions'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['suggestions'] = suggestions;
    return data;
  }
}