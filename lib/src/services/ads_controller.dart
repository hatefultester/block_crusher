import 'dart:io';

import 'package:block_crusher/src/services/ads_ids.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'preloaded_banner_ad.dart';

class AdsController {
  final MobileAds _instance;

  PreloadedBannerAd? _preloadedAd;

  AdsController(MobileAds instance) : _instance = instance;

  void dispose() {
    _preloadedAd?.dispose();
  }

  Future<void> initialize() async {
    await _instance.initialize();

  }

  void preloadAd() {
    // todo implement iOS
    if(!Platform.isAndroid) return;

    _preloadedAd =
        PreloadedBannerAd(size: bannerAdSize, adUnitId: bannerAdId);

    Future<void>.delayed(const Duration(seconds: 1)).then((_) {
      return _preloadedAd!.load();
    });
  }

  PreloadedBannerAd? takePreloadedAd() {
    final ad = _preloadedAd;
    _preloadedAd = null;
    return ad;
  }
}
