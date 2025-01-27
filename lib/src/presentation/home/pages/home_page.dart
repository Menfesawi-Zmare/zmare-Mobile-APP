import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/presentation/home/pages/home_mobile_page.dart';
import 'package:flutter_music_pro/src/presentation/login/bloc/auth_bloc.dart';
import 'package:flutter_music_pro/src/service_locator.dart';
import 'package:flutter_music_pro/src/utils/helper/ad_helper.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_annotate_region_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));
  final StatefulNavigationShell navigationShell;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final AuthBloc authBloc = locator.get<AuthBloc>();
  @override
  void initState() {
    authBloc.add(AppSettingsEvent());
    authBloc.add(GetProfileEvent());
    AdHelper.createInterstitialAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KhmertracksAnnotatedRegionWidget(
      child: ScreenTypeLayout.builder(
        mobile: (p0) => HomeMobilePage(navigationShell: widget.navigationShell),
      ),
    );
  }
}
