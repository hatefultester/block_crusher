import 'dart:math';

import 'package:block_crusher/src/game_internals/collector_game/game_components/soomy_land/sprite_block_component.dart';
import 'package:block_crusher/src/game_internals/collector_game/util/collector_game_helper.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/image_composition.dart';

import '../../collector_game.dart';

class EyeEnemyComponent extends SpriteAnimationComponent
    with HasGameRef<BlockCrusherGame>, CollisionCallbacks, Draggable, Tappable {
  Vector2? dragDeltaPosition;

  double extraspeed = 3;

  Random random = Random();

  bool shouldDisappear = true;

  Direction xDirection = Direction.left;

  Direction yDirection = Direction.up;

  double scaleFactor = 0.9;
  double slowFactor = 1;

  bool _setDirection = false;

  EyeEnemyComponent();

  EyeEnemyComponent.withScaleAndDirection(
      this.yDirection, this.xDirection, this.scaleFactor, this.slowFactor) {
    _setDirection = true;
  }

  bool tapped = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    double yPosition = 350 + Random().nextInt(350) + 10;

    final Image spriteImage =
        await gameRef.images.load('enemy/eye_enemy_spritesheet.png');

    animation = SpriteAnimation.fromFrameData(
      spriteImage,
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: 0.2,
        textureSize: Vector2(100, 65),
      ),
    );

    size = Vector2(100 * scaleFactor, 65 * scaleFactor);

    if (!_setDirection) {
      if (random.nextBool()) {
        yDirection = Direction.down;
      }

      if (random.nextBool()) {
        xDirection = Direction.left;
      } else {
        xDirection = Direction.right;
      }
    }

    position = Vector2(
      xDirection == Direction.left ? gameRef.size.x : 0 - size.x / 2,
      yPosition,
    );
    await add(CircleHitbox()..shouldFillParent);

    // throwMe(finalDirection);
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

    int acceleration = random.nextInt(3);

    switch (xDirection) {
      case Direction.left:
        x -= (gameRef.blockFallSpeed / 2 + extraspeed + acceleration) *
            slowFactor;
        break;
      case Direction.right:
        x += (gameRef.blockFallSpeed / 2 + extraspeed + acceleration) *
            slowFactor;
        break;
      default:
        return;
    }
    switch (yDirection) {
      case Direction.down:
        y += (gameRef.blockFallSpeed / 2 + extraspeed / 2 + acceleration) *
            slowFactor;
        break;
      case Direction.up:
        y -= (gameRef.blockFallSpeed / 2 + extraspeed + acceleration) *
            slowFactor;
        break;
      default:
        return;
    }

    switch (yDirection) {
      case Direction.down:
        if (y > gameRef.size.y - size.y - 40) {
          yDirection = Direction.up;
        }
        break;
      case Direction.up:
        if (y < 50) {
          yDirection = Direction.down;
        }
        break;
      default:
        return;
    }
    switch (xDirection) {
      case Direction.left:
        if (x < 0) {
          xDirection = Direction.right;
        }
        break;
      case Direction.right:
        if (x > gameRef.size.x - size.x) {
          xDirection = Direction.left;
        }
        break;
      default:
        return;
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
