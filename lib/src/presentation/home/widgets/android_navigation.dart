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
        // height: 30,
        animationDuration: Duration(seconds: 2),
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
            icon: SvgPicture.asset(
              height: 32,
              fit: BoxFit.cover,
              // ignore: deprecated_member_use
              colorBlendMode: BlendMode.srcIn,
              "assets/images/mesenko.svg",
              // ignore: deprecated_member_use
              color: Colors.white,
            ),
            selectedIcon: SvgPicture.asset(
              height: 32,
              fit: BoxFit.cover,
              // ignore: deprecated_member_use
              colorBlendMode: BlendMode.srcIn,
              "assets/images/mesenko-filled.svg",
              // ignore: deprecated_member_use
              color: Colors.white,
            ),
            // icon: const Icon(Icons.church_outlined),
            // selectedIcon: const Icon(Icons.church_rounded),
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
              )),
          NavigationDestination(
            label: context.loc.libraryLabel,
            icon: const Icon(FluentIcons.book_20_regular),
            selectedIcon: const Icon(FluentIcons.book_20_filled),
          ),
          NavigationDestination(
            label: context.loc.profileLabel,
            icon: SvgPicture.asset(
              "assets/man.svg",
              height: 28,
              fit: BoxFit.cover,
              // colorFilter:
              //     const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            selectedIcon: SvgPicture.asset(
              "assets/man.svg",
              height: 28,
              fit: BoxFit.cover,
              // colorFilter:
              //     const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
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
