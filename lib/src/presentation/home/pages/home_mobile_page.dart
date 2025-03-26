import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:zmare/src/presentation/home/widgets/android_navigation.dart';
import 'package:zmare/src/presentation/home/widgets/ios_navigation.dart';

import '../../../core/enum/box_types.dart';
import '../../../service_locator.dart';

class HomeMobilePage extends StatelessWidget {
  const HomeMobilePage({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final showMiniPlayer = locator.get<Box<dynamic>>(
      instanceName: BoxType.showMiniPlayer.name,
    );
    final currentShowMiniPlayer =
        showMiniPlayer.get('showMiniPlayer', defaultValue: true);
    if (navigationShell.currentIndex == 4 && currentShowMiniPlayer != false) {
      showMiniPlayer.put('showMiniPlayer', false); // Hide MiniPlayer on index 4
    } else if (navigationShell.currentIndex != 4 &&
        currentShowMiniPlayer != true) {
      showMiniPlayer.put('showMiniPlayer', true);
    }
    return Scaffold(
        body: navigationShell,
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (Platform.isIOS)
              IosNavigation(navigationShell: navigationShell)
            else
              AndroidNavigation(navigationShell: navigationShell)
          ],
        ));
  }
}
