import 'dart:math';

import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/util/collision_detector.dart';
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/levels.dart';
import 'package:block_crusher/src/utils/in_game_characters.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/gestures.dart';

import '../../../../level_logic/level_states/collector_game/world_type.dart';
import '../../collector_game.dart';

enum MathCharacterType {
  faraon, cube, vacuum,
}

class PurpleMathComponent extends SpriteComponent
    with HasGameRef<BlockCrusherGame>, CollisionCallbacks, Draggable, Tappable {
  Vector2? dragDeltaPosition;

  bool get isDragging => dragDeltaPosition != null;

  final WorldType difficulty = WorldType.purpleWorld;

  final double _scale = 7.0;

  int characterId = 0;

  late int lastCharacterId;

  int tapCounter = 0;

  bool sizeSet = false;

  late GameMode gameMode;

  int lives = 3;

  bool hasCopy;
  PurpleMathComponent? copy;
  Vector2? predefinedPosition;

  final MathCharacterType type;

  PurpleMathComponent(this.characterId,
      {this.hasCopy = false, required this.type,});

  PurpleMathComponent.copyFrom(this.copy, this.predefinedPosition,
      {this.hasCopy = true, required this.type,}) {
    lives = copy!.lives;
  }

  _sprite() async {
    if (type == MathCharacterType.faraon) {
      if (purpleWorldCharacters['faraon']![characterId] != null) {
        sprite = await gameRef
            .loadSprite(
            purpleWorldCharacters['faraon']![characterId]['source']);
        if (sizeSet) {
          size = size * 1.25;
        } else {
          size = purpleWorldCharacters['faraon']![characterId]['size'] * _scale;
          sizeSet = true;
        }
      }
    }
    if (type == MathCharacterType.cube) {
      if (purpleWorldCharacters['cube']![characterId] != null) {
        sprite = await gameRef
            .loadSprite(purpleWorldCharacters['cube']![characterId]['source']);
        if (sizeSet) {
          size = size * 1.25;
        } else {
          size = purpleWorldCharacters['cube']![characterId]['size'] * _scale;
          sizeSet = true;
        }
      }
    }
      if (type == MathCharacterType.vacuum) {
        if (purpleWorldCharacters['vacuum']![characterId] != null) {
          sprite = await gameRef
              .loadSprite(
              purpleWorldCharacters['vacuum']![characterId]['source']);
          if (sizeSet) {
            size = size * 1.25;
          } else {
            size =
                purpleWorldCharacters['vacuum']![characterId]['size'] * _scale;
            sizeSet = true;
          }
        }
      }
    }

    bool tapped = false;

    @override
    Future<void> onLoad() async {
      super.onLoad();

      gameMode = gameRef.gameMode;

      if (!hasCopy) {
        await _sprite();

        int xMax = (gameRef.size.x - size.x).toInt();
        position = Vector2(
          (Random().nextInt(xMax) + 0),
          0,
        );
      }
      else {
        characterId = copy!.lastCharacterId;
        await _sprite();
        position = predefinedPosition!;
      }


      await add(CircleHitbox()
        ..shouldFillParent);
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

      y += gameRef.blockFallSpeed;

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
    void onCollisionStart(Set<Vector2> intersectionPoints,
        PositionComponent other) {
      super.onCollisionStart(intersectionPoints, other);

      if (other is PurpleMathComponent) {
        if (other.isDragging) return;

        if (other.characterId + characterId + 1 >= 5) return;

        other.removeFromParent();
        characterId = other.characterId + characterId + 1;
        _sprite();

        if (characterId == 4) {
          OpacityEffect effect = OpacityEffect.to(
            0.3, EffectController(duration: 0.5),
            onComplete: () => {removeFromParent(),},);
          add(effect);
        }

        gameRef.collisionDetected(characterId, intersectionPoints);
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
