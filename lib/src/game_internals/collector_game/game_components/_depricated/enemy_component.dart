import 'dart:math';

import 'package:block_crusher/src/game_internals/collector_game/game_components/soomy_land/sprite_block_component.dart';
import 'package:block_crusher/src/game_internals/collector_game/util/collector_game_helper.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/geometry.dart';

import '../../collector_game.dart';

class EnemyComponent extends SpriteComponent
    with HasGameRef<BlockCrusherGame>, CollisionCallbacks, Draggable, Tappable {
  Vector2? dragDeltaPosition;

  final double _scale = 2.0;

  double extraspeed = 0;

  bool shouldDisappear = true;

  Direction direction = Direction.down;

  EnemyComponent();
  EnemyComponent.withDirection(this.direction);

  EnemyComponent.randomDirection(this.shouldDisappear) {
    Random random = Random();

    switch (random.nextInt(4)) {
      case (0):
        direction = Direction.right;
        break;
      case (1):
        direction = Direction.left;
        break;
      case (2):
        direction = Direction.up;
        break;
      case (3):
        direction = Direction.down;
        break;
    }
  }

  _sprite() async {
    sprite = await gameRef.loadSprite('asterisks.png');
    size = Vector2(20, 23) * _scale;
  }

  bool tapped = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    await _sprite();

    int xMax = (gameRef.size.x - size.x).toInt();
    int yMax = (gameRef.size.y - size.y).toInt();

    switch (direction) {
      case Direction.down:
        position = Vector2(
          (Random().nextInt(xMax) + 0),
          40,
        );
        break;
      case Direction.up:
        position = Vector2(
          (Random().nextInt(xMax) + 0),
          gameRef.size.y - 40,
        );
        break;
      case Direction.left:
        position = Vector2(
          gameRef.size.x - 40,
          (Random().nextInt(yMax) + 0),
        );
        break;
      case Direction.right:
        position = Vector2(
          40,
          (Random().nextInt(yMax) + 0),
        );
        break;
    }

    await add(CircleHitbox()..shouldFillParent);

    await Future.delayed(const Duration(seconds: 2));
    final effect = RotateEffect.to(
      tau,
      EffectController(duration: 1.5),
    );

    await add(effect);

    if (shouldDisappear) {
      await Future.delayed(const Duration(seconds: 1));
      final effect = OpacityEffect.to(0.3, EffectController(duration: 1.5),
          onComplete: (() {
        removeFromParent();
      }));

      await add(effect);
    }
  }

  timer() {}

  @override
  update(double dt) {
    super.update(dt);

    switch (direction) {
      case Direction.down:
        y += gameRef.blockFallSpeed + extraspeed;
        break;
      case Direction.up:
        y -= gameRef.blockFallSpeed + extraspeed;
        break;
      case Direction.left:
        x -= gameRef.blockFallSpeed + extraspeed;
        break;
      case Direction.right:
        x += gameRef.blockFallSpeed + extraspeed;
        break;
    }

    switch (direction) {
      case Direction.down:
        if (y > gameRef.size.y) {
          gameRef.blockRemoved();
          removeFromParent();
        }
        break;
      case Direction.up:
        if (y < 0) {
          gameRef.blockRemoved();
          removeFromParent();
        }
        break;
      case Direction.left:
        if (x < 0) {
          gameRef.blockRemoved();
          removeFromParent();
        }
        break;
      case Direction.right:
        if (x > gameRef.size.x) {
          gameRef.blockRemoved();
          removeFromParent();
        }
        break;
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is SpriteBlockComponent) {
      other.removeFromParent();
    }
  }
}
