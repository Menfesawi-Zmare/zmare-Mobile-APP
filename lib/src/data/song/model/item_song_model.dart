class ItemSongModel {
  int? id;
  String? title;
  String? artistId;
  String? artist;
  String? artistImage;
  int? albumId;
  String? album;
  String? albumCover;
  String? year;
  int? views;
  String? genre;
  String? lyrics;
  String? image;
  String? url;
  String? link;
  bool? download;

  ItemSongModel(
      {this.id,
      this.title,
      this.artistId,
      this.artist,
      this.artistImage,
      this.albumId,
      this.album,
      this.albumCover,
      this.year,
      this.views,
      this.genre,
      this.lyrics,
      this.image,
      this.url,
      this.link,
      this.download});

  ItemSongModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    artistId = json['artist_id'];
    artist = json['artist'];
    artistImage = json['artist_image'];
    albumId = json['album_id'];
    album = json['album'];
    albumCover = json['album_cover'];
    year = json['year'];
    views = json['views'];
    genre = json['genre'];
    lyrics = json['lyrics'];
    image = json['image'];
    url = json['url'];
    link = json['link'];
    download = json['download'];
  }
  

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['artist_id'] = artistId;
    data['artist'] = artist;
    data['artist_image'] = artistImage;
    data['album_id'] = albumId;
    data['album'] = album;
    data['album_cover'] = albumCover;
    data['year'] = year;
    data['views'] = views;
    data['genre'] = genre;
    data['lyrics'] = lyrics;
    data['image'] = image;
    data['url'] = url;
    data['link'] = link;
    data['download'] = download;
    return data;
  }
}