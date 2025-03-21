import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zmare/src/presentation/widgets/mini_player.dart';
import 'package:go_router/go_router.dart';
import 'package:zmare/src/presentation/home/widgets/android_navigation.dart';
import 'package:zmare/src/presentation/home/widgets/ios_navigation.dart';

class HomeMobilePage extends StatelessWidget {
  const HomeMobilePage({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: navigationShell,
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (navigationShell.currentIndex == 4) SizedBox() else MiniPlayer(),
            if (Platform.isIOS)
              IosNavigation(navigationShell: navigationShell)
            else
              AndroidNavigation(navigationShell: navigationShell)
          ],
        ));
  }
}
