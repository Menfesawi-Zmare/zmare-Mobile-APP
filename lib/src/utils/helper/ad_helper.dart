import 'dart:io';
import 'package:zmare/src/app/routes.dart';
import 'package:zmare/src/utils/helper/constants.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logging/logging.dart';

class AdHelper {
  static String? interstitaladid;
  static String? rewardadid;

  static InterstitialAd? _interstitialAd;
  static int _numInterstitialLoadAttempts = 0;
  static int? maxInterstitialAdclick = int.parse(settings.get(
      Platform.isAndroid
          ? androidMaxInterstitialAdClick
          : iosMaxInterstitialAdClick,
      defaultValue: 5));
  static var interstialad = settings.get(
      Platform.isAndroid ? androidInterstitialStatus : iosInterstitialStatus,
      defaultValue: 0);

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return settings.get(androidInterstitialAd, defaultValue: '') ?? '';
    } else if (Platform.isIOS) {
      return settings.get(iosInterstitialAd, defaultValue: '') ?? '';
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static showInterstitialAd() {
    Logger.root.info('===>$interstialad');
    Logger.root.info('===>$maxInterstitialAdclick');
    if (_numInterstitialLoadAttempts == maxInterstitialAdclick) {
      _numInterstitialLoadAttempts = 0;
      if (_interstitialAd == null) {
        Logger.root
            .info('Warning: attempt to show interstitial before loaded.');

        return false;
      }
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) =>
            Logger.root.info('ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          Logger.root.info('$ad onAdDismissedFullScreenContent.');
          ad.dispose();
          createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          Logger.root.info('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
          createInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
      return;
    }
    _numInterstitialLoadAttempts += 1;
  }

  static void createInterstitialAd() {
    if (interstialad == 1) {
      InterstitialAd.load(
          adUnitId: interstitialAdUnitId,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) {
              Logger.root.info('====> ads $ad');
              _interstitialAd = ad;
              _numInterstitialLoadAttempts = 0;
              ad.setImmersiveMode(true);
            },
            onAdFailedToLoad: (LoadAdError error) {
              Logger.root.info('InterstitialAd failed to load: $error');
            },
          ));
    }
  }
}
