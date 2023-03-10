import 'dart:io';

import 'package:block_crusher/src/services/ads_ids.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'preloaded_banner_ad.dart';

enum AdType {
  winAd,
  lostAd,
  dashboardAd,

  banner,
  interstitial,
  nativeAdvanced,
  rewardedInterstitial,
  rewarded,
  appOpen,
}

class AdsController {
  final MobileAds _instance;

  final RequestConfiguration _adRequestConfiguration = RequestConfiguration(
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
      tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.yes,
      maxAdContentRating: MaxAdContentRating.g,
      testDeviceIds: [
        '3ce90dbe-37fa-464f-9cec-afb64db46889',
        'de44ccb9-76a2-4d97-ad64-2b9c3b381549',
      ]);

  AdsController(MobileAds instance) : _instance = instance;

  Future<void> initialize() async {
    await _instance.initialize();
    await _instance.updateRequestConfiguration(_adRequestConfiguration);
  }

  Map<AdType, String> androidAppIds = {
    AdType.banner : 'ca-app-pub-8632510784563928/8164159347',
    AdType.interstitial: 'ca-app-pub-8632510784563928/5631728296',
    AdType.rewardedInterstitial : 'ca-app-pub-8632510784563928/7931692228',
    AdType.rewarded : 'ca-app-pub-8632510784563928/9187829927',
    AdType.nativeAdvanced : 'ca-app-pub-8632510784563928/2679365543',
    AdType.appOpen : 'ca-app-pub-8632510784563928/6234363525',
  };

  late InterstitialAd fullscreenAd;

  bool isFullscreenAdLoaded = false;

  PreloadedBannerAd? _preloadedAd;

  void dispose() {
    _preloadedAd?.dispose();
  }



  void preloadBannerAd(AdType adType) {
    // todo implement iOS
    if (!Platform.isAndroid) return;

    if (adsIds[adType] != null) {
      _preloadedAd =
          PreloadedBannerAd(size: bannerAdSize, adUnitId: adsIds[adType]!,);
    }

    Future<void>.delayed(const Duration(seconds: 1)).then((_) {
      return _preloadedAd!.load();
    });
  }

  void loadFullscreenAd() {
    if (Platform.isAndroid) {
      print('loading ad');
      InterstitialAd.load(
        adUnitId: adsIds[AdType.lostAd]!,
        request: const AdRequest(),
        adLoadCallback:
            InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
          fullscreenAd = ad;
          isFullscreenAdLoaded = true;
          print('fullscreen ad preloaded');
        }, onAdFailedToLoad: (LoadAdError error) {
          print(error.toString());
        }),
      );
    }
  }

  void showFullscreenAd() {
    if (isFullscreenAdLoaded) {
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
