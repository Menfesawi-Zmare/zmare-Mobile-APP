import 'package:zmare/src/data/album/model/album.dart';
import 'package:zmare/src/data/artist/model/artist.dart';
import 'package:zmare/src/data/playlist/model/playlist.dart';
import 'package:zmare/src/data/production/model/production.dart';
// import 'package:zmare/src/data/song/model/item_song_model.dart';

class ExplorerModel {
  List<Data>? data;

  ExplorerModel({this.data});

  ExplorerModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }
}

class Data {
  int? id;
  String? title;
  String? type;
  List<BannerModel>? carousels;
  List<Artist>? artists;
  List<Playlist>? playlists;
  List<Album>? albums;
  List<Production>? productions;
  Banners? banners;
  Ads? ads;
  Data(
      {this.id,
      this.title,
      this.type,
      this.carousels,
      this.artists,
      this.playlists,
      this.albums,
      this.productions,
      this.banners,
      this.ads});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    if (json['banner_list'] != null) {
      carousels = <BannerModel>[];
      json['banner_list'].forEach((v) {
        carousels!.add(BannerModel.fromJson(v));
      });
    }
    if (json['artists'] != null) {
      artists = <Artist>[];
      json['artists'].forEach((v) {
        artists!.add(Artist.fromJson(v));
      });
    }
    if (json['playlists'] != null) {
      playlists = <Playlist>[];
      json['playlists'].forEach((v) {
        playlists!.add(Playlist.fromJson(v));
      });
    }
    if (json['albums'] != null) {
      albums = <Album>[];
      json['albums'].forEach((v) {
        albums!.add(Album.fromJson(v));
      });
    }
    if (json['productions'] != null) {
      productions = <Production>[];
      json['productions'].forEach((v) {
        productions!.add(Production.fromJson(v));
      });
    }
    banners = json['banner'] != null ? Banners.fromJson(json['banner']) : null;
    ads = json['ads'] != null ? Ads.fromJson(json['ads']) : null;
  }
}

class Banners {
  String? link;
  String? image;

  Banners({this.link, this.image});

  Banners.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['link'] = link;
    data['image'] = image;
    return data;
  }
}

class Ads {
  String? android;
  String? ios;

  Ads({this.android, this.ios});

  Ads.fromJson(Map<String, dynamic> json) {
    android = json['android'];
    ios = json['ios'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['android'] = android;
    data['ios'] = ios;
    return data;
  }
}

class BannerModel {
  int? id;
  String? title;
  String? image;
  String? description;

  BannerModel({this.id, this.title, this.image, this.description});

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
  }
}
