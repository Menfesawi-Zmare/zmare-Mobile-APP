import 'package:flutter/material.dart';
import 'package:zmare/src/utils/ext/common.dart';

enum PageType {
  explorer,
  latest,
  popular,
  // random,
  library,
  login;

  int get toIndex {
    switch (this) {
      case PageType.explorer:
        return 0;
      case PageType.latest:
        return 1;
      case PageType.popular:
        return 2;
      case PageType.library:
        return 3;
      case PageType.login:
        return 4;
    }
  }

  String name(BuildContext context) {
    switch (this) {
      case PageType.explorer:
        return context.loc.explorerLabel;
      case PageType.latest:
        return context.loc.latestLabel;
      case PageType.popular:
        return context.loc.popularLabel;
      case PageType.library:
        return context.loc.libraryLabel;
      case PageType.login:
        return context.loc.profileLabel;
    }
  }
}
