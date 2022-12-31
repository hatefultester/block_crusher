import 'dart:async';

import 'package:block_crusher/src/audio/audio_controller.dart';
import 'package:block_crusher/src/audio/sounds.dart';
import 'package:block_crusher/src/play_session/flame_part/components/block_component.dart';
import 'package:block_crusher/src/play_session/flame_part/game.dart';
import 'package:block_crusher/src/play_session/flame_part/components/sprite_block_component.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

enum GameMode {
  dumb,
  colorful,
  spriteColorful;
}

class GameController extends GetxController {
  static GameController get to => Get.find();

  static final _log = Logger('GameController');

  final GameMode gameMode = GameMode.spriteColorful;

  BuildContext? context;

  final double defaultBlockFallSpeed = 1.0;
  final int defaultTickSpeed = 150;
  final int defaultGameScore = 0;
  final int defaultLives = 10;

  RxDouble blockFallSpeed = 1.0.obs;
  RxInt tickSpeed = 150.obs;
  RxInt gameScore = 0.obs;
  RxInt lives = 10.obs;
  RxInt bestScore = 0.obs;

  RxBool gameIsRunning = false.obs;
  RxBool loading = true.obs;

  late Timer timer;
  late BlockCrusherGame game;

  int tickCounter = 0;

  @override
  onInit() {
    super.onInit();
    _initGame();
    _startTimer();
    loading.value = false;
  }

  _initGame() {
    _log.info('Initializing flame game');
    game = BlockCrusherGame();
  }

  _startTimer() async {
    _log.info('Initializing timer');

    timer = Timer.periodic(
      const Duration(milliseconds: 20),
      (timer) async {
        if (gameIsRunning.value) {
          tickCounter++;
          if (tickCounter == tickSpeed.value) {
            tickCounter = 0;
            addNewBlock();
          }
        }
      },
    );
  }

  startGame() {
    _log.info('GameIsRunning Value set : TRUE');
    gameIsRunning.value = true;
  }

  endGame() async {
    _log.info('GameIsRunning Value set : FALSE');
    gameIsRunning.value = false;

    await _bestScoreCheck();
    await _resetGameItems();
    await _resetGameVariables();
  }

  _bestScoreCheck() async {
    if (bestScore.value < gameScore.value) {
      bestScore.value = gameScore.value;
    }
  }

  _resetGameItems() async {
    await Future<void>.delayed(Duration(seconds: 2));
    final allPositionComponents = game.children.query<SpriteBlockComponent>();
    game.removeAll(allPositionComponents);
  }

  _resetGameVariables() async {
    _log.info('Reseting Game Variables');
    blockFallSpeed.value = defaultBlockFallSpeed;
    tickSpeed.value = defaultTickSpeed;
    gameScore.value = defaultGameScore;
    lives.value = defaultLives;
  }

  addNewBlock() async {
    await game.add(SpriteBlockComponent());
  }

  collisionDetected() {
    if (context != null) {
      final audioController = context!.read<AudioController>();
      audioController.playSfx(SfxType.wssh);
    }

    _scoreIncrease();
  }

  _scoreIncrease() {
    gameScore.value = gameScore.value + 1;
  }

  blockRemoved() {
    lives.value = lives.value - 1;

    if (lives <= 0) {
      endGame();
    }
  }

  _dumbLevelIncreasmentFunction() {
    if (blockFallSpeed.value < 2) {
      blockFallSpeed.value = blockFallSpeed.value + 0.3;
    } else if (blockFallSpeed.value < 3) {
      blockFallSpeed.value = blockFallSpeed.value + 0.2;
    } else if (blockFallSpeed.value < 2) {
      blockFallSpeed.value = blockFallSpeed.value + 0.1;
    }

    if (tickSpeed.value > 120) {
      tickSpeed.value = tickSpeed.value - 5;
    } else if (tickSpeed.value > 100) {
      tickSpeed.value = tickSpeed.value - 3;
    } else if (tickSpeed.value > 80) {
      tickSpeed.value = tickSpeed.value - 2;
    } else if (tickSpeed.value > 5) {
      tickSpeed.value = tickSpeed.value = tickSpeed.value - 1;
    }
  }

  _dumbBlockAdding() {
    if (gameScore.value > 15) {
      addNewBlock();
    }
    if (gameScore.value > 30) {
      addNewBlock();
    }
    if (gameScore.value > 60) {
      addNewBlock();
    }
    if (gameScore.value > 100) {
      addNewBlock();
    }
  }

  debugButtonTrigger() async {
    await endGame();
  }

  onWin() async {
    endGame();
  }
}
