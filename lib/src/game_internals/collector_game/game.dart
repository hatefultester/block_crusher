import 'dart:math';

import 'package:block_crusher/src/app_lifecycle/app_lifecycle.dart';
import 'package:block_crusher/src/game_internals/collector_game/components/enemy_component.dart';
import 'package:block_crusher/src/game_internals/collector_game/components/eye_enemy_component.dart';
import 'package:block_crusher/src/game_internals/collector_game/components/hoomy_weapon_component.dart';
import 'package:block_crusher/src/game_internals/collector_game/components/shark_enemy_component.dart';
import 'package:block_crusher/src/game_internals/collector_game/components/tray_component.dart';
import 'package:block_crusher/src/level_selection/level_states/collector_game_level_state.dart';
import 'package:block_crusher/src/level_selection/levels.dart';
import 'package:block_crusher/src/utils/maps.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../../audio/audio_controller.dart';
import '../../audio/sounds.dart';

import 'dart:async' as dart_async;

import '../../firebase/firebase.dart';
import 'components/sprite_block_component.dart';

enum GameMode {
  classic,
  hoomy,
  sharks,
  cityFood,
}

class BlockCrusherGame extends FlameGame
    with HasCollisionDetection, HasDraggables, HasTappables {
  final Logger _log = Logger('BlockCrusherGame');
  final LevelDifficulty difficulty;

  late BuildContext context;
  late CollectorGameLevelState state;

  dart_async.Timer? _timer;

  late int _tickCounter;
  late double _blockFallSpeed;

  double get blockFallSpeed => _blockFallSpeed;

  GameMode gameMode = GameMode.classic;

  late int _tickSpeed;
  late int _generatedCounter;

  late int foodIndex;
  late int maxCharacterIndex;

  late EnemyHoomyComponent enemyHoomik;

  BlockCrusherGame(this.difficulty) : super();

  BlockCrusherGame setGame(
      BuildContext context, CollectorGameLevelState state) {
    this.context = context;
    this.state = state;
    foodIndex = state.characterId - 1;
    maxCharacterIndex = state.items.length;
    print('items lenght ${state.items.length.toString()}');
    if (maxCharacterIndex > 2) maxCharacterIndex = 2;

    return this;
  }

  _setVariables() {

    _blockFallSpeed = FirebaseService.to.getDefaultBlockFallbackSpeed();


    _tickSpeed = FirebaseService.to.getDefaultTickSpeed();

    if (gameMode == GameMode.sharks) {
      _blockFallSpeed += 0.3;
    }

    if (gameMode == GameMode.cityFood) {
      _blockFallSpeed += 0.4;
      _tickSpeed -= 20;
    }

    _tickCounter = 0;
    _generatedCounter = 0;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    String mapPath;

    switch (difficulty) {
      case LevelDifficulty.soomyLand:
        mapPath = gameMaps['brick']!;
        break;
      case LevelDifficulty.hoomyLand:
        gameMode = GameMode.hoomy;
        mapPath = gameMaps['hoomy']!;
        break;
      case LevelDifficulty.seaLand:
        gameMode = GameMode.sharks;
        mapPath = gameMaps['water']!;
        break;
      case LevelDifficulty.cityLand:
        gameMode = GameMode.cityFood;
        mapPath = gameMaps['city']!;
        break;
      case LevelDifficulty.blueWorld:
        mapPath = gameMaps['blue']!;
        break;
      case LevelDifficulty.alienShooter:
        mapPath = gameMaps['mimon']!;
        break;
    }

    _setVariables();

    await add(
      SpriteComponent(
        sprite: await loadSprite(mapPath),
        size: Vector2(size.x, size.y),
      ),
    );

    if (gameMode == GameMode.hoomy) {
      enemyHoomik = EnemyHoomyComponent();
      await add(enemyHoomik);
    }

    if (gameMode == GameMode.cityFood) {
      await add(TrayComponent());
    }

    if (gameMode == GameMode.cityFood) {
      if (state.characterId > 3) {
        await add(
          EyeEnemyComponent.withScaleAndDirection(
              Direction.up, Direction.left, 0.7, 0.65),
        );
        await add(
          EyeEnemyComponent.withScaleAndDirection(
              Direction.down, Direction.right, 0.65, 0.7),
        );
      } else {
        await add(
          EyeEnemyComponent(),
        );
      }
    }

    //debugCheating();

    await addDefaultBlock();

    if (_timer == null) {
      _startTimer();
    }
  }

  debugCheating() async {
    await add(
        SpriteBlockComponent.withLevelSet(state.characterId - 1, difficulty));
    await add(
        SpriteBlockComponent.withLevelSet(state.characterId - 1, difficulty));
  }

  addDefaultBlock() async {
    if (difficulty == LevelDifficulty.soomyLand) {
      if (state.goal - 1 > 0) {
        await add(SpriteBlockComponent.withLevelSet(
            state.characterId - 1, difficulty));
      }
    }
  }

  void collisionDetected(int level) {
    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.wssh);

    state.setProgress(state.score + 1);

    if (level > state.level && gameMode != GameMode.cityFood) {
      _increaseGameSpeed();
      state.setLevel(level);
    }

    state.evaluate();
  }

  collectedToTray(int level) {
    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.kosik);
    state.collect(level);
    state.evaluate();
  }

  blockRemoved() {
    state.decreaseLife();
    state.evaluate();
  }

  _startTimer() async {
    Random random = Random();

    _log.info('Starting timer');
    _timer = dart_async.Timer.periodic(const Duration(milliseconds: 15),
        (timer) async {
      if (!(AppLifecycleObserver.appState == AppLifecycleState.paused)) {
        _tickCounter++;
        if (_tickCounter == _tickSpeed) {
          _tickCounter = 0;
          _generatedCounter++;

          if (gameMode != GameMode.cityFood) {
            await add(SpriteBlockComponent(difficulty));
          } else {
            int generatedIndexNumber;
            if (maxCharacterIndex != 0) {
              generatedIndexNumber = random.nextInt(maxCharacterIndex);
            } else {
              generatedIndexNumber = 0;
            }
            print('debug gen: $generatedIndexNumber');
            if (generatedIndexNumber > 0) {
              generatedIndexNumber = random.nextInt(maxCharacterIndex);
              if (generatedIndexNumber > 1) {
                generatedIndexNumber = random.nextInt(maxCharacterIndex);
              }
            }
            await add(SpriteBlockComponent.withLevelSet(
                generatedIndexNumber, difficulty));
          }

          if (_generatedCounter % 2 == 0 && gameMode == GameMode.hoomy) {
            await add(HoomyWeaponComponent());
          }
          if (_generatedCounter % 2 == 0 && gameMode == GameMode.sharks) {
            await add(SharkEnemyComponent());
          }

          // if (_generatedCounter % 2 == 0 &&
          //     difficulty.atLeast(LevelDifficulty.seaLand)) {
          //   await add(EnemyComponent.randomDirection(
          //       !difficulty.atLeast(LevelDifficulty.cityLand)));
          // }

          // if ((difficulty.atLeast(LevelDifficulty.hoomyLand) &&
          //         _generatedCounter.floor().isEven) ||
          //     difficulty.atLeast(LevelDifficulty.seaLand)) {
          //   await add(
          //       SpriteBlockComponent.withDirection(Direction.up, difficulty));
          // }

          // if (difficulty.atLeast(LevelDifficulty.cityLand) &&
          //     _generatedCounter.floor().isEven) {
          //   await add(
          //       SpriteBlockComponent.withDirection(Direction.left, difficulty));
          // }
          // if (difficulty.atLeast(LevelDifficulty.cityLand) &&
          //     _generatedCounter.floor().isOdd) {
          //   await add(SpriteBlockComponent.withDirection(
          //       Direction.right, difficulty));
          // }
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
