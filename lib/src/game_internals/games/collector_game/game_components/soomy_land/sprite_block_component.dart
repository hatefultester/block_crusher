import 'dart:math';

import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/util/collision_detector.dart';
import 'package:block_crusher/src/utils/in_game_characters.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';

import '../../../../level_logic/level_states/collector_game/world_type.dart';
import '../../collector_game.dart';
import 'dart:async' as async_dart;


class SpriteBlockComponent extends SpriteComponent
    with HasGameRef<BlockCrusherGame>, CollisionCallbacks, Draggable, Tappable {
  Vector2? dragDeltaPosition;
  bool get isDragging => dragDeltaPosition != null;

  final double _scale = 7.0;

  double extraspeed = 0;

  final WorldType difficulty;

  int characterId = 0;

  int tapCounter = 0;

  late GameMode gameMode;

  Direction direction = Direction.down;

  SpriteBlockComponent(this.difficulty);
  SpriteBlockComponent.withLevelSet(this.characterId, this.difficulty);
  SpriteBlockComponent.withDirection(this.direction, this.difficulty);

  async_dart.Timer? timer;

  _sprite() async {
    if(gameRef.gameMode == GameMode.alien)
      {
        final isAnimated = imageSource[difficulty.index][characterId]['isAnimated'];
        if (isAnimated == true) {
          _toggleAnimation();
        }
      }
    if (gameRef.gameMode != GameMode.cityFood) {
      if (imageSource[difficulty.index][characterId] != null) {
        sprite = await gameRef
            .loadSprite(imageSource[difficulty.index][characterId]['source']);
        size = imageSource[difficulty.index][characterId]['size'] * _scale;
      }
    }

    if (gameRef.gameMode == GameMode.cityFood) {
      if (cityFoods[gameRef.foodIndex]['characters'][characterId] != null) {
        sprite = await gameRef.loadSprite(
            cityFoods[gameRef.foodIndex]['characters'][characterId]['source']);
        size = cityFoods[gameRef.foodIndex]['characters'][characterId]['size'] *
            _scale;
      }
    }
  }

  _toggleAnimation() {
    if (timer != null) {
      if (timer!.isActive) {
        timer!.cancel();
      }
    }

    int counter = 0;

    timer = async_dart.Timer.periodic(const Duration(milliseconds: 300), (timer) async {
      if (counter.isEven) {
        sprite = await gameRef.loadSprite(imageSource[difficulty.index][characterId]['animationAssets'][0]['source']);
        size = imageSource[difficulty.index][characterId]['animationAssets'][0]['size'] * _scale;
      } else {
        sprite = await gameRef.loadSprite(imageSource[difficulty.index][characterId]['animationAssets'][1]['source']);
        size = imageSource[difficulty.index][characterId]['animationAssets'][1]['size'] * _scale;
      }
    },);
  }

  bool tapped = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    gameMode = gameRef.gameMode;

    // sprite = await gameRef
    //     .loadSprite(imageSource[difficulty.index][characterId]['source']);
    // size = imageSource[difficulty.index][characterId]['size'] * _scale;
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

    if(kDebugMode) {
      print('New sprite block component generated');
      print('initial position: ${position.x.toString()} / ${position.y
          .toString()}');
    }

    await add(CircleHitbox()..shouldFillParent);
  }

  Future<void> setLevel(int id) async {
    characterId = id;
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
    tapCounter = 0;
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

    if (y < 5 || !isDragging) return;

    if (other is SpriteBlockComponent) {
      if (other.characterId != characterId) return;

      if (gameMode == GameMode.cityFood) {
        if (characterId + 1 > cityFoods[gameRef.foodIndex]['sum']) return;
        //print('food sum is : ${cityFoods[gameRef.foodIndex]['sum']}');
      }

      characterId++;
      _sprite();

      other.removeFromParent();
      direction = Direction.down;

      gameRef.collisionDetected(characterId);
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

    if (gameRef.gameMode == GameMode.cityFood && (characterId > 0)) {
      tapCounter++;
      if (tapCounter >= 3) {
        characterId--;
        _sprite();
        tapCounter = 0;
      }
      //print(tapCounter.toString());
    }

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
