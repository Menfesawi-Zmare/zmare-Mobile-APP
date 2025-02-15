import 'package:flutter/material.dart';
import 'package:zmare/src/utils/ext/common.dart';

enum PlaylistPrivacyType {
  public,
  private;

  int get toIndex {
    switch (this) {
      case PlaylistPrivacyType.private:
        return 2;
      case PlaylistPrivacyType.public:
        return 1;
    }
  }

  String name(BuildContext context) {
    switch (this) {
      case PlaylistPrivacyType.private:
        return context.loc.private;
      case PlaylistPrivacyType.public:
        return context.loc.public;
    }
  }
}
