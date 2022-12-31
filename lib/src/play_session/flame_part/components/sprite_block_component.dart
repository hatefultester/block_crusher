import 'dart:math';

import 'package:block_crusher/src/play_session/game_controller.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../game.dart';

class SpriteBlockComponent extends SpriteComponent
    with HasGameRef<BlockCrusherGame>, CollisionCallbacks, Draggable, Tappable {
  Vector2? dragDeltaPosition;
  bool get isDragging => dragDeltaPosition != null;

  final double _scale = 7.0;

  int level = 0;
  List<Map<String, dynamic>> imageSource = [
    {'source': '1_1000x880.png', 'size': Vector2(10, 8.8)},
    {'source': '2_1000x880.png', 'size': Vector2(10, 8.8)},
    {'source': '3_500x1000.png', 'size': Vector2(5, 10)},
    {'source': '4_500x1000.png', 'size': Vector2(5, 10)},
    {'source': '5_1000x1000.png', 'size': Vector2(10, 10)},
    {'source': '6_1000x1000.png', 'size': Vector2(10, 10)},
    {'source': '7_1000x750.png', 'size': Vector2(10, 7.5)},
    {'source': '8_1000x750.png', 'size': Vector2(10, 7.5)},
    {'source': '9_1000x1140.png', 'size': Vector2(10, 11.4)},
  ];

  _sprite() async {
    if (level < imageSource.length) {
      sprite = await gameRef.loadSprite(imageSource[level]['source']);
      size = imageSource[level]['size'] * _scale;
    }
  }

  bool tapped = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    await _sprite();

    int xMax = (gameRef.size.x - size.x).toInt();
    position = Vector2((Random().nextInt(xMax) + 0), 0);

    await add(CircleHitbox()..shouldFillParent);
  }

  @override
  update(double dt) {
    super.update(dt);
    if (!isDragging && !tapped) {
      y += gameRef.blockFallSpeed;
    }

    if (y > gameRef.size.y) {
      gameRef.blockRemoved();
      removeFromParent();
    }
  }

  @override
  bool onDragStart(DragStartInfo info) {
    dragDeltaPosition = info.eventPosition.game - position;
    return false;
  }

  @override
  bool onDragUpdate(DragUpdateInfo info) {
    if (isDragging) {
      final localCoords = info.eventPosition.game;
      position = localCoords - dragDeltaPosition!;
    }
    return false;
  }

  @override
  bool onDragEnd(DragEndInfo info) {
    dragDeltaPosition = null;
    return false;
  }

  @override
  bool onDragCancel() {
    dragDeltaPosition = null;
    return false;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is SpriteBlockComponent) {
      _colorfulCollisionStartMethod(other);
    }
  }

  _colorfulCollisionStartMethod(SpriteBlockComponent other) {
    if (y > 5 && isDragging && other.level == level) {
      other.removeFromParent();
      level++;
      _sprite();
      gameRef.collisionDetected();
    }
  }

  _dumbCollisionStartMethod(PositionComponent other) {
    if (y > 5) {
      other.removeFromParent();
      removeFromParent();
      gameRef.collisionDetected();
    }
  }

  @override
  bool onTapDown(TapDownInfo info) {
    tapped = true;
    return super.onTapDown(info);
  }

  @override
  bool onTapCancel() {
    tapped = false;
    return super.onTapCancel();
  }

  @override
  bool onTapUp(TapUpInfo info) {
    tapped = false;
    return super.onTapUp(info);
  }
}
