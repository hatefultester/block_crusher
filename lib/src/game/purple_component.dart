import 'dart:math';

import 'package:block_crusher/src/game/collector_game_helper.dart';
import 'package:block_crusher/src/game/collision_detector.dart';
import 'package:block_crusher/src/database/in_game_characters.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';

import 'world_type.dart';
import 'collector_game.dart';

enum TrippieCharacterType {
  vacuum, number, faraon, redCar, greenCar, cube
}

class PurpleWorldComponent extends SpriteComponent
    with HasGameRef<BlockCrusherGame>, CollisionCallbacks, Draggable, Tappable {
  Vector2? dragDeltaPosition;
  bool get isDragging => dragDeltaPosition != null;

  final WorldType difficulty = WorldType.purpleWorld;

  final double _scale = 7.0;

  int characterId = 0;

  late int lastCharacterId;

  int tapCounter = 0;

  late GameMode gameMode;

  final TrippieCharacterType type;

  int lives = 3;

  bool hasCopy;
  PurpleWorldComponent? copy;
  Vector2? predefinedPosition;

  double _incrementalScale = 1;
  bool sizeSet = false;

  PurpleWorldComponent(this.characterId, this.type, {this.hasCopy = false});

  PurpleWorldComponent.copyFrom(this.copy, this.predefinedPosition, this.type, {this.hasCopy = true}) {
    lives = copy!.lives;
  }

  _sprite() async {
    if (type == TrippieCharacterType.number) {
      print('is it nunll? ${purpleWorldCharacters['number']![characterId.toString()]['source'].toString()}');
      if (purpleWorldCharacters['number']![characterId.toString()]['source'] != null) {
        sprite = await gameRef.loadSprite(
            purpleWorldCharacters['number']![characterId.toString()]['source']);
        if (sizeSet) {
          size = size * 1.25;
        } else {
          size = purpleWorldCharacters['number']![characterId.toString()]['size'] * _scale* _incrementalScale;


        }
      }
    }
    if (type == TrippieCharacterType.vacuum) {
      print('is it nunll? ${purpleWorldCharacters['vacuum']![characterId.toString()]['source'].toString()}');
      if (purpleWorldCharacters['vacuum']![characterId.toString()]['source'] != null) {
        sprite = await gameRef.loadSprite(
            purpleWorldCharacters['vacuum']![characterId.toString()]['source']);
        if (sizeSet) {
          size = size * 1.25;
        } else {
          size = purpleWorldCharacters['vacuum']![characterId.toString()]['size'] * _scale* _incrementalScale;_incrementalScale += 0.3;

        }
      }
    }
    if (type == TrippieCharacterType.cube) {
      print('is it nunll? ${purpleWorldCharacters['cube']![characterId.toString()]['source'].toString()}');
      if (purpleWorldCharacters['cube']![characterId.toString()]['source'] != null) {
        sprite = await gameRef
            .loadSprite(purpleWorldCharacters['cube']![characterId.toString()]['source']);
        if (sizeSet) {
          size = size * 1.25;
        } else {
          size = purpleWorldCharacters['cube']![characterId.toString()]['size'] * _scale* _incrementalScale;_incrementalScale += 0.3;

        }
      }
    }
    if (type == TrippieCharacterType.faraon) {
      print('is it nunll? ${purpleWorldCharacters['farrago']![characterId.toString()]['source'].toString()}');
      if (purpleWorldCharacters['farrago']![characterId.toString()]['source'] != null) {
        sprite = await gameRef.loadSprite(
            purpleWorldCharacters['farrago']![characterId.toString()]['source']);
        if (sizeSet) {
          size = size * 1.25;
        } else {
          size =
              purpleWorldCharacters['farrago']![characterId.toString()]['size'] * _scale* _incrementalScale;


        }
      }
    }
    if (type == TrippieCharacterType.redCar) {
      print('is it nunll? ${purpleWorldCharacters['redCar']![characterId.toString()]['source'].toString()}');
      if (purpleWorldCharacters['redCar']![characterId.toString()]['source'] != null) {
        sprite = await gameRef.loadSprite(
            purpleWorldCharacters['redCar']![characterId.toString()]['source']);
        if (sizeSet) {
          size = size * 1.25;
        } else {
          size = purpleWorldCharacters['redCar']![characterId.toString()]['size'] * _scale * _incrementalScale;

        }
      }
    }
    if (type == TrippieCharacterType.greenCar) {
      print('is it nunll? ${purpleWorldCharacters['greenCar']![characterId.toString()]['source'].toString()}');
      if (purpleWorldCharacters['greenCar']![characterId.toString()]['source'] != null) {
        sprite = await gameRef.loadSprite(
            purpleWorldCharacters['greenCar']![characterId.toString()]['source']);
        if (sizeSet) {
          size = size * 1.25;
        } else {
          size =
              purpleWorldCharacters['greenCar']![characterId.toString()]['size'] * _scale * 1.3* _incrementalScale;


        }
      }
    }

    if (sprite == null) {
      print('LOADING SPRITE FAILED !');
      print('type was ${describeEnum(type)}');
      print('character id was ${characterId.toString()}');
    }
  }

  bool tapped = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    gameMode = gameRef.gameMode;

    if(!hasCopy) {
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

      if(characterId == 0) return false;

    lastCharacterId = characterId - 1;

      gameRef.splitPurpleComponent(this, position);

    characterId = 0;
    _sprite();

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
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is PurpleWorldComponent) {
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
