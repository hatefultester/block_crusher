import 'dart:async';

import 'package:block_crusher/src/game/components/block_component.dart';
import 'package:block_crusher/src/game/game.dart';
import 'package:block_crusher/src/game/components/sprite_block_component.dart';
import 'package:flame/game.dart';
import 'package:get/get.dart';

enum GameMode {
  dumb,
  colorful,
  spriteColorful;
}

class GameController extends GetxController {
  static GameController get to => Get.find();

  final GameMode gameMode = GameMode.spriteColorful;

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

  @override
  onInit() {
    super.onInit();
    game = BlockCrusherGame();
    startTimer();
    loading.value = false;
  }

  startGame() {
    gameIsRunning.value = true;
  }

  endGame() async {
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
    final allPositionComponents = game.children.query<BlockComponent>();
    game.removeAll(allPositionComponents);
  }

  _resetGameVariables() async {
    blockFallSpeed.value = defaultBlockFallSpeed;
    tickSpeed.value = defaultTickSpeed;
    gameScore.value = defaultGameScore;
    lives.value = defaultLives;
  }

  startTimer() async {
    int tickCounter = 0;

    timer = Timer.periodic(
      const Duration(milliseconds: 20),
      (timer) async {
        if (gameIsRunning.value) {
          tickCounter++;
          if (tickCounter == tickSpeed.value) {
            tickCounter = 0;
            addNewBlock();

            switch (gameMode) {
              case GameMode.dumb:
                _dumbBlockAdding();
                break;
              default:
                return;
            }
          }
        }
      },
    );
  }

  addNewBlock() async {
    switch (gameMode) {
      case GameMode.dumb:
      case GameMode.colorful:
        await game.add(
          BlockComponent.relative(
            [
              Vector2(10, 10),
              Vector2(10, 5),
              Vector2(5, 5),
              Vector2(5, 10),
            ],
            parentSize: Vector2(20, 20),
          ),
        );
        break;
      case GameMode.spriteColorful:
        await game.add(SpriteBlockComponent());
        break;
    }
  }

  collisionDetected() {
    gameScore.value = gameScore.value + 1;

    switch (gameMode) {
      case GameMode.dumb:
        _dumbLevelIncreasmentFunction();
        break;
      default:
        return;
    }
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
}
