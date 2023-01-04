import 'dart:math';

import 'package:block_crusher/src/game_internals/characters.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../game.dart';

enum Direction { down, up, left, right }

class SpriteBlockComponent extends SpriteComponent
    with HasGameRef<BlockCrusherGame>, CollisionCallbacks, Draggable, Tappable {
  Vector2? dragDeltaPosition;
  bool get isDragging => dragDeltaPosition != null;

  final double _scale = 7.0;

  double extraspeed = 0;

  int level = 0;

  Direction direction = Direction.down;

  SpriteBlockComponent();
  SpriteBlockComponent.withLevelSet(this.level);
  SpriteBlockComponent.withDirection(this.direction);

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
    int yMax = (gameRef.size.y - size.y).toInt();

    switch (direction) {
      case Direction.down:
        position = Vector2(
          (Random().nextInt(xMax) + 0),
          0,
        );
        break;
      case Direction.up:
        position = Vector2(
          (Random().nextInt(xMax) + 0),
          gameRef.size.y,
        );
        break;
      case Direction.left:
        position = Vector2(
          gameRef.size.x - 30,
          (Random().nextInt(yMax) + 0),
        );
        break;
      case Direction.right:
        position = Vector2(
          0 + 30,
          (Random().nextInt(yMax) + 0),
        );
        break;
    }

    await add(CircleHitbox()..shouldFillParent);
  }

  Future<void> setLevel(int level) async {
    this.level = level;
    await _sprite();
  }

  @override
  update(double dt) {
    super.update(dt);
    if (!isDragging && !tapped) {
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
      if (y > 5 && isDragging && other.level == level) {
        other.removeFromParent();
        level++;
        _sprite();
        direction = Direction.down;
        gameRef.collisionDetected(level);
      }
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
