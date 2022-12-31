import 'package:block_crusher/src/play_session/level_state.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../audio/audio_controller.dart';
import '../../audio/sounds.dart';

import 'dart:async' as a;

import 'components/sprite_block_component.dart';

class BlockCrusherGame extends FlameGame
    with HasCollisionDetection, HasDraggables, HasTappables {
  late BuildContext context;
  late LevelState state;

  final double defaultBlockFallSpeed = 1.0;
  final int defaultTickSpeed = 150;
  final int defaultGameScore = 0;
  final int defaultLives = 10;

  double blockFallSpeed = 1.0;
  int tickSpeed = 150;
  int gameScore = 0;
  int lives = 10;
  int bestScore = 0;

  bool loading = true;

  late Timer timer;
  late BlockCrusherGame game;

  int tickCounter = 0;

  BlockCrusherGame();

  BlockCrusherGame set(BuildContext context, LevelState state) {
    this.context = context;
    this.state = state;

    return this;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(
      SpriteComponent(
        sprite: await loadSprite('background.png'),
        size: Vector2(size.x, size.y),
      ),
    );

    _startTimer();
  }

  void collisionDetected() {
    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.wssh);

    _scoreIncrease();
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
    a.Timer timer = a.Timer.periodic(
      const Duration(milliseconds: 20),
      (timer) async {
        tickCounter++;
        if (tickCounter == tickSpeed) {
          tickCounter = 0;
          _addNewBlock();
        }
      },
    );
  }

  _addNewBlock() async {
    await add(SpriteBlockComponent());
  }
}
