import 'dart:math';

import 'package:block_crusher/src/game_internals/collector_game/components/sprite_block_component.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../game.dart';

class EnemyHoomyComponent extends SpriteComponent
    with HasGameRef<BlockCrusherGame> {
  @override
  onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('characters/hoomy/1000x907xhoomik.png');
    size = Vector2(10 * 20, 9.07 * 20);
    position =
        Vector2(gameRef.size.x / 2 - size.x / 2, gameRef.size.y - size.y - 70);
  }
}

class HoomyWeaponComponent extends SpriteComponent
    with HasGameRef<BlockCrusherGame>, CollisionCallbacks, Draggable, Tappable {
  Vector2? dragDeltaPosition;

  final double _scale = 2.0;

  double extraspeed = 0;

  bool shouldDisappear = true;

  Direction direction = Direction.up;

  HoomyWeaponComponent();

  _sprite() async {
    sprite = await gameRef.loadSprite('asterisks.png');
    size = Vector2(20, 23) * _scale;
  }

  bool tapped = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    Vector2 finalDirection;

    int xMax = (gameRef.size.x - size.x).toInt();

    if (Random().nextInt(10).isEven) {
      direction = Direction.left;
      finalDirection = Vector2(0, -10 + Random().nextInt(20) + 1);
    } else {
      direction = Direction.right;
      finalDirection = Vector2(xMax + 0, -10 + Random().nextInt(20) + 1);
    }

    await _sprite();

    position = Vector2(
      direction == Direction.left
          ? gameRef.size.x / 2 - 15
          : gameRef.size.x / 2,
      gameRef.enemyHoomik.position.y,
    );

    await add(CircleHitbox()..shouldFillParent);

    throwMe(finalDirection);
  }

  throwMe(Vector2 finalDirection) async {
    int duration = Random().nextInt(20) + 15;
    await Future.delayed(Duration(
      milliseconds: (duration * 100),
    ));

    final effect = MoveEffect.to(
      finalDirection,
      EffectController(duration: duration / 10),
      onComplete: () {
        removeFromParent();
      },
    );

    await add(effect);
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
