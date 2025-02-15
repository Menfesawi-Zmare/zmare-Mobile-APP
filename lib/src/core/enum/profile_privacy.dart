import 'package:flutter/material.dart';
import 'package:zmare/src/utils/ext/common.dart';

enum ProfilePrivacy {
  public,
  private,
  onlySubscribedAllowed;

  int get toIndex {
    switch (this) {
      case ProfilePrivacy.public:
        return 0;
      case ProfilePrivacy.private:
        return 1;
      case ProfilePrivacy.onlySubscribedAllowed:
        return 2;
    }
  }

  String name(BuildContext context) {
    switch (this) {
      case ProfilePrivacy.public:
        return context.loc.public;
      case ProfilePrivacy.private:
        return context.loc.private;
      case ProfilePrivacy.onlySubscribedAllowed:
        return context.loc.onlySubscribedAllowed;
    }
  }
}
