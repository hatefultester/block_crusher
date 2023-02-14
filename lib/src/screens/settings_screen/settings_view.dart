import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../settings/audio/audio_controller.dart';
import '../../settings/audio/sounds.dart';
import '../../settings/settings.dart';
import '../../storage/game_achievements/achievements.dart';
import '../../storage/game_achievements/game_achievements.dart';
import '../../storage/level_statistics/level_statistics.dart';
import '../../storage/player_inventory/player_inventory.dart';
import '../../storage/treasure_counts/treasure_counter.dart';
import '../../storage/worlds_unlock_status/world_unlock_manager.dart';
import '../../style/custom_snack_bars/game_achievement_snack_bar.dart';
import '../../style/custom_snack_bars/info_snack_bar.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 50);
    final settings = context.watch<SettingsController>();

    return Column(
      children: [
        const _Title(),
        gap,
        ValueListenableBuilder<bool>(
          valueListenable: settings.soundsOn,
          builder: (context, soundsOn, child) => _SettingsLine(
            title: 'Sound FX',
            path: 'assets/images/in_app/note.png',
            on: soundsOn,
            onSelected: () {
              context.read<AudioController>().playSfx(SfxType.buttonTap);
              showInfoMessageSnackBar(
                 soundsOn ? 'Sounds turned off' : 'Sounds turned on', 'Approved');
              settings.toggleSoundsOn();

            },
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: settings.musicOn,
          builder: (context, musicOn, child) => _SettingsLine(
              title: 'Music',
              path: 'assets/images/in_app/note.png',
              on: musicOn,
              onSelected: () {
                context.read<AudioController>().playSfx(SfxType.buttonTap);
                showInfoMessageSnackBar(
                    musicOn ? 'Music turned off' : 'Music turned on', 'Approved');
                settings.toggleMusicOn();
              }),
        ),


        _SettingsLine(
          title: 'Reset progress',
          path: 'assets/images/in_app/trash.png',
          onSelected: () {
            context.read<AudioController>().playSfx(SfxType.buttonTap);
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                        'Are you sure that you want to reset all your game progress?'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: const <Widget>[
                          Text('This action can\'t be returned.'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Dismiss'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Approve'),
                        onPressed: () {
                          if (!kDebugMode) {
                            context.read<TreasureCounter>().reset();
                          }
                          context.read<LevelStatistics>().reset();
                          context.read<GameAchievements>().reset();
                          context.read<WorldUnlockManager>().reset();
                          context.read<PlayerInventory>().reset();

                          showInfoMessageSnackBar(
                              'All your progress was reset', 'Approved');
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
          },
        ),

        Visibility(
          visible: kDebugMode,
          child: _SettingsLine(
            title: 'CHEAT',
            path: 'assets/images/in_app/neutral_smile.png',
            onSelected: () {
              context.read<AudioController>().playSfx(SfxType.buttonTap);
              context.read<TreasureCounter>().cheat();
              context.read<LevelStatistics>().cheat();
              context.read<WorldUnlockManager>().cheat();
              context.read<GameAchievements>().cheat();

              showAchievementSnackBar(GameAchievement.connectTwoPlayers);
            },
          ),
        ),
        gap,
        const Spacer(),
        const _BackButton(),
        const Spacer(),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 75,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Center(
          child: Text(
            'Back',
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
              colors: [
                Colors.black,
                Colors.black.withOpacity(0.8),
                Colors.black.withOpacity(0.4)
              ]),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(60),
            bottomRight: Radius.circular(60),
          )),
      width: double.infinity, height: 150,
      // margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Text(
          'Settings'.toUpperCase(),
          style: const TextStyle(
            fontSize: 55,
            letterSpacing: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _SettingsLine extends StatelessWidget {
  final String title;

  final String path;

  final VoidCallback? onSelected;

  final bool on;

  const _SettingsLine({
    this.onSelected,
    required this.title,
    required this.path,
    this.on = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: InkResponse(
        highlightShape: BoxShape.rectangle,
        onTap: onSelected,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black, Colors.black.withOpacity(0.4)]),
              borderRadius: BorderRadius.circular(70),
            ),
            padding: const EdgeInsets.only(left: 20, right: 20),
            margin: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      wordSpacing: 2,
                      color: Colors.white,
                    )),
                const Spacer(),
                SizedBox(
                  height: 60,
                  width: 60,
                  child: Stack(
                    children: [
                      Image.asset(path),
                      Visibility(
                        visible: !on,
                        child: CustomPaint(
                          size: const Size(60, 60),
                          painter: _CustomOffPainter(),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomOffPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const p1 = Offset(5, 5);
    final p2 = Offset(size.width - 5, size.height - 5);
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4;

    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// Consumer<InAppPurchaseController?>(
//     builder: (context, inAppPurchase, child) {
//       if (inAppPurchase == null) {
//         // In-app purchases are not supported yet.
//         // Go to lib/main.dart and uncomment the lines that create
//         // the InAppPurchaseController.
//         return const SizedBox.shrink();
//       }
//
//       Widget icon;
//       VoidCallback? callback;
//       if (inAppPurchase.adRemoval.active) {
//         icon = const Icon(Icons.check);
//       } else if (inAppPurchase.adRemoval.pending) {
//         icon = const CircularProgressIndicator();
//       } else {
//         icon = const Icon(Icons.ad_units);
//         callback = () {
//           inAppPurchase.buy();
//         };
//       }
//       return _SettingsLine(
//         'Remove ads',
//         icon,
//         onSelected: callback,
//       );
//     }),