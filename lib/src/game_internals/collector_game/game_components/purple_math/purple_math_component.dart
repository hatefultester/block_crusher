import 'dart:math';

import 'package:block_crusher/src/game_internals/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/level_selection/levels.dart';
import 'package:block_crusher/src/utils/characters.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import '../../collector_game.dart';


class PurpleMathComponent extends SpriteComponent
    with HasGameRef<BlockCrusherGame>, CollisionCallbacks, Draggable, Tappable {
  Vector2? dragDeltaPosition;
  bool get isDragging => dragDeltaPosition != null;

  final LevelDifficulty difficulty = LevelDifficulty.purpleWorld;

  final double _scale = 7.0;

  int characterId = 0;

  late int lastCharacterId;

  int tapCounter = 0;

  late GameMode gameMode;

  int lives =3;

  bool hasCopy;
  PurpleMathComponent? copy;
  Vector2? predefinedPosition;

  PurpleMathComponent(this.characterId, {this.hasCopy = false});

  PurpleMathComponent.copyFrom(this.copy, this.predefinedPosition, {this.hasCopy = true}) {
    lives = copy!.lives;
  }

  _sprite() async {
    if (imageSource[difficulty.index][characterId] != null) {
      sprite = await gameRef
          .loadSprite(imageSource[difficulty.index][characterId]['source']);
      size = imageSource[difficulty.index][characterId]['size'] * _scale;
    }
  }

  bool tapped = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    int xMax = (gameRef.size.x - size.x).toInt();

    gameMode = gameRef.gameMode;

    if(!hasCopy) {
      await _sprite();
      position = Vector2(
        (Random().nextInt(xMax) + 0),
        0,
      );
    }
    else {
      characterId = copy!.lastCharacterId!;
      await _sprite();
      position = predefinedPosition!;

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
    if (isDragging) return;
    if (tapped) return;

    y += gameRef.blockFallSpeed ;

    if (y > gameRef.size.y) {
      gameRef.blockRemoved();
      removeFromParent();
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

    if (other is PurpleMathComponent) {
      if(other.isDragging) return;

      if (other.characterId + characterId+1 >= 5) return;

      other.removeFromParent();
      characterId = other.characterId + characterId + 1;
      _sprite();

      if(characterId == 4) {
      OpacityEffect effect = OpacityEffect.to(0.3,EffectController(duration: 0.5), onComplete: () => {removeFromParent(),},);
      add(effect);
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is PurpleMathComponent) {
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
