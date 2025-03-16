import 'dart:io';

import 'package:flutter/material.dart';

class Images {
  Images._();
  static const String logoIcon = 'assets/images/icon.png';
  static const String zmareIconWhite = "assets/logo-white.svg";
  static const String zmareIconBlack = "assets/logo-black.svg";
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
  static const String angleBlackIcon = "assets/angle.svg";
  static const String angleWhiteIcon = "assets/angle-white.svg";
  static const String man = "assets/man.svg";
  static const String onBoardingImg1 = "assets/zmare1.png";
  static const String onBoardingImg2 = "assets/zmare2.png";
  static const String onBoardingImg3 = "assets/zmare3.png";
  static const String onBoardingImg4 = "assets/zmare4.png";
  static const String onBoardingImg5 = "assets/zmare5.png";
  static const String onBoardingImg6 = "assets/zmare6.png";
  static const String onBoardingImg7 = "assets/zmare7.png";
  static const String onBoardingImg8 = "assets/zmare8.png";
  static const String afroAygebamCross = "assets/images/afro_aygebam_cross.svg";
}

ImageProvider getAlbumImage(String? albumArtPath) {
  if (albumArtPath == null || !File(albumArtPath).existsSync()) {
    return const AssetImage('assets/cover.png');
  }
  return FileImage(File(albumArtPath));
}
