import 'dart:math';

import 'package:block_crusher/src/game/collector_game_helper.dart';
import 'package:block_crusher/src/game/collision_detector.dart';
import 'package:block_crusher/src/database/in_game_characters.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

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

  PurpleWorldComponent(this.characterId, this.type, {this.hasCopy = false});

  PurpleWorldComponent.copyFrom(this.copy, this.predefinedPosition, this.type, {this.hasCopy = true}) {
    lives = copy!.lives;
  }

  _sprite() async {
    if( type == TrippieCharacterType.number) {
      if (purpleWorldCharacters['number']![characterId] != null) {
        sprite = await gameRef
            .loadSprite(purpleWorldCharacters['number']![characterId]['source']);
        size = purpleWorldCharacters['number']![characterId]['size'] * _scale;
      }}
    if (type == TrippieCharacterType.vacuum) {
      if (purpleWorldCharacters['vacuum']![characterId] != null) {
        sprite = await gameRef
            .loadSprite(purpleWorldCharacters['vacuum']![characterId]['source']);
        size = purpleWorldCharacters['vacuum']![characterId]['size'] * _scale;
      }}
    if (type == TrippieCharacterType.cube) {
      if (purpleWorldCharacters['cube']![characterId] != null) {
        sprite = await gameRef
            .loadSprite(purpleWorldCharacters['cube']![characterId]['source']);
        size = purpleWorldCharacters['cube']![characterId]['size'] * _scale;
      }}
    if (type == TrippieCharacterType.faraon) {
      if (purpleWorldCharacters['faraon']![characterId] != null) {
        sprite = await gameRef
            .loadSprite(purpleWorldCharacters['faraon']![characterId]['source']);
        size = purpleWorldCharacters['faraon']![characterId]['size'] * _scale;
      }}
    if (type == TrippieCharacterType.redCar) {
      if (purpleWorldCharacters['redCar']![characterId] != null) {
        sprite = await gameRef
            .loadSprite(purpleWorldCharacters['redCar']![characterId]['source']);
        size = purpleWorldCharacters['redCar']![characterId]['size'] * _scale;
      }}
    if (type == TrippieCharacterType.greenCar) {
      if (purpleWorldCharacters['greenCar']![characterId] != null) {
        sprite = await gameRef
            .loadSprite(purpleWorldCharacters['greenCar']![characterId]['source']);
        size = purpleWorldCharacters['greenCar']![characterId]['size'] * _scale;
      }}
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