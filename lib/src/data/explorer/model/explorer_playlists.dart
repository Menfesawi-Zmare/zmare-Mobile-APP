class ExplorerPlaylist {
  int? status;
  int? page;
  int? perPage;
  int? totalPages;
  List<DiscoverPlaylist>? playlist;

  ExplorerPlaylist(
      {this.status, this.page, this.perPage, this.totalPages, this.playlist});

  ExplorerPlaylist.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    page = json['page'];
    perPage = json['per_page'];
    totalPages = json['total_pages'];
    if (json['playlist'] != null) {
      playlist = <DiscoverPlaylist>[];
      json['playlist'].forEach((v) {
        playlist!.add(DiscoverPlaylist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['page'] = page;
    data['per_page'] = perPage;
    data['total_pages'] = totalPages;
    if (playlist != null) {
      data['playlist'] = playlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DiscoverPlaylist {
  int? id;
  int? type;
  String? name;
  String? image;
  int? option;
  DiscoverPlaylist({this.id, this.type, this.name, this.option, this.image});

  DiscoverPlaylist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    option = json['option'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['name'] = name;
    data['option'] = option;
    data['image'] = image;
    return data;
  }
}