

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/levels.dart';
import 'package:block_crusher/src/google_play/ads/ads_controller.dart';
import 'package:block_crusher/src/google_play/crashlytics/crashlytics.dart';
import 'package:block_crusher/src/google_play/games_services/games_services.dart';
import 'package:block_crusher/src/google_play/in_app_purchase/in_app_purchase.dart';
import 'package:block_crusher/src/google_play/remote_config/remote_config.dart';
import 'package:block_crusher/src/screens/main_screen/main_screen.dart';
import 'package:block_crusher/src/screens/play_session/scenarios/game_play_statistics.dart';
import 'package:block_crusher/src/screens/profile_screen/profile_screen.dart';
import 'package:block_crusher/src/screens/winning_screen/lost_game_screen.dart';
import 'package:block_crusher/src/settings/app_lifecycle/app_lifecycle.dart';
import 'package:block_crusher/src/settings/audio/audio_controller.dart';
import 'package:block_crusher/src/storage/game_achievements/game_achievements.dart';
import 'package:block_crusher/src/storage/game_achievements/persistence/game_achievements_persistence.dart';
import 'package:block_crusher/src/storage/game_achievements/persistence/local_storage_game_achievements_persistence.dart';
import 'package:block_crusher/src/storage/level_statistics/level_statistics.dart';
import 'package:block_crusher/src/storage/level_statistics/persistence/level_statistics_persistence.dart';
import 'package:block_crusher/src/storage/level_statistics/persistence/local_storage_level_statistics_persistence.dart';
import 'package:block_crusher/src/storage/player_inventory/persistence/local_storage_player_progress_persistence.dart';
import 'package:block_crusher/src/storage/player_inventory/persistence/player_inventory_persistence.dart';
import 'package:block_crusher/src/storage/player_inventory/player_inventory.dart';
import 'package:block_crusher/src/storage/treasure_counts/persistence/local_storage_treasure_counter_persistence.dart';
import 'package:block_crusher/src/storage/treasure_counts/persistence/treasure_counter_persistence.dart';
import 'package:block_crusher/src/storage/treasure_counts/treasure_counter.dart';
import 'package:block_crusher/src/storage/worlds_unlock_status/persistence/local_storage_world_unlock_manager_persistence.dart';
import 'package:block_crusher/src/storage/worlds_unlock_status/persistence/world_unlock_manager_persistence.dart';
import 'package:block_crusher/src/storage/worlds_unlock_status/world_unlock_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'src/screens/levels/level_selection_screen.dart';
import 'src/screens/play_session/play_session_screen.dart';
import 'src/settings/persistence/local_storage_settings_persistence.dart';
import 'src/settings/persistence/settings_persistence.dart';
import 'src/settings/settings.dart';
import 'src/screens/settings_screen/settings_screen.dart';
import 'src/style/my_transition.dart';
import 'src/style/palette.dart';
import 'src/style/custom_snackbars/snack_bar.dart';
import 'src/screens/winning_screen/win_game_screen.dart';

Future<void> main() async {
  // To enable Firebase Crashlytics, uncomment the following lines and
  // the import statements at the top of this file.
  // See the 'Crashlytics' section of the main README.md file for details.

  FirebaseCrashlytics? crashlytics;

  if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      crashlytics = FirebaseCrashlytics.instance;
    } catch (e) {
      debugPrint("Firebase couldn't be initialized: $e");
    }
  }


  await guardWithCrashlytics(
    guardedMain,
    crashlytics: crashlytics,
  );
}

/// Without logging and crash reporting, this would be `void main()`.
void guardedMain() {
  if (kReleaseMode) {
    // Don't log anything below warnings in production.
    Logger.root.level = Level.WARNING;
  }
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: '
        '${record.loggerName}: '
        '${record.message}');
  });

  WidgetsFlutterBinding.ensureInitialized();

  // TODO: When ready, uncomment the following lines to enable integrations.
  //       Read the README for more info on each integration.

  AdsController? adsController;
  if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
    /// Prepare the google_mobile_ads plugin so that the first ad loads
    /// faster. This can be done later or with a delay if startup
    /// experience suffers.
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
        adsController: null,
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

