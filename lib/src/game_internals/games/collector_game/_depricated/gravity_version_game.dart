
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/_depricated/enemy_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/soomy_land/sprite_block_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/collector_game_level_state.dart';
import 'package:block_crusher/src/game_internals/level_logic/levels.dart';
import 'package:block_crusher/src/settings/app_lifecycle/app_lifecycle.dart';
import 'package:block_crusher/src/settings/audio/audio_controller.dart';
import 'package:block_crusher/src/settings/audio/sounds.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';


import 'dart:async' as dart_async;


const double defaultBlockFallSpeed = 0.7;
const double advancedBlockFallSpeed = 0.9;
const double jediBlockFallSpeed = 1.2;
const int defaultTickSpeed = 150;

class BlockCrusherGravityGame extends FlameGame
    with HasCollisionDetection, HasDraggables, HasTappables {
  final Logger _log = Logger('BlockCrusherGravityGame');
  final LevelDifficulty difficulty;

  late BuildContext context;
  late CollectorGameLevelState state;

  dart_async.Timer? _timer;

  late int _tickCounter;
  late double _blockFallSpeed;

  double get blockFallSpeed => _blockFallSpeed;

  late int _tickSpeed;
  late int _generatedCounter;

  BlockCrusherGravityGame(this.difficulty) : super();

  BlockCrusherGravityGame setGame(
      BuildContext context, CollectorGameLevelState state) {
    this.context = context;
    this.state = state;

    return this;
  }

  _setVariables() {
    if (difficulty.atLeast(LevelDifficulty.seaLand)) {
      if (difficulty.atLeast(LevelDifficulty.blueWorld)) {
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
  }

  addDefaultBlock() async {
    if (state.goal - 1 > 0) {
      await add(SpriteBlockComponent.withLevelSet(state.goal - 1, difficulty));
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
    _timer = dart_async.Timer.periodic(const Duration(milliseconds: 15),
        (timer) async {
      if (!(AppLifecycleObserver.appState == AppLifecycleState.paused)) {
        _tickCounter++;
        if (_tickCounter == _tickSpeed) {
          _tickCounter = 0;
          _generatedCounter++;

          await add(SpriteBlockComponent(difficulty));

          if (_generatedCounter % 4 == 0 &&
              difficulty.atLeast(LevelDifficulty.seaLand)) {
            await add(EnemyComponent.randomDirection(
                !difficulty.atLeast(LevelDifficulty.cityLand)));
          }

          if ((difficulty.atLeast(LevelDifficulty.hoomyLand) &&
                  _generatedCounter.floor().isEven) ||
              difficulty.atLeast(LevelDifficulty.seaLand)) {
            await add(
                SpriteBlockComponent.withDirection(Direction.up, difficulty));
          }

          if (difficulty.atLeast(LevelDifficulty.cityLand) &&
              _generatedCounter.floor().isEven) {
            await add(
                SpriteBlockComponent.withDirection(Direction.left, difficulty));
          }
          if (difficulty.atLeast(LevelDifficulty.cityLand) &&
              _generatedCounter.floor().isOdd) {
            await add(SpriteBlockComponent.withDirection(
                Direction.right, difficulty));
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

    await addDefaultBlock();

    _startTimer();
  }
}
