import 'package:block_crusher/src/app_lifecycle/app_lifecycle.dart';
import 'package:block_crusher/src/game_internals/components/enemy_component.dart';
import 'package:block_crusher/src/level_selection/level_state.dart';
import 'package:block_crusher/src/level_selection/levels.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';

import 'dart:async' as DartAsync;

import 'components/sprite_block_component.dart';

const double defaultBlockFallSpeed = 0.7;
const double advancedBlockFallSpeed = 0.9;
const double jediBlockFallSpeed = 1.2;
const int defaultTickSpeed = 150;

class BlockCrusherGame extends FlameGame
    with HasCollisionDetection, HasDraggables, HasTappables {
  final Logger _log = Logger('BlockCrusherGame');
  final LevelDifficulty difficulty;

  late BuildContext context;
  late LevelState state;

  DartAsync.Timer? _timer;

  late int _tickCounter;
  late double _blockFallSpeed;

  double get blockFallSpeed => _blockFallSpeed;

  late int _tickSpeed;
  late int _generatedCounter;

  BlockCrusherGame(this.difficulty);

  BlockCrusherGame setGame(BuildContext context, LevelState state) {
    this.context = context;
    this.state = state;

    return this;
  }

  _setVariables() {
    if (difficulty.atLeast(LevelDifficulty.intermediate)) {
      if (difficulty.atLeast(LevelDifficulty.jedi)) {
        _blockFallSpeed = jediBlockFallSpeed;
      } else {
        _blockFallSpeed = advancedBlockFallSpeed;
      }
    } else {
      _blockFallSpeed = defaultBlockFallSpeed;
    }

    _tickSpeed = defaultTickSpeed;
    _tickCounter = 0;
    _generatedCounter = 0;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _setVariables();

    await add(
      SpriteComponent(
        sprite: await loadSprite('background.png'),
        size: Vector2(size.x, size.y),
      ),
    );

    await add(SpriteBlockComponent.withLevelSet(state.goal - 1));

    if (_timer == null) {
      _startTimer();
    }
  }

  void collisionDetected(int level) {
    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.wssh);

    state.setProgress(state.score + 1);

    if (level > state.level) {
      _increaseGameSpeed();
      state.setLevel(level);
    }

    state.evaluate();
  }

  blockRemoved() {
    state.decreaseLife();
    state.evaluate();
  }

  _startTimer() async {
    _log.info('Starting timer');
    _timer = DartAsync.Timer.periodic(const Duration(milliseconds: 15),
        (timer) async {
      if (!(AppLifecycleObserver.appState == AppLifecycleState.paused)) {
        _tickCounter++;
        if (_tickCounter == _tickSpeed) {
          _tickCounter = 0;
          _generatedCounter++;

          await add(SpriteBlockComponent());

          if (_generatedCounter % 4 == 0 &&
              difficulty.atLeast(LevelDifficulty.intermediate)) {
            await add(EnemyComponent.randomDirection(
                !difficulty.atLeast(LevelDifficulty.master)));
          }

          if ((difficulty.atLeast(LevelDifficulty.beginner) &&
                  _generatedCounter.floor().isEven) ||
              difficulty.atLeast(LevelDifficulty.intermediate)) {
            await add(SpriteBlockComponent.withDirection(Direction.up));
          }

          if (difficulty.atLeast(LevelDifficulty.master) &&
              _generatedCounter.floor().isEven) {
            await add(SpriteBlockComponent.withDirection(Direction.left));
          }
          if (difficulty.atLeast(LevelDifficulty.master) &&
              _generatedCounter.floor().isOdd) {
            await add(SpriteBlockComponent.withDirection(Direction.right));
          }
        }
      }
    });
  }

  _increaseGameSpeed() {
    // if (tickSpeed > 100) tickSpeed -= 15;
    // if (tickSpeed > 50) tickSpeed -= 10;
  }

  restartGame() async {
    _timer?.cancel();

    final allPositionComponents = children.query<SpriteBlockComponent>();
    removeAll(allPositionComponents);

    _setVariables();
    state.reset();

    await Future<void>.delayed(const Duration(milliseconds: 500));

    await add(SpriteBlockComponent.withLevelSet(state.goal - 1));

    _startTimer();
  }
}
