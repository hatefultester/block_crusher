import 'package:flame/components.dart';
import 'package:flame/game.dart';

class BlockCrusherGame extends FlameGame
    with HasCollisionDetection, HasDraggables, HasTappables {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    await add(
      SpriteComponent(
        sprite: await loadSprite('background.png'),
        size: Vector2(size.x, size.y),
      ),
    );
  }
}
