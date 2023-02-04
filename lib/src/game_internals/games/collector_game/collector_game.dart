import 'package:block_crusher/src/game_internals/games/collector_game/game_components/hoomy_land/hoomy_weapon_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/soomy_land/sprite_block_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/util/loading.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/util/map.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/util/on_load_creatures.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/util/timer_manager.dart';
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/collector_game_level_state.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:async' as dart_async;
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

  BlockCrusherGame(this.difficulty,
      {this.hasDifferentStartingBlock = false,
      this.generateCharacterFromLastLevel = false,
      this.hasSpecialEvents = false})
      : super();

  BlockCrusherGame setGame(
      BuildContext context, CollectorGameLevelState state) {
    setBlockCrusherGameFromPlaySessionWidget(context, state);
    return this;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    String mapPath = setMapBasedOnDifficulty();

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
