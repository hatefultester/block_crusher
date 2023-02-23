
import 'package:block_crusher/src/game/collector_game_helper.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class WinAnimationWidget extends FlameGame {
  @override
  Future<void> onLoad() async {
    await add(AnimationCharacter());
  }
}

class AnimationCharacter extends SpriteAnimationComponent with HasGameRef<WinAnimationWidget>{
  Direction direction = Direction.right;

  @override
  Future<void>? onLoad() async{
    super.onLoad();
    animation = SpriteAnimation.spriteList([
      await gameRef.loadSprite('animation/o_0000.png'),
      await gameRef.loadSprite('animation/o_0001.png'),
      await gameRef.loadSprite('animation/o_0002.png'),
      await gameRef.loadSprite('animation/o_0003.png'),
      await gameRef.loadSprite('animation/o_0004.png'),
      await gameRef.loadSprite('animation/o_0005.png'),
      await gameRef.loadSprite('animation/o_0006.png'),
      await gameRef.loadSprite('animation/o_0007.png'),
      await gameRef.loadSprite('animation/o_0008.png'),
      await gameRef.loadSprite('animation/o_0009.png'),
    ], stepTime: 0.2);
    size = Vector2(100,150);
    position= Vector2(0, 150);
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    if (direction == Direction.left) x--;
    if (direction == Direction.right) x++;

    if (x > (gameRef.size.x - size.x)) {
      direction = Direction.left;
    }
    if (x < 0) {
      direction = Direction.right;
    }
  }
}