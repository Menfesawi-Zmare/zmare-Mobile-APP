import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/utils/helper/app_lifecycle_reactor.dart';
import 'package:zmare/src/utils/helper/app_open_ad_manager.dart';

import '../src/app/routes.dart';

import 'core/theme/zmare_theme.dart';

import 'presentation/widgets/khmertracks_annotate_region_widget.dart';

class FlutterMusicPro extends StatefulWidget {
  const FlutterMusicPro({super.key, required this.settings});
  final Box<dynamic> settings;
  @override
  State<FlutterMusicPro> createState() => _FlutterMusicProState();

  // ignore: library_private_types_in_public_api
  static _FlutterMusicProState of(BuildContext context) =>
      context.findAncestorStateOfType<_FlutterMusicProState>()!;
}

class _FlutterMusicProState extends State<FlutterMusicPro> {
  late StreamSubscription _intentDataStreamSubscription;
  late AppLifecycleReactor _appLifecycleReactor;

  @override
  void initState() {
    super.initState();
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    _appLifecycleReactor =
        AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KhmertracksAnnotatedRegionWidget(
      child: ValueListenableBuilder<Box>(
        valueListenable: widget.settings.listenable(
          keys: [
            appColorKey,
            dynamicThemeKey,
            themeModeKey,
            appLanguageKey,
            appFontChangerKey
          ],
        ),
        builder: (context, value, _) {
          final bool isDynamic = value.get(
            dynamicThemeKey,
            defaultValue: false,
          );
          final ThemeMode themeMode = ThemeMode.values[value.get(
            themeModeKey,
            defaultValue: 2,
          )];
          final int color = value.get(
            appColorKey,
            defaultValue: 0xFFD9D9D9,
          );
          final Color primaryColor = Color(0xFFD9D9D9);
          final Locale locale =
              Locale(value.get(appLanguageKey, defaultValue: 'en'));
          final String fontPreference =
              value.get(appFontChangerKey, defaultValue: defaultFontName);
          return DynamicColorBuilder(
            builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
              ColorScheme lightColorScheme;
              ColorScheme darkColorScheme;
              if (lightDynamic != null && darkDynamic != null && isDynamic) {
                lightColorScheme = lightDynamic.harmonized();
                darkColorScheme = darkDynamic.harmonized();
              } else {
                lightColorScheme = ColorScheme.fromSeed(
                  seedColor: Color(0xFFD9D9D9),
                );
                darkColorScheme = ColorScheme.fromSeed(
                  seedColor: Color(0xFFD9D9D9),
                  brightness: Brightness.dark,
                  background: Color(0xFF121212),
                );
              }
              final lightTextTheme = GoogleFonts.getTextTheme(
                fontPreference,
                ThemeData.light().textTheme,
              );
              final darkTextTheme = GoogleFonts.getTextTheme(
                fontPreference,
                ThemeData.dark().textTheme,
              );
              return MaterialApp.router(
                locale: locale,
                routerConfig: goRouter,
                // home: OnBoardingScreen(),
                debugShowCheckedModeBanner: false,
                themeMode: themeMode,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                onGenerateTitle: (BuildContext context) => context.loc.appTitle,
                theme: ThemeData.from(
                  colorScheme: lightColorScheme,
                ).copyWith(
                  textTheme: lightTextTheme,
                  colorScheme: lightColorScheme,
                  dialogTheme: dialogTheme,
                  timePickerTheme: timePickerTheme,
                  appBarTheme: appBarThemeLight(lightColorScheme),
                  scaffoldBackgroundColor: lightColorScheme.surface,
                  dialogBackgroundColor: lightColorScheme.surface,
                  navigationBarTheme: navigationBarThemeData(
                    lightColorScheme,
                    lightTextTheme,
                  ),
                  navigationDrawerTheme: navigationDrawerThemeData(
                    lightColorScheme,
                    lightTextTheme,
                  ),
                  drawerTheme: drawerThemeData(
                    lightColorScheme,
                    lightTextTheme,
                  ),
                  applyElevationOverlayColor: true,
                  inputDecorationTheme: inputDecorationTheme,
                  elevatedButtonTheme: elevatedButtonTheme(
                    context,
                    lightColorScheme,
                  ),
                  dividerTheme: DividerThemeData(
                    color: ThemeData.light().dividerColor,
                  ),
                ),
                darkTheme: ThemeData.from(
                  colorScheme: darkColorScheme,
                ).copyWith(
                  textTheme: darkTextTheme,
                  colorScheme: darkColorScheme,
                  dialogTheme: dialogTheme,
                  timePickerTheme: timePickerTheme,
                  appBarTheme: appBarThemeDark(darkColorScheme),
                  scaffoldBackgroundColor: darkColorScheme.surface,
                  dialogBackgroundColor: darkColorScheme.surface,
                  navigationBarTheme: navigationBarThemeData(
                    darkColorScheme,
                    darkTextTheme,
                  ),
                  navigationDrawerTheme: navigationDrawerThemeData(
                    darkColorScheme,
                    darkTextTheme,
                  ),
                  drawerTheme: drawerThemeData(
                    darkColorScheme,
                    darkTextTheme,
                  ),
                  applyElevationOverlayColor: true,
                  inputDecorationTheme: inputDecorationTheme,
                  elevatedButtonTheme: elevatedButtonTheme(
                    context,
                    darkColorScheme,
                  ),
                  dividerTheme: DividerThemeData(
                    color: ThemeData.dark().dividerColor,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
