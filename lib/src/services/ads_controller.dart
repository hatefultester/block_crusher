import 'dart:io';

import 'package:block_crusher/src/services/ads_ids.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'preloaded_banner_ad.dart';

enum AdType {
  winAd, lostAd, dashboardAd
}

class AdsController {
  final MobileAds _instance;

  late InterstitialAd fullscreenAd;

  bool isFullscreenAdLoaded = false;

  PreloadedBannerAd? _preloadedAd;

  var _fullScreenAd;

  AdsController(MobileAds instance) : _instance = instance;

  void dispose() {
    _preloadedAd?.dispose();
  }

  Future<void> initialize() async {
    await _instance.initialize();

  }

  void preloadBannerAd(AdType adType) {
    // todo implement iOS
    if(!Platform.isAndroid) return;


    if (adsIds[adType] != null) {
      _preloadedAd =
          PreloadedBannerAd(size: bannerAdSize, adUnitId: adsIds[adType]!);
    }

    Future<void>.delayed(const Duration(seconds: 1)).then((_) {
      return _preloadedAd!.load();
    });
  }

  void loadFullscreenAd() {
    if(Platform.isAndroid) {
      print('loading ad');
      InterstitialAd.load(adUnitId: adsIds[AdType.lostAd]!,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
              onAdLoaded: (InterstitialAd ad) {
                fullscreenAd = ad;
                isFullscreenAdLoaded = true;
                print('fullscreen ad preloaded');
              },
              onAdFailedToLoad: (LoadAdError error) {
                print(error.toString());
              }

          ),);
    }
  }

  void showFullscreenAd() {
    if(isFullscreenAdLoaded) {
      fullscreenAd.show();
      isFullscreenAdLoaded = false;
    }
  }


  PreloadedBannerAd? takePreloadedAd() {
    final ad = _preloadedAd;
    _preloadedAd = null;
    return ad;
  }
}
