import 'package:flutter_music_pro/src/app/routes.dart';
import 'package:flutter_music_pro/src/utils/helper/constants.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform;

/// Utility class that manages loading and showing app open ads.
class AppOpenAdManager {
  /// Maximum duration allowed between loading and showing the ad.
  final Duration maxCacheDuration = const Duration(hours: 4);

  /// Keep track of load time so we don't show an expired ad.
  DateTime? _appOpenLoadTime;

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  dynamic adUnitId = settings.get(
      Platform.isAndroid ? androidAppOpenAd : iosAppOpenAd,
      defaultValue: '');
  static var adOpenStatus = settings.get(
      Platform.isAndroid ? androidAppOpenStatus : iosAppOpenStatus,
      defaultValue: 0);

  /// Load an [AppOpenAd].
  void loadAd() {
    if (adOpenStatus == 1) {
      AppOpenAd.load(
        orientation: AppOpenAd.orientationPortrait,
        adUnitId: adUnitId ?? '',

        // orientation: AppOpenAd.orientationPortrait,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            _appOpenLoadTime = DateTime.now();
            _appOpenAd = ad;
          },
          onAdFailedToLoad: (error) {
            // Logger.root.info('AppOpenAd failed to load: $error');
          },
        ),
      );
    }
  }

  /// Whether an ad is available to be shown.
  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  /// Shows the ad, if one exists and is not already being shown.
  ///
  /// If the previously cached ad has expired, this just loads and caches a
  /// new ad.
  void showAdIfAvailable() {
    if (!isAdAvailable) {
      // Logger.root.info('Tried to show ad before available.');
      loadAd();
      return;
    }
    if (_isShowingAd) {
      // Logger.root.info('Tried to show ad while already showing an ad.');
      return;
    }
    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      // Logger.root.info('Maximum cache duration exceeded. Loading another ad.');
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        // Logger.root.info('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        // Logger.root.info('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        // Logger.root.info('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    _appOpenAd!.show();
  }
}
