import 'dart:math';

import 'package:block_crusher/src/level_selection/levels.dart';
import 'package:block_crusher/src/utils/characters.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:flame_forge2d/flame_forge2d.dart';

import '../game.dart';

enum Direction { down, up, left, right }

class SpriteBlockComponent extends SpriteComponent
    with HasGameRef<BlockCrusherGame>, CollisionCallbacks, Draggable, Tappable {
  Vector2? dragDeltaPosition;
  bool get isDragging => dragDeltaPosition != null;

  final double _scale = 7.0;

  double extraspeed = 0;

  final LevelDifficulty difficulty;

  int characterId = 0;

  Direction direction = Direction.down;

  SpriteBlockComponent(this.difficulty);
  SpriteBlockComponent.withLevelSet(this.characterId, this.difficulty);
  SpriteBlockComponent.withDirection(this.direction, this.difficulty);

  _sprite() async {
    if (imageSource[difficulty.index][characterId]['source'] != null) {
      sprite = await gameRef
          .loadSprite(imageSource[difficulty.index][characterId]['source']);
      size = imageSource[difficulty.index][characterId]['size'] * _scale;
    }
  }

  bool tapped = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    sprite = await gameRef
        .loadSprite(imageSource[difficulty.index][characterId]['source']);
    size = imageSource[difficulty.index][characterId]['size'] * _scale;
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
    this.characterId = level;
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
      if (y > 5 && isDragging) {
        if (other.characterId == characterId) {
          other.removeFromParent();
          characterId++;
          _sprite();
          direction = Direction.down;
          gameRef.collisionDetected(characterId);
        }
        if (other.characterId != characterId) {
          //   other.startDragging();
        }
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is SpriteBlockComponent) {
      if (other.characterId != characterId) {}
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
