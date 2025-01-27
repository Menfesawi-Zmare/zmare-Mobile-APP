import 'dart:io';

import 'package:flutter/material.dart';

class Images {
  Images._();
  static const String logoIcon = 'assets/images/icon.png';
  static const String transparentIcon = 'assets/images/huraIcon.png';
  static const String defalutProductionCover = 'assets/production.png';
  static const String defalultArtistCover = 'assets/artist.png';
  static const String defalutAlbumCover = 'assets/album.png';
  static const String defalutSongCover = 'assets/song.png';
  static const String defalutCover = 'assets/cover.png';
  static const String facebookIcon = 'assets/facebook.png';
  static const String twitterIcon = 'assets/twitter.png';
  static const String youtubeIcon = 'assets/youtube.png';
  static const String instagramIcon = 'assets/instagram.png';
  static const String gmailIcon = 'assets/gmail.png';
  static const String appleIcon = 'assets/apple.png';
}

ImageProvider getAlbumImage(String? albumArtPath) {
  if (albumArtPath == null || !File(albumArtPath).existsSync()) {
    return const AssetImage('assets/cover.png');
  }
  return FileImage(File(albumArtPath));
}
