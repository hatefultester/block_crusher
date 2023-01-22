import 'dart:math';

import 'package:block_crusher/src/app_lifecycle/app_lifecycle.dart';
import 'package:block_crusher/src/game_internals/collector_game/game_components/city_land/eye_enemy_component.dart';
import 'package:block_crusher/src/game_internals/collector_game/game_components/city_land/tray_component.dart';
import 'package:block_crusher/src/game_internals/collector_game/game_components/hoomy_land/hoomy_weapon_component.dart';
import 'package:block_crusher/src/game_internals/collector_game/game_components/purple_land/purple_centered_component.dart';
import 'package:block_crusher/src/game_internals/collector_game/game_components/purple_land/purple_component.dart';
import 'package:block_crusher/src/game_internals/collector_game/game_components/shark_land/shark_enemy_component.dart';
import 'package:block_crusher/src/game_internals/collector_game/game_components/soomy_land/sprite_block_component.dart';
import 'package:block_crusher/src/game_internals/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/level_selection/level_states/collector_game_level_state.dart';
import 'package:block_crusher/src/level_selection/levels.dart';
import 'package:block_crusher/src/utils/maps.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../audio/audio_controller.dart';
import '../../audio/sounds.dart';

import 'dart:async' as dart_async;

import '../../firebase/firebase.dart';


class BlockCrusherGame extends FlameGame
    with HasCollisionDetection, HasDraggables, HasTappables {

  final LevelDifficulty difficulty;
  GameMode gameMode = GameMode.classic;

  late BuildContext context;
  late CollectorGameLevelState state;

  dart_async.Timer? _timer;

  late int _tickCounter;
  late int _tickSpeed;
  late int _generatedCounter;

  late double _blockFallSpeed;
  double get blockFallSpeed => _blockFallSpeed;

  late int foodIndex;
  late int maxCharacterIndex;

  late EnemyHoomyComponent enemyHoomyComponent;

  List<PurpleWorldComponent> purpleWorldComponents = [];

  bool generateCharacterFromLastLevel;
  bool hasSpecialEvents;
  bool hasDifferentStartingBlock;

  BlockCrusherGame(this.difficulty, {this.hasDifferentStartingBlock = false, this.generateCharacterFromLastLevel = false, this.hasSpecialEvents = false}) : super();

  BlockCrusherGame setGame(
      BuildContext context, CollectorGameLevelState state) {

    this.context = context;
    this.state = state;

    foodIndex = state.characterId - 1;
    maxCharacterIndex = state.items.length;
    if (maxCharacterIndex > 2) maxCharacterIndex = 2;

    return this;
  }

  _setVariables() {
    switch(gameMode) {

      case GameMode.classic:
        hasDifferentStartingBlock = false;
        hasSpecialEvents = false;
        generateCharacterFromLastLevel = true;
        _blockFallSpeed = FirebaseService.to.getDefaultBlockFallbackSpeed();
        _tickSpeed = FirebaseService.to.getDefaultTickSpeed();
        break;
      case GameMode.hoomy:
        hasDifferentStartingBlock = false;
        hasSpecialEvents = true;
        generateCharacterFromLastLevel = false;
        _blockFallSpeed = FirebaseService.to.getHoomyBlockFallbackSpeed();
        _tickSpeed = FirebaseService.to.getHoomyTickSpeed();
        break;
      case GameMode.sharks:
        hasDifferentStartingBlock = false;
        hasSpecialEvents = true;
        generateCharacterFromLastLevel = false;
        _blockFallSpeed = FirebaseService.to.getSharkBlockFallbackSpeed();
        _tickSpeed = FirebaseService.to.getSharkTickSpeed();
        break;
      case GameMode.cityFood:
        hasDifferentStartingBlock = true;
        hasSpecialEvents = true;
        generateCharacterFromLastLevel = false;
        _blockFallSpeed = FirebaseService.to.getCityBlockFallbackSpeed();
        _tickSpeed = FirebaseService.to.getCityTickSpeed();
        break;
      case GameMode.purpleWorld:
        hasDifferentStartingBlock = true;
        hasSpecialEvents = true;
        generateCharacterFromLastLevel = false;
        _blockFallSpeed = FirebaseService.to.getPurpleBlockFallbackSpeed();
        _tickSpeed = FirebaseService.to.getPurpleTickSpeed();
        break;
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
      case LevelDifficulty.purpleWorld:
        gameMode = GameMode.purpleWorld;
        mapPath = gameMaps['purple']!;
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
      enemyHoomyComponent = EnemyHoomyComponent();
      await add(enemyHoomyComponent);
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

    if(gameMode == GameMode.purpleWorld) {
      await add(PurpleCenteredComponent());
    }

    //debugCheating();

    if(generateCharacterFromLastLevel) {
      await addDefaultBlock();
    }

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

    _timer = dart_async.Timer.periodic(const Duration(milliseconds: 15),
        (timer) async {

      if(AppLifecycleObserver.appState == AppLifecycleState.paused) return;

      _tickCounter++;

      if (_tickCounter != _tickSpeed) return;
      _tickCounter = 0;
      _generatedCounter++;

      if(hasDifferentStartingBlock) {
        if(gameMode == GameMode.cityFood) {
          await add(SpriteBlockComponent.withLevelSet(
              _generatedIndexNumber(random), difficulty),);
        }

        if(gameMode == GameMode.purpleWorld) {
          final PurpleWorldComponent newPurpleComponent = PurpleWorldComponent(_generatedIndexNumber(random));
          await add(newPurpleComponent);
          purpleWorldComponents.add(newPurpleComponent);
        }
      } else {
        await add(SpriteBlockComponent(difficulty));
      }

      /// special events
      if(!hasSpecialEvents) return;
      if(_generatedCounter % 2 != 0) return;

      if (gameMode == GameMode.hoomy) {
        await add(HoomyWeaponComponent());
      }

      if (gameMode == GameMode.sharks) {
        await add(SharkEnemyComponent());
      }
    });
  }

  _generatedIndexNumber(Random random) {
    int generatedIndexNumber = 0;
    if(gameMode == GameMode.cityFood) {
      if (maxCharacterIndex != 0) {
        generatedIndexNumber = random.nextInt(maxCharacterIndex);
      } else {
        generatedIndexNumber = 0;
      }
      //debugPrint('debug gen: $generatedIndexNumber');
      if (generatedIndexNumber > 0) {
        generatedIndexNumber = random.nextInt(maxCharacterIndex);
        if (generatedIndexNumber > 1) {
          generatedIndexNumber = random.nextInt(maxCharacterIndex);
        }
      }
    }

    if(gameMode == GameMode.purpleWorld) {
      generatedIndexNumber = random.nextInt(4) + 1;
    }

    return generatedIndexNumber;
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

  splitPurpleComponent(PurpleWorldComponent component, NotifyingVector2 position) async {
    print(component.lives);
    if(component.lives == 0) return;

    var purpleComponentCopy = PurpleWorldComponent.copyFrom(component, Vector2(position.x, position.y));
    await add(purpleComponentCopy);
    purpleWorldComponents.add(purpleComponentCopy);

  }

  purpleComponentDestroyed(PurpleWorldComponent component) {

  }

  @override
  void onRemove() {
    super.onRemove();

    _timer?.cancel();
    debugPrint('game was stopped');
  }
}
