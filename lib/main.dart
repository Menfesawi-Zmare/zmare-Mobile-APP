import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:zmare/src/presentation/network/bloc/network_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zmare/src/app.dart';
import 'package:zmare/src/service_locator.dart';
import 'package:hive/hive.dart';
import 'src/core/enum/box_types.dart';
import 'src/utils/helper/local_notfication.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Google Mobile Ads
  MobileAds.instance.initialize();
  await LocalNotificationService.init();

  // Set up dependency injection
  await setupLocator();

  // Set optimal display mode for Android
  if (Platform.isAndroid) {
    await setOptimalDisplayMode();
  }

  final Box<dynamic> settings =
      getIt.get<Box<dynamic>>(instanceName: BoxType.settings.name);

  runApp(
    BlocProvider(
      create: (context) => NetworkBloc()..add(NetworkObserve()),
      child: FlutterMusicPro(settings: settings),
    ),
  );
}

Future<void> setOptimalDisplayMode() async {
  final List<DisplayMode> supported = await FlutterDisplayMode.supported;
  final DisplayMode active = await FlutterDisplayMode.active;

  final List<DisplayMode> sameResolution = supported
      .where(
        (DisplayMode m) => m.width == active.width && m.height == active.height,
      )
      .toList()
    ..sort(
      (DisplayMode a, DisplayMode b) => b.refreshRate.compareTo(a.refreshRate),
    );

  final DisplayMode mostOptimalMode =
      sameResolution.isNotEmpty ? sameResolution.first : active;

  await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
}
