import 'package:block_crusher/src/google_play/remote_config/remote_config.dart';
import 'package:block_crusher/src/helpers/extensions/level_open_coin_price_helper.dart';
import 'package:block_crusher/src/screens/play_screen/level_page_helper_widgets/level_page.dart';
import 'package:block_crusher/src/settings/audio/audio_controller.dart';
import 'package:block_crusher/src/settings/audio/sounds.dart';
import 'package:block_crusher/src/storage/treasure_counts/treasure_counter.dart';
import 'package:block_crusher/src/storage/worlds_unlock_status/world_unlock_manager.dart';
import 'package:block_crusher/src/style/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _celebrationDuration = Duration(milliseconds: 2000);
const _preCelebrationDuration = Duration(milliseconds: 500);

extension LevelPageViewChildCloseLevelBuilder on LevelPageState {
  buy() async {
    final treasureCounter = context.read<TreasureCounter>();
    final remoteConfig = context.read<RemoteConfigProvider>();

    if (treasureCounter.coinCount <
        widget.levelDifficulty.coinPrice(remoteConfig)) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        const SnackBar(
          content: Text('You don\'t have enough coins :( '),
        ),
      );
      return;
    }

    await Future<void>.delayed(_preCelebrationDuration);
    if (!mounted) return;

    final unlockManager = context.read<WorldUnlockManager>();

    if (!mounted) return;
    setState(() {
      duringCelebration = true;
    });

    await Future<void>.delayed(_celebrationDuration);
    if (!mounted) return;
    setState(() {
      duringCelebration = false;
      opened = true;
    });

    await unlockManager.unlockWorld(widget.levelDifficulty);
    treasureCounter
        .decreaseCoinCount(widget.levelDifficulty.coinPrice(remoteConfig));
  }

  Widget buildCloseLevel(AudioController audioController) {
    final RemoteConfigProvider remoteConfig = context.read<RemoteConfigProvider>();

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.7),
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 350,
              height: 320,
              child: Container(
                width: 250,
                height: 220,
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          widget.levelDifficulty
                              .coinPrice(remoteConfig)
                              .toString(),
                          style: const TextStyle(
                              fontSize: 30, color: Colors.white),
                        ),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.asset(
                              'assets/images/coins/1000x1000/coin.png'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 75,
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () {
                          audioController.playSfx(SfxType.buttonTap);
                          buy();
                        },
                        child: const Center(
                          child: Text(
                            'O P E N',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        duringCelebration
            ? Align(
                alignment: const Alignment(0, -0.7),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.2),
                        spreadRadius: 4,
                        blurRadius: 8,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  width: 150,
                  height: 150,
                  child: Image.asset('assets/images/lock/lock_unlocked.png'),
                ),
              )
            : Align(
                alignment: const Alignment(0, -0.7),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.2),
                        spreadRadius: 4,
                        blurRadius: 8,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  width: 150,
                  height: 150,
                  child: Image.asset('assets/images/lock/lock_locked.png'),
                ),
              ),
        celebrationWidget(),
      ],
    );
  }

  celebrationWidget() {
    return Visibility(
      visible: duringCelebration,
      child: IgnorePointer(
        child: Confetti(
          isStopped: !duringCelebration,
        ),
      ),
    );
  }
}
