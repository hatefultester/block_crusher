import 'package:block_crusher/src/app_lifecycle/app_lifecycle.dart';
import 'package:block_crusher/src/level_selection/level_state.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';

import 'dart:async' as a;

import 'components/sprite_block_component.dart';

class BlockCrusherGame extends FlameGame
    with HasCollisionDetection, HasDraggables, HasTappables {
  late BuildContext context;
  late LevelState state;

  final double defaultBlockFallSpeed = 1.0;
  final int defaultTickSpeed = 150;

  late double blockFallSpeed;
  late int tickSpeed;

  bool loading = true;

  late a.Timer timer;
  late BlockCrusherGame game;

  late int tickCounter;
  late int generatedCounter;

  BlockCrusherGame();

  _setVars() {
    blockFallSpeed = defaultBlockFallSpeed;
    tickSpeed = defaultTickSpeed;
    tickCounter = 0;
    generatedCounter = 0;
  }

  late SpriteBlockComponent initialBlock;

  BlockCrusherGame set(BuildContext context, LevelState state) {
    this.context = context;
    this.state = state;

    return this;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _setVars();

    await add(
      SpriteComponent(
        sprite: await loadSprite('background.png'),
        size: Vector2(size.x, size.y),
      ),
    );

    await add(SpriteBlockComponent.withLevelSet(state.goal - 1));

    _startTimer();
  }

  void collisionDetected(int level) {
    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.wssh);

    _scoreIncrease();
    _levelIncrease(level);
  }

  _scoreIncrease() {
    state.setProgress(state.score + 1);
    state.evaluate();
  }

  blockRemoved() {
    state.decreaseLife();
    state.evaluate();
  }

  _startTimer() async {
    print('Starting timer');
    timer = a.Timer.periodic(const Duration(milliseconds: 20), (timer) async {
      if (!(AppLifecycleObserver.appState == AppLifecycleState.paused)) {
        tickCounter++;
        if (tickCounter == tickSpeed) {
          tickCounter = 0;
          generatedCounter++;
          _addNewBlock();
        }
      }
    });
  }

  _addNewBlock() async {
    await add(SpriteBlockComponent());

    if (generatedCounter == 2) {
      generatedCounter = 0;
      await add(SpriteBlockComponent.oppositeDirection());
    }
  }

  _levelIncrease(int level) {
    if (level > state.level) {
      _increaseGameSpeed();
      state.setLevel(level);
      state.evaluate();
    }
  }

  _increaseGameSpeed() {
    // if (tickSpeed > 100) tickSpeed -= 15;
    // if (tickSpeed > 50) tickSpeed -= 10;
  }

  restartGame() async {
    timer.cancel();
    final allPositionComponents = children.query<SpriteBlockComponent>();

    removeAll(allPositionComponents);

    _setVars();
    state.reset();

    await Future<void>.delayed(const Duration(milliseconds: 500));

    await add(SpriteBlockComponent.withLevelSet(state.goal - 1));
    _startTimer();
  }
}
