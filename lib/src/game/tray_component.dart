
import 'package:block_crusher/src/game/sprite_block_component.dart';
import 'package:block_crusher/src/game/collision_detector.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'collector_game.dart';

enum MovingXDirection {
  left,
  right,
}

enum MovingYDirection {
  up,
  down,
}

class TrayComponent extends SpriteComponent
    with HasGameRef<BlockCrusherGame>, CollisionCallbacks, Draggable, Tappable {
  late MovingXDirection xDirection;
  late MovingYDirection yDirection;

  late double yStartPosition;
  late double finalTopPosition;

  late double finalXposition;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    size = Vector2(50 * 4, 33 * 4);

    xDirection = MovingXDirection.left;
    yDirection = MovingYDirection.up;
    yStartPosition = gameRef.size.y - 170;
    finalTopPosition = yStartPosition - size.y / 2;

    finalXposition = gameRef.size.x - size.x - 5;

    sprite = await gameRef.loadSprite('kosik.png');

    position = Vector2(gameRef.size.x / 2, gameRef.size.y - 150);

    await add(CircleHitbox()..shouldFillParent);
  }

  @override
  update(double dt) {
    super.update(dt);

    if (x <= 0) {
      xDirection = MovingXDirection.right;
    }

    if (x >= finalXposition) {
      xDirection = MovingXDirection.left;
    }

    if (y <= finalTopPosition) {
      yDirection = MovingYDirection.down;
    }

    if (y >= yStartPosition) {
      yDirection = MovingYDirection.up;
    }

    if (yDirection == MovingYDirection.up) {
      y--;
    } else {
      y++;
    }

    if (xDirection == MovingXDirection.left) {
      x--;
    } else {
      x++;
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is SpriteBlockComponent) {
      if (other.isDragging) {
        gameRef.collectedToTray(other.characterId);
        other.removeFromParent();
      }
    }
  }
}
