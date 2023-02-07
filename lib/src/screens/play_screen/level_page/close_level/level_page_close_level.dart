import 'package:block_crusher/src/google_play/remote_config/remote_config.dart';
import 'package:block_crusher/src/helpers/extensions/level_open_coin_price_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../game_internals/level_logic/level_states/collector_game/world_type.dart';
import '../../../../settings/audio/audio_controller.dart';
import '../../../../settings/audio/sounds.dart';
import '../../../../storage/treasure_counts/treasure_counter.dart';
import '../../../../style/confetti.dart';


const _celebrationDuration = Duration(milliseconds: 2000);
const _preCelebrationDuration = Duration(milliseconds: 200);

class LevelPageCloseLevel extends StatefulWidget {
  final WorldType levelDifficulty;
  final String title;
  final Function onBuy;
  final Function onError;

  const LevelPageCloseLevel({super.key, required this.levelDifficulty, required this.onBuy, required this.onError, required this.title});

  @override
  State<LevelPageCloseLevel> createState() =>
      _LevelPageCloseLevelState();
}

class _LevelPageCloseLevelState
    extends State<LevelPageCloseLevel> {
  bool duringCelebration = false;

  @override
  Widget build(BuildContext context) {
    final RemoteConfigProvider remoteConfig =
        context.read<RemoteConfigProvider>();

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.5),
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
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.rotate(
                          angle: 0.05,
                          child: SizedBox(width: 50, height: 50, child: duringCelebration ?
                          Image.asset('assets/images/lock/lock_unlocked.png') : Image.asset('assets/images/lock/lock_locked.png'),),
                        ),
                        const SizedBox(width: 10),
                         Text(
                            widget.title.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 35, color: Colors.black),
                          ),
                        const SizedBox(width: 10),
                        Transform.rotate(
                          angle: -0.05,
                          child: SizedBox(width: 50, height: 50, child: duringCelebration ?
                          Image.asset('assets/images/lock/lock_unlocked.png'): Image.asset('assets/images/lock/lock_locked.png'),),
                        ),
                      ],
                    ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.levelDifficulty
                              .coinPrice(remoteConfig)
                              .toString(),
                          style: const TextStyle(
                              fontSize: 30, color: Colors.black),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 30,
                          height: 30,
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
                          _handleBuyButton();
                        },
                        child: const Center(
                          child: Text(
                            'B U Y',
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
        Visibility(
          visible: duringCelebration,
          child: IgnorePointer(
            child: Confetti(
              isStopped: !duringCelebration,
            ),
          ),
        ),
      ],
    );
  }

  bool _canBeAffordedByPlayer() {
      final treasureCounter = context.read<TreasureCounter>();
      final remoteConfig = context.read<RemoteConfigProvider>();
      return treasureCounter.coinCount >= widget.levelDifficulty.coinPrice(remoteConfig);
  }

  _playCelebration() async {
    await Future<void>.delayed(_preCelebrationDuration);
    if (!mounted) return;
    setState(() {
      duringCelebration = true;
    });
    await Future<void>.delayed(_celebrationDuration);
  }

  _handleBuyButton() async {
    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.buttonTap);

    if (_canBeAffordedByPlayer()) {
      widget.onBuy(_celebrationDuration + _preCelebrationDuration);
      await _playCelebration();
    } else {
      widget.onError();
    }
  }
}
