import 'dart:math';

import 'package:block_crusher/src/game_internals/collector_game/components/sprite_block_component.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/sprite.dart';

import '../game.dart';

class EyeEnemyComponent extends SpriteAnimationComponent
    with HasGameRef<BlockCrusherGame>, CollisionCallbacks, Draggable, Tappable {
  Vector2? dragDeltaPosition;

  final double _scale = 2.0;

  double extraspeed = Random().nextInt(5) + 0;

  bool shouldDisappear = true;

  Direction direction = Direction.up;

  EyeEnemyComponent();

  bool tapped = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    Vector2 finalDirection;

    int xMax = (gameRef.size.x - size.x).toInt();

    double yPosition = 350 + Random().nextInt(350) + 10;

    

    final Image spriteImage = await gameRef.images.load('enemy/eye_enemy_spritesheet.png');
    animation = SpriteAnimation.fromFrameData(spriteImage,  SpriteAnimationData.sequenced(amount: 2,  stepTime: 0.1, textureSize: Vector2(100,65)));
size = Vector2(100, 65) ;

    if (Random().nextInt(10).isEven) {
      direction = Direction.left;

      finalDirection =
          Vector2(0 - size.x, yPosition + Random().nextInt(20) - 15);
    } else {
      direction = Direction.right;
      finalDirection = Vector2(xMax + 0, yPosition + Random().nextInt(20) - 15);
    }
    position = Vector2(
      direction == Direction.left ? gameRef.size.x : 0 - size.x / 2,
      yPosition,
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
      EffectController(duration: duration * 1.5 / 10),
      onComplete: () {
        removeFromParent();
      },
    );

    await add(effect);
  }

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
