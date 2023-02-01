import 'dart:math';

import 'package:block_crusher/src/game_internals/games/collector_game/game_components/alien_world/alien_centered_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/city_land/eye_enemy_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/city_land/tray_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/hoomy_land/hoomy_weapon_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/purple_land/purple_centered_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/purple_math/purple_math_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/shark_land/shark_enemy_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/soomy_land/sprite_block_component.dart';
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/collector_game_level_state.dart';
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/levels.dart';
import 'package:block_crusher/src/google_play/remote_config/remote_config.dart';
import 'package:block_crusher/src/settings/app_lifecycle/app_lifecycle.dart';
import 'package:block_crusher/src/settings/audio/audio_controller.dart';
import 'package:block_crusher/src/settings/audio/sounds.dart';
import 'package:block_crusher/src/storage/game_achievements/game_achievements.dart';
import 'package:block_crusher/src/style/custom_snackbars/snack_bar.dart';
import 'package:block_crusher/src/utils/maps.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:async' as dart_async;

import '../../../storage/game_achievements/achievements.dart';
import '../../level_logic/level_states/collector_game/world_type.dart';
import 'game_components/purple_land/purple_component.dart';
import 'util/collector_game_helper.dart';


class BlockCrusherGame extends FlameGame
    with HasCollisionDetection, HasDraggables, HasTappables {

  final WorldType difficulty;
  GameMode gameMode = GameMode.classic;
  late PurpleMode purpleMode;

  late BuildContext context;
  late CollectorGameLevelState state;

  dart_async.Timer? _timer;

  late int _tickCounter;
  late int _tickSpeed;
  late int _generatedCounter;
  late int _connectCoinCount;

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

        _blockFallSpeed = RemoteConfigService.to.getDefaultBlockFallbackSpeed();
        _tickSpeed = RemoteConfigService.to.getDefaultTickSpeed();
        _connectCoinCount = RemoteConfigService.to.getSoomyLandConnectCoinCount();

        break;
      case GameMode.hoomy:

        hasDifferentStartingBlock = false;
        hasSpecialEvents = true;
        generateCharacterFromLastLevel = false;
        _blockFallSpeed = RemoteConfigService.to.getHoomyBlockFallbackSpeed();
        _tickSpeed = RemoteConfigService.to.getHoomyTickSpeed();
        _connectCoinCount = RemoteConfigService.to.getHoomyLandConnectCoinCount();

        break;
      case GameMode.sharks:
        hasDifferentStartingBlock = false;
        hasSpecialEvents = true;
        generateCharacterFromLastLevel = false;
        _blockFallSpeed = RemoteConfigService.to.getSharkBlockFallbackSpeed();
        _tickSpeed = RemoteConfigService.to.getSharkTickSpeed();
        _connectCoinCount = RemoteConfigService.to.getSharkLandConnectCoinCount();

        break;
      case GameMode.cityFood:
        hasDifferentStartingBlock = true;
        hasSpecialEvents = true;
        generateCharacterFromLastLevel = false;
        _blockFallSpeed = RemoteConfigService.to.getCityBlockFallbackSpeed();
        _tickSpeed = RemoteConfigService.to.getCityTickSpeed();
        _connectCoinCount = RemoteConfigService.to.getCityLandConnectCoinCount();

        break;
      case GameMode.purpleWorld:
        hasDifferentStartingBlock = true;
        hasSpecialEvents = true;
        generateCharacterFromLastLevel = false;
        _blockFallSpeed = RemoteConfigService.to.getPurpleBlockFallbackSpeed();
        _tickSpeed = RemoteConfigService.to.getPurpleTickSpeed();
        _connectCoinCount = RemoteConfigService.to.getPurpleLandConnectCoinCount();

        if (state.characterId == 1) {
          purpleMode = PurpleMode.trippie;
        } else {
          purpleMode = PurpleMode.counter;
        }
        break;
      case GameMode.alien:
        hasDifferentStartingBlock = false;
        hasSpecialEvents = true;
        generateCharacterFromLastLevel = false;
        _blockFallSpeed = RemoteConfigService.to.getAlienBlockFallbackSpeed();
        _tickSpeed = RemoteConfigService.to.getAlienTickSpeed();
        _connectCoinCount = RemoteConfigService.to.getAlienLandConnectCoinCount();

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
      case WorldType.soomyLand:
        mapPath = gameMaps['brick']!;
        break;
      case WorldType.hoomyLand:
        gameMode = GameMode.hoomy;
        mapPath = gameMaps['hoomy']!;
        break;
      case WorldType.seaLand:
        gameMode = GameMode.sharks;
        mapPath = gameMaps['water']!;
        break;
      case WorldType.cityLand:
        gameMode = GameMode.cityFood;
        mapPath = gameMaps['city']!;
        break;
      case WorldType.purpleWorld:
        gameMode = GameMode.purpleWorld;
        mapPath = gameMaps['purple']!;
        break;
      case WorldType.alien:
        gameMode = GameMode.alien;
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
      if(purpleMode == PurpleMode.trippie) {
        await add(PurpleCenteredComponent());
      }
    }

    if(gameMode == GameMode.alien) {
      await add(AlienCenteredComponent());
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
    if (difficulty == WorldType.soomyLand) {
      if (state.goal - 1 > 0) {
        await add(SpriteBlockComponent.withLevelSet(
            state.characterId - 1, difficulty));
      }
    }
  }

  void collisionDetected(int level) {
    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.wssh);
    final achievement = context.read<GameAchievements>();

    if (!achievement.isAchievementOpen(GameAchievement.connectTwoPlayers)) {
      achievement.openNewAchievement(GameAchievement.connectTwoPlayers);
    }

    if (gameMode == GameMode.purpleWorld) {
      if (purpleMode == PurpleMode.counter) {
        if(level == 4) {
          state.increaseCoinCount(_connectCoinCount * 5);
        } else {
          state.increaseCoinCount(_connectCoinCount);
        }
        state.evaluate();
        return;
      }
    }

    print('notRETURNED');
    int extraBonus = 0;

    /// if you get new level you will get double points
    if (state.evaluateScore(level)) {
      extraBonus = _connectCoinCount * level;
    }

    /// based on level you reached you get specific score
    state.increaseCoinCount(level * _connectCoinCount + extraBonus);

    state.evaluate();
  }

  collectedToTray(int level) {
    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.kosik);

    state.collect(level);
    state.increaseCoinCount(level * _connectCoinCount);
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
          if (purpleMode == PurpleMode.trippie) {
            final PurpleWorldComponent newPurpleComponent = PurpleWorldComponent(
                _generatedIndexNumber(random));
            await add(newPurpleComponent);
            purpleWorldComponents.add(newPurpleComponent);
          }
          if (purpleMode == PurpleMode.counter) {
            await add(PurpleMathComponent(_generatedIndexNumber(random)));
          }
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
      if(purpleMode == PurpleMode.trippie) {
        generatedIndexNumber = random.nextInt(4) + 1;
      }
    if (purpleMode == PurpleMode.counter) {
      generatedIndexNumber = random.nextInt(4);
      if(generatedIndexNumber >= 2) {
        if (random
            .nextInt(10)
            .isEven) {
          generatedIndexNumber = random.nextInt(2);
        }
      }
    }
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
