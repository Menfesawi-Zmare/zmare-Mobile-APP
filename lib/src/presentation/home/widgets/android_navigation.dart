import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:go_router/go_router.dart';

class AndroidNavigation extends StatelessWidget {
  const AndroidNavigation({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory),
      child: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => _onTap(context, index),
        destinations: [
          NavigationDestination(
            label: context.loc.explorerLabel,
            icon: SvgPicture.asset(
              height: 23,
              fit: BoxFit.cover,
              // ignore: deprecated_member_use
              colorBlendMode: BlendMode.srcIn,
              "assets/images/home.svg",
              // ignore: deprecated_member_use
              color: Colors.white,
            ),
            selectedIcon: SvgPicture.asset(
              height: 23,
              fit: BoxFit.cover,
              // ignore: deprecated_member_use
              colorBlendMode: BlendMode.srcIn,
              "assets/images/home_filled.svg",
              // ignore: deprecated_member_use
              color: Colors.white,
            ),
          ),
          NavigationDestination(
            label: context.loc.latestLabel,
            icon: const Icon(Icons.church_outlined),
            selectedIcon: const Icon(Icons.church_rounded),
          ),
          NavigationDestination(
              label: context.loc.popularLabel,
              icon: SvgPicture.asset(
                "assets/images/mekwamya.svg",
                height: 28,
                fit: BoxFit.cover,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
              selectedIcon: SvgPicture.asset(
                "assets/images/mekuamya_filled.svg",
                height: 28,
                fit: BoxFit.cover,
                color: Colors.white,
              )

              // icon: const Icon(FluentIcons.arrow_trending_12_regular),
              // selectedIcon: const Icon(FluentIcons.arrow_trending_12_filled),
              ),
          // NavigationDestination(
          //   label: context.loc.randomLabel,
          //   icon: const Icon(FluentIcons.arrow_repeat_all_16_regular),
          //   selectedIcon: const Icon(FluentIcons.arrow_repeat_all_16_filled),
          // ),
          NavigationDestination(
            label: context.loc.libraryLabel,
            icon: const Icon(FluentIcons.library_16_regular),
            selectedIcon: const Icon(FluentIcons.library_16_filled),
          ),

          NavigationDestination(
            label: context.loc.profileLabel,
            icon: const Icon(FluentIcons.person_12_regular),
            selectedIcon: const Icon(FluentIcons.person_16_regular),
          ),
        ],
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
