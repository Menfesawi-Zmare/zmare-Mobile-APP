import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logging/logging.dart';

class AdmobBannerWidget extends StatefulWidget {
  const AdmobBannerWidget(
      {super.key, required this.androidAds, required this.iosAds});
  final String? androidAds;
  final String? iosAds;
  @override
  State<AdmobBannerWidget> createState() => _AdmobBannerWidgetState();
}

class _AdmobBannerWidgetState extends State<AdmobBannerWidget> {
  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;

  @override
  void didChangeDependencies() {
    // Create the ad objects and load ads.
    _bannerAd = BannerAd(
      size: AdSize.leaderboard,
      request: const AdRequest(),
      adUnitId: Platform.isAndroid ? widget.androidAds! : widget.iosAds!,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          Logger.root.info('$BannerAd loaded.');
          setState(() => _bannerAdIsLoaded = true);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          Logger.root.info('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => Logger.root.info('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => Logger.root.info('$BannerAd onAdClosed.'),
      ),
    )..load();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BannerAd? bannerAd = _bannerAd;
    if (_bannerAdIsLoaded && bannerAd != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: bannerAd.size.height.toDouble(),
          width: bannerAd.size.width.toDouble(),
          child: AdWidget(ad: bannerAd),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
