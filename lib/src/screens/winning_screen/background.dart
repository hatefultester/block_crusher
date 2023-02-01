import 'package:flame/components.dart';
import 'package:flame/game.dart';

class LostBackground extends FlameGame {
  @override
  Future<void>? onLoad() async {
    super.onLoad();
    await add(SpriteComponent(size: Vector2(size.x, size.y), sprite: await loadSprite('backgrounds/lost_game_background.png'),
    ),);
  }

}

class WinBackground extends FlameGame {
  @override
  Future<void>? onLoad() async {
    super.onLoad();
    await add(SpriteComponent(size: Vector2(size.x, size.y), sprite: await loadSprite('backgrounds/win_game_background.png'),
    ),);
  }

}