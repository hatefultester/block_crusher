import 'package:block_crusher/router.dart';
import 'package:block_crusher/src/services/ads_controller.dart';
import 'package:block_crusher/src/services/app_lifecycle.dart';
import 'package:block_crusher/src/services/audio_controller.dart';
import 'package:block_crusher/src/services/games_services.dart';
import 'package:block_crusher/src/services/in_app_purchase.dart';
import 'package:block_crusher/src/services/remote_config.dart';
import 'package:block_crusher/src/storage/game_achievements.dart';
import 'package:block_crusher/src/storage/level_statistics.dart';
import 'package:block_crusher/src/storage/persistence/game_achievements_persistence.dart';
import 'package:block_crusher/src/storage/persistence/level_statistics_persistence.dart';
import 'package:block_crusher/src/storage/persistence/player_inventory_persistence.dart';
import 'package:block_crusher/src/storage/persistence/settings_persistence.dart';
import 'package:block_crusher/src/storage/persistence/treasure_counter_persistence.dart';
import 'package:block_crusher/src/storage/persistence/world_unlock_manager_persistence.dart';
import 'package:block_crusher/src/storage/player_inventory.dart';
import 'package:block_crusher/src/storage/settings.dart';
import 'package:block_crusher/src/storage/treasure_counter.dart';
import 'package:block_crusher/src/storage/world_unlock_manager.dart';
import 'package:block_crusher/src/utils/scaffold_key.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
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
    super.key,
    required this.playerInventoryPersistence,
    required this.gameAchievementsPersistence,
    required this.levelStatisticsPersistence,
    required this.treasureCounterPersistence,
    required this.worldUnlockManagerPersistence,
  });

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<RemoteConfigProvider>(
              lazy: false,
              create: (context) {
                var remoteConfig = RemoteConfigProvider();
                remoteConfig.init();
                return remoteConfig;
              }),
          ChangeNotifierProvider<PlayerInventory>(
            lazy: false,
            create: (context) {
              var progress = PlayerInventory(playerInventoryPersistence);
              progress.getLatestFromStore();
              return progress;
            },
          ),
          ChangeNotifierProvider<GameAchievements>(
            lazy: false,
            create: (context) {
              var progress = GameAchievements(gameAchievementsPersistence);
              progress.getLatestFromStore();
              return progress;
            },
          ),
          ChangeNotifierProvider<LevelStatistics>(
            lazy: false,
            create: (context) {
              var progress = LevelStatistics(levelStatisticsPersistence);
              progress.getLatestFromStore();
              return progress;
            },
          ),
          ChangeNotifierProvider<TreasureCounter>(
            lazy: false,
            create: (context) {
              var progress = TreasureCounter(treasureCounterPersistence);
              progress.getLatestFromStore();
              return progress;
            },
          ),
          ChangeNotifierProvider<WorldUnlockManager>(
            lazy: false,
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
            theme: themeData,
            routeInformationProvider: router.routeInformationProvider,
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
            scaffoldMessengerKey: scaffoldMessengerKey,
          );
        }),
      ),
    );
  }
}

ThemeData themeData = ThemeData(
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
          fontFamily: 'Quikhand', fontSize: 25, fontWeight: FontWeight.w600),
    ),
  ),
);
