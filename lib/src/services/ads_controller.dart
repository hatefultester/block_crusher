import 'dart:io';

import 'package:block_crusher/src/services/ads_ids.dart';
import 'package:flutter/foundation.dart';
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
    // testDeviceIds: [
    //   '3ce90dbe-37fa-464f-9cec-afb64db46889',
    //   'de44ccb9-76a2-4d97-ad64-2b9c3b381549',
    // ],
  );

  AdsController(MobileAds instance) : _instance = instance;

  Future<void> initialize() async {
    await _instance.initialize();
    await _instance.updateRequestConfiguration(_adRequestConfiguration);
  }

  Map<AdType, String> androidAppIds = kDebugMode
      ? {
          AdType.banner: 'ca-app-pub-3940256099942544/6300978111',
          AdType.interstitial:
              // 'ca-app-pub-3940256099942544/8691691433', //
  'ca-app-pub-3940256099942544/1033173712',
          AdType.rewardedInterstitial: 'ca-app-pub-3940256099942544/5354046379',
          AdType.rewarded: 'ca-app-pub-3940256099942544/5224354917',
          AdType.nativeAdvanced: 'ca-app-pub-3940256099942544/2247696110',
          AdType.appOpen: 'ca-app-pub-3940256099942544/3419835294',
        }
      : {
          AdType.banner: 'ca-app-pub-8632510784563928/8164159347',
          AdType.interstitial: 'ca-app-pub-8632510784563928/5631728296',
          AdType.rewardedInterstitial: 'ca-app-pub-8632510784563928/7931692228',
          AdType.rewarded: 'ca-app-pub-8632510784563928/9187829927',
          AdType.nativeAdvanced: 'ca-app-pub-8632510784563928/2679365543',
          AdType.appOpen: 'ca-app-pub-8632510784563928/6234363525',
        };

  InterstitialAd? fullscreenAd;

  bool isFullscreenAdLoaded = false;

  int displayAdCallBackCalledSum = 0;

  PreloadedBannerAd? _preloadedAd;

  void dispose() {
    _preloadedAd?.dispose();
  }

  void preloadBannerAd(AdType adType) {
    // todo implement iOS
    if (!Platform.isAndroid) return;

    // if (adsIds[adType] != null) {
    //   _preloadedAd =
    //       PreloadedBannerAd(size: bannerAdSize, adUnitId: adsIds[adType]!,);
    // }

    Future<void>.delayed(const Duration(seconds: 1)).then((_) {
      return _preloadedAd?.load();
    });
  }

  void loadFullscreenAd() {


    if (Platform.isAndroid) {
      if (kDebugMode) {
        print('loading ad');
      }

      if (!isFullscreenAdLoaded) {
        InterstitialAd.load(
          adUnitId: androidAppIds[AdType.interstitial]!,
          request: const AdRequest(),
          adLoadCallback:
              InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
            if (kDebugMode) {
              print('add loaded');
            }
            fullscreenAd = ad;
            isFullscreenAdLoaded = true;
            if (kDebugMode) {
              print('fullscreen ad preloaded');
            }
          }, onAdFailedToLoad: (LoadAdError error) {
            if (kDebugMode) {
              print(error.toString());
            }
          }),
        );
      } else {
        if (kDebugMode) {
          print(' AD IS ALREADY LOADED NO NEED TO LOAD ');
        }
      }
    }
  }

  bool displayFullscreenAd() {
    if (!isFullscreenAdLoaded) {
      return false;
    }
    else {
      return displayAdCallBackCalledSum.isOdd;
    }
  }

  Future<void> showFullscreenAd({Function? afterIntent}) async {
    displayAdCallBackCalledSum++;

    if (kDebugMode) {
      print('calling');
    }
    if(fullscreenAd == null ) {
      if (afterIntent != null) {
        afterIntent();
      }  return;
    }

    fullscreenAd?.fullScreenContentCallback = FullScreenContentCallback(

        onAdDismissedFullScreenContent: (fullscreenAd) {
      if (afterIntent != null) {
        afterIntent();
        return;
      }
    }, onAdFailedToShowFullScreenContent: (fullscreenAd, error) {
      if (afterIntent != null) {
        debugPrint('AD LOADED ERROR : ${error.toString()}');
        afterIntent();
        return;
      }
    },);

    if (displayFullscreenAd()) {
      await fullscreenAd?.show();
      isFullscreenAdLoaded = false;
    } else {
      if (afterIntent != null) {
        afterIntent();
        return;
      }
    }
  }

  PreloadedBannerAd? takePreloadedAd() {
    final ad = _preloadedAd;
    _preloadedAd = null;
    return ad;
  }
}
