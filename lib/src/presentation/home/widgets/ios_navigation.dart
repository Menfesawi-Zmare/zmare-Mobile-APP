import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:go_router/go_router.dart';

class IosNavigation extends StatelessWidget {
  const IosNavigation({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory),
      child: SizedBox(
        height:
            MediaQuery.of(context).padding.bottom + kBottomNavigationBarHeight,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: NavigationBar(
            height: MediaQuery.of(context).padding.bottom +
                kBottomNavigationBarHeight -
                25,
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) => _onTap(context, index),
            destinations: [
              NavigationDestination(
                label: context.loc.explorerLabel,
                icon: const Icon(FluentIcons.compass_northwest_16_regular),
                selectedIcon:
                    const Icon(FluentIcons.compass_northwest_16_filled),
              ),
              NavigationDestination(
                label: context.loc.latestLabel,
                icon: const Icon(FluentIcons.music_note_2_16_regular),
                selectedIcon: const Icon(FluentIcons.music_note_2_16_filled),
              ),
              NavigationDestination(
                label: context.loc.popularLabel,
                icon: const Icon(FluentIcons.arrow_trending_12_regular),
                selectedIcon: const Icon(FluentIcons.arrow_trending_12_filled),
              ),
              // NavigationDestination(
              //   label: context.loc.randomLabel,
              //   icon: const Icon(FluentIcons.arrow_repeat_all_16_regular),
              //   selectedIcon:
              //       const Icon(FluentIcons.arrow_repeat_all_16_filled),
              // ),
              NavigationDestination(
                label: context.loc.libraryLabel,
                icon: const Icon(FluentIcons.library_16_regular),
                selectedIcon: const Icon(FluentIcons.library_16_filled),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
