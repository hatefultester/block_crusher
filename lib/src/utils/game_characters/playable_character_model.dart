
import 'package:flame/game.dart';

class PlayableCharacterModel {

  final String imagePath;
  final double width;
  final double height;

  Vector2 gameSize() {
    return Vector2(width, height);
  }

  PlayableCharacterModel(
  {this.imagePath = 'characters_skill_game/1_1000x880.png',
    this.width = 10, this.height = 8.8,
  });
}