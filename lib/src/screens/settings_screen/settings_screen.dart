
import 'package:block_crusher/src/google_play/in_app_purchase/in_app_purchase.dart';
import 'package:block_crusher/src/screens/settings_screen/settings_background.dart';
import 'package:block_crusher/src/storage/game_achievements/achievements.dart';
import 'package:block_crusher/src/storage/game_achievements/game_achievements.dart';
import 'package:block_crusher/src/storage/level_statistics/level_statistics.dart';
import 'package:block_crusher/src/storage/player_inventory/player_inventory.dart';
import 'package:block_crusher/src/storage/treasure_counts/treasure_counter.dart';
import 'package:block_crusher/src/storage/worlds_unlock_status/world_unlock_manager.dart';
import 'package:block_crusher/src/style/custom_snackbars/snack_bar.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../style/palette.dart';
import '../../style/responsive_screen.dart';
import '../../settings/custom_name_dialog.dart';
import '../../settings/settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _gap = SizedBox(height: 60);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: SettingsBackground()),
          ResponsiveScreen(
            squarishMainArea: ListView(
              children: [
                _gap,
                const Text(
                  'S e t t i n g s',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 55,
                    height: 1,
                  ),
                ),
                _gap,
                const _NameChangeLine(
                  'Name',
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: settings.soundsOn,
                  builder: (context, soundsOn, child) => _SettingsLine(
                    'Sound FX',
                    Icon(soundsOn ? Icons.graphic_eq : Icons.volume_off),
                    onSelected: () => settings.toggleSoundsOn(),
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: settings.musicOn,
                  builder: (context, musicOn, child) => _SettingsLine(
                    'Music',
                    Icon(musicOn ? Icons.music_note : Icons.music_off),
                    onSelected: () => settings.toggleMusicOn(),
                  ),
                ),
                Consumer<InAppPurchaseController?>(
                    builder: (context, inAppPurchase, child) {
                  if (inAppPurchase == null) {
                    // In-app purchases are not supported yet.
                    // Go to lib/main.dart and uncomment the lines that create
                    // the InAppPurchaseController.
                    return const SizedBox.shrink();
                  }

                  Widget icon;
                  VoidCallback? callback;
                  if (inAppPurchase.adRemoval.active) {
                    icon = const Icon(Icons.check);
                  } else if (inAppPurchase.adRemoval.pending) {
                    icon = const CircularProgressIndicator();
                  } else {
                    icon = const Icon(Icons.ad_units);
                    callback = () {
                      inAppPurchase.buy();
                    };
                  }
                  return _SettingsLine(
                    'Remove ads',
                    icon,
                    onSelected: callback,
                  );
                }),
                _SettingsLine(
                  'Reset progress',
                  const Icon(Icons.delete),
                  onSelected: () {
                    //context.read<TreasureCounter>().reset();
                    context.read<LevelStatistics>().reset();
                    context.read<GameAchievements>().reset();
                    context.read<WorldUnlockManager>().reset();
                    context.read<PlayerInventory>().reset();

                    achievementSnackBar(GameAchievement.firstPurchase);
                  },
                ),_SettingsLine(
                  'CHEAT',
                  const Icon(Icons.delete),
                  onSelected: () {
                    context.read<TreasureCounter>().cheat();
                    context.read<LevelStatistics>().cheat();
                    context.read<WorldUnlockManager>().cheat();
                    context.read<GameAchievements>().cheat();

                    achievementSnackBar(GameAchievement.connectTwoPlayers);
                  },
                ),
                _gap,
              ],
            ),
            rectangularMenuArea: ElevatedButton(
              onPressed: () {
                GoRouter.of(context).pop();
              },
              child: const Text('Back'),
            ),
          ),
        ],
      ),
    );
  }
}

class _NameChangeLine extends StatelessWidget {
  final String title;

  const _NameChangeLine(this.title);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return InkResponse(
      highlightShape: BoxShape.rectangle,
      onTap: () => showCustomNameDialog(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [
                Colors.white, Colors.white.withOpacity(0.4)
              ]),
                borderRadius: BorderRadius.circular(70),),

              padding: EdgeInsets.all(5),
              child: Text(title,
                  style: const TextStyle(
                    fontSize: 30,
                  )),
            ),
            const Spacer(),
            ValueListenableBuilder(
              valueListenable: settings.playerName,
              builder: (context, name, child) => Container(
                decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [
                  Colors.white, Colors.white.withOpacity(0.4)
                ]),
                  borderRadius: BorderRadius.circular(70),),
                padding: EdgeInsets.all(5),
                child: Text(
                  '‘$name’',
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.black
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsLine extends StatelessWidget {
  final String title;

  final Widget icon;

  final VoidCallback? onSelected;

  const _SettingsLine(this.title, this.icon, {this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: InkResponse(
        highlightShape: BoxShape.rectangle,
        onTap: onSelected,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [
                  Colors.white, Colors.white.withOpacity(0.4)
                ]),
                  borderRadius: BorderRadius.circular(70),),

                padding: EdgeInsets.all(5),
                child: Text(title,
                    style: const TextStyle(
                      fontSize: 30,
                    )),
              ),
              const Spacer(),
              Container(
                  decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [
                    Colors.white, Colors.white.withOpacity(0.4)
                  ]),
                  borderRadius: BorderRadius.circular(70),
                  ),
                  padding: EdgeInsets.all(5),
                  child: icon),
            ],
          ),
        ),
      ),
    );
  }
}
