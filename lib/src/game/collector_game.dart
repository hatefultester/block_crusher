import 'package:block_crusher/src/game/hoomy_weapon_component.dart';
import 'package:block_crusher/src/game/sprite_block_component.dart';
import 'package:block_crusher/src/game/loading.dart';
import 'package:block_crusher/src/game/map.dart';
import 'package:block_crusher/src/game/on_load_creatures.dart';
import 'package:block_crusher/src/game/timer_manager.dart';
import 'package:block_crusher/src/game/collector_game_level_state.dart';
import 'package:block_crusher/src/services/remote_config.dart';
import 'package:block_crusher/src/services/audio_controller.dart';
import 'package:block_crusher/src/storage/game_achievements.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:async' as dart_async;
import '../database/maps.dart';
import 'world_type.dart';
import 'purple_component.dart';
import 'purple_math_component.dart';
import 'collector_game_helper.dart';

class BlockCrusherGame extends FlameGame
    with HasCollisionDetection, HasDraggables, HasTappables {
  final WorldType difficulty;
  GameMode gameMode = GameMode.classic;
  late PurpleMode purpleMode;
  late CollectorGameLevelState state;

  final TrippieCharacterType? trippieCharacterType;
  final MathCharacterType? mathCharacterType;

  dart_async.Timer? timer;

  late int tickCounter;
  late int tickSpeed;
  late int generatedCounter;
  late int connectCoinCount;

  late double blockFallSpeed;
  late int foodIndex;
  late int maxCharacterIndex;

  late EnemyHoomyComponent enemyHoomyComponent;
  List<PurpleWorldComponent> purpleWorldComponents = [];

  bool generateCharacterFromLastLevel;
  bool hasSpecialEvents;
  bool hasDifferentStartingBlock;

  final RemoteConfigProvider remoteConfig;
  final GameAchievements gameAchievements;
  final AudioController audioController;

  late String mapPath;

  BlockCrusherGame(this.difficulty,
      {this.hasDifferentStartingBlock = false,
      this.generateCharacterFromLastLevel = false,
      this.hasSpecialEvents = false,this.trippieCharacterType, this.mathCharacterType,
      required this.gameAchievements, required this.audioController, required this.remoteConfig,})
      : super();

  BlockCrusherGame setGame(
      BuildContext context, CollectorGameLevelState state) {
    setBlockCrusherGameFromPlaySessionWidget(context, state);
    return this;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    mapPath = setMapBasedOnDifficulty();
    setVariablesBasedOnGameMode();

    await add(
      SpriteComponent(
        sprite: await loadSprite(mapPath),
        size: Vector2(size.x, size.y),
      ),
    );

    await addOnLoadCreatures();

    startTimer();
  }

  restartGame() async {
    timer?.cancel();

    final allPositionComponents = children.query<SpriteBlockComponent>();
    removeAll(allPositionComponents);

    setVariablesBasedOnGameMode();

    state.reset();

    await Future<void>.delayed(const Duration(milliseconds: 500));

    await addDefaultBlock();

    startTimer();
  }

  @override
  void onRemove() {
    super.onRemove();

    timer?.cancel();
    debugPrint('game was stopped');
  }

  coinCountFromState() => state.coinCount;

}
