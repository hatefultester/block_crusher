

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:block_crusher/src/services/ads_controller.dart';
import 'package:block_crusher/src/services/crashlytics.dart';
import 'package:block_crusher/src/services/games_services.dart';
import 'package:block_crusher/src/services/in_app_purchase.dart';
import 'package:block_crusher/src/storage/persistence/local_storage_game_achievements_persistence.dart';
import 'package:block_crusher/src/storage/persistence/local_storage_level_statistics_persistence.dart';
import 'package:block_crusher/src/storage/persistence/local_storage_player_progress_persistence.dart';
import 'package:block_crusher/src/storage/persistence/local_storage_treasure_counter_persistence.dart';
import 'package:block_crusher/src/storage/persistence/local_storage_world_unlock_manager_persistence.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'src/storage/persistence/local_storage_settings_persistence.dart';

Future<void> main() async {
  FirebaseCrashlytics? crashlytics = await _initializeFirebaseCrashlytics();

  await guardWithCrashlytics(
    guardedMain,
    crashlytics: crashlytics,
  );
}

void guardedMain() {
  WidgetsFlutterBinding.ensureInitialized();

  AdsController? adsController;

  if (!kIsWeb && (Platform.isAndroid)) {
    adsController = AdsController(MobileAds.instance);
    adsController.initialize();
  }

  GamesServicesController? gamesServicesController;
  // if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
  //   gamesServicesController = GamesServicesController()
  //     // Attempt to log the player in.
  //     ..initialize();
  // }

  InAppPurchaseController? inAppPurchaseController;
  // if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
  //   inAppPurchaseController = InAppPurchaseController(InAppPurchase.instance)
  //     // Subscribing to [InAppPurchase.instance.purchaseStream] as soon
  //     // as possible in order not to miss any updates.
  //     ..subscribe();
  //   // Ask the store what the player has bought already.
  //   inAppPurchaseController.restorePurchases();
  // }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky).then(
    (_) => runApp(
      MyApp(
        settingsPersistence: LocalStorageSettingsPersistence(),
        worldUnlockManagerPersistence: LocalStorageWorldUnlockManagerPersistence(),
        treasureCounterPersistence: LocalStorageTreasureCounterPersistence(),
        levelStatisticsPersistence: LocalStorageLevelStatisticsPersistence(),
        gameAchievementsPersistence: LocalStorageGameAchievementsPersistence(),
        playerInventoryPersistence: LocalStoragePlayerInventoryPersistence(),
        inAppPurchaseController: inAppPurchaseController,
        adsController: adsController,
        gamesServicesController: gamesServicesController,
      ),
    ),
  );

  final AudioContext audioContext = AudioContext(
    iOS: AudioContextIOS(
      defaultToSpeaker: true,
      category: AVAudioSessionCategory.playback,
      options: [
        AVAudioSessionOptions.defaultToSpeaker,
        AVAudioSessionOptions.mixWithOthers,
      ],
    ),
    android: AudioContextAndroid(
      isSpeakerphoneOn: true,
      stayAwake: true,
      contentType: AndroidContentType.sonification,
      usageType: AndroidUsageType.assistanceSonification,
      audioFocus: AndroidAudioFocus.none,
    ),
  );

  if (Platform.isIOS) {
  AudioPlayer.global.setGlobalAudioContext(audioContext);
  }
}

_initializeFirebaseCrashlytics() async {
  if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      return FirebaseCrashlytics.instance;
    } catch (e) {
      debugPrint("Firebase couldn't be initialized: $e");
    }
  }
}