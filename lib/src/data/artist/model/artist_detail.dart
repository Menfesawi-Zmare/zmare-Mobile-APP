import 'package:zmare/src/data/artist/model/artist.dart';

class ArtistDetail {
  Artist? artist;

  ArtistDetail({this.artist});

  ArtistDetail.fromJson(Map<String, dynamic> json) {
    artist = json['data'] != null ? Artist.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (artist != null) {
      data['data'] = artist!.toJson();
    }
    return data;
  }
}
