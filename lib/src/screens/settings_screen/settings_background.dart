import 'package:flame/components.dart';
import 'package:flame/game.dart';

class SettingsBackground extends FlameGame {
  @override
  Future<void>? onLoad() async {
    super.onLoad();
    await add(SpriteComponent(size: Vector2(size.x, size.y), sprite: await loadSprite('backgrounds/settings_background.png'),
    ),);
  }

}