class MyApp extends StatelessWidget {
  static final _router = GoRouter(
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) =>
              const MainScreen(key: Key('main menu')),
          routes: [
            GoRoute(
                path: 'play',
                pageBuilder: (context, state) => buildMyTransition<void>(
                      child: const LevelSelectionScreen(
                          key: Key('level selection'),),
                  color: Colors.black,
                    ),
                routes: [
                  GoRoute(
                    path:'profile',
                    pageBuilder: (context, state) {
                      return buildMyTransition(child: const ProfileScreen(), color: Colors.black);
                    },
                  ),GoRoute(
                    path: 'settings',
                    builder: (context, state) =>
                    const SettingsScreen(key: Key('settings')),
                  ),
                  GoRoute(
                    path: 'session/:level/:sublevel',
                    pageBuilder: (context, state) {
                      final levelNumber = int.parse(state.params['level']!);

                      final subLevel = int.parse(state.params['sublevel']!);

                      final level = gameLevels
                              .singleWhere((e) => e.levelId == levelNumber);

                      return buildMyTransition<void>(
                        child: PlaySessionScreen(
                          level,
                          key: const Key('play session'),
                        ),
                        color: Colors.black,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'won',
                    pageBuilder: (context, state) {
                      final map = state.extra! as Map<String, dynamic>;
                      final score = map['score'] as GamePlayStatistics;

                      return buildMyTransition<void>(
                        child: WinGameScreen(
                          score: score,
                          key: const Key('win game'),
                        ),
                        color: Colors.black,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'lost',
                    pageBuilder: (context, state) {
                      final map = state.extra! as Map<String, dynamic>;
                      final score = map['score'] as GamePlayStatistics;

                      return buildMyTransition<void>(
                        child: LostGameScreen(
                          score: score,
                          key: const Key('lost game'),
                        ),
                        color: Colors.black,
                      );
                    },
                  )
                ]),
            GoRoute(
              path: 'settings',
              builder: (context, state) =>
                  const SettingsScreen(key: Key('settings')),
            ),
          ]),
    ],
  );

  final PlayerInventoryPersistence playerInventoryPersistence;

  final GameAchievementsPersistence gameAchievementsPersistence;

  final LevelStatisticsPersistence levelStatisticsPersistence;

  final TreasureCounterPersistence treasureCounterPersistence;

  final WorldUnlockManagerPersistence worldUnlockManagerPersistence;

  final SettingsPersistence settingsPersistence;

  final GamesServicesController? gamesServicesController;

  final InAppPurchaseController? inAppPurchaseController;

  final AdsController? adsController;

  const MyApp({
    required this.settingsPersistence,
    required this.inAppPurchaseController,
    required this.adsController,
    required this.gamesServicesController,
    super.key, required this.playerInventoryPersistence, required this.gameAchievementsPersistence, required this.levelStatisticsPersistence, required this.treasureCounterPersistence, required this.worldUnlockManagerPersistence,
  });

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<RemoteConfig>(
            create: (context) {
              var remoteConfig = RemoteConfig();
              remoteConfig.init();
              return remoteConfig;
            }
          ),
          ChangeNotifierProvider<PlayerInventory>(
            create: (context) {
              var progress = PlayerInventory(playerInventoryPersistence);
              progress.getLatestFromStore();
              return progress;
            },
          ),
          ChangeNotifierProvider<GameAchievements>(
            create: (context) {
              var progress = GameAchievements(gameAchievementsPersistence);
              progress.getLatestFromStore();
              return progress;
            },
          ),
          ChangeNotifierProvider<LevelStatistics>(
            create: (context) {
              var progress = LevelStatistics(levelStatisticsPersistence);
              progress.getLatestFromStore();
              return progress;
            },
          ),
          ChangeNotifierProvider<TreasureCounter>(
            create: (context) {
              var progress = TreasureCounter(treasureCounterPersistence);
              progress.getLatestFromStore();
              return progress;
            },
          ),
          ChangeNotifierProvider<WorldUnlockManager>(
            create: (context) {
              var progress = WorldUnlockManager(worldUnlockManagerPersistence);
              progress.getLatestFromStore();
              return progress;
            },
          ),
          Provider<GamesServicesController?>.value(
              value: gamesServicesController),
          Provider<AdsController?>.value(value: adsController),
          ChangeNotifierProvider<InAppPurchaseController?>.value(
              value: inAppPurchaseController),
          Provider<SettingsController>(
            lazy: false,
            create: (context) => SettingsController(
              persistence: settingsPersistence,
            )..loadStateFromPersistence(),
          ),
          ProxyProvider2<SettingsController, ValueNotifier<AppLifecycleState>,
              AudioController>(
            lazy: false,
            create: (context) => AudioController()..initialize(),
            update: (context, settings, lifecycleNotifier, audio) {
              if (audio == null) throw ArgumentError.notNull();
              audio.attachSettings(settings);
              audio.attachLifecycleNotifier(lifecycleNotifier);
              return audio;
            },
            dispose: (context, audio) => audio.dispose(),
          ),
        ],
        child: Builder(builder: (context) {
          return MaterialApp.router(
            title: 'Block crusher',
            debugShowCheckedModeBanner: false,
            debugShowMaterialGrid: false,
            showSemanticsDebugger: false,
            theme: ThemeData(
              textTheme: const TextTheme(
                bodyMedium: TextStyle(
                  fontFamily: 'Quikhand',
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: Colors.transparent),
                  ),
                  backgroundColor: Colors.black.withOpacity(0.5),
                  foregroundColor: Colors.white,
                 // fixedSize: const Size(300, 60),
                  textStyle: const TextStyle(
                      fontFamily: 'Quikhand',
                      fontSize: 25,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            routeInformationProvider: _router.routeInformationProvider,
            routeInformationParser: _router.routeInformationParser,
            routerDelegate: _router.routerDelegate,
            scaffoldMessengerKey: scaffoldMessengerKey,
          );
        }),
      ),
    );
  }
}
