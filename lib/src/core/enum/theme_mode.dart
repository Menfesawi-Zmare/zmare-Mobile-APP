import 'package:flutter/material.dart';
import 'package:zmare/src/utils/ext/common.dart';

extension ThemeModeName on ThemeMode {
  String themeName(BuildContext context) {
    switch (this) {
      case ThemeMode.system:
        return context.loc.systemDefault;
      case ThemeMode.light:
        return context.loc.light;
      case ThemeMode.dark:
        return context.loc.dark;
    }
  }
}
