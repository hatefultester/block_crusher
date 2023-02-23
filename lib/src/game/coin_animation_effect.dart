import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import 'collector_game.dart';

class CoinAnimationComponent extends SpriteComponent
    with HasGameRef<BlockCrusherGame> {


  CoinAnimationComponent();

  @override
  onLoad() async {


    final Random random = Random();
    final double increment = random.nextInt(5) + 0;
    final speedBoost = random.nextInt(5) / 10;

    final startPosition = Vector2(gameRef.size.x - 150, 80);

    sprite = await gameRef.loadSprite('coins/1000x1000/coin.png');
    size = Vector2(30 + increment, 30 +increment);
    position = startPosition;

    final destination = Vector2(gameRef.size.x - 140, 40);



    double duration = ((startPosition.x - destination.x).abs() + (startPosition.y - destination.y).abs() )/ 500;
    duration -= speedBoost;
    if (duration <= 0.1) {
      duration = 0.1;
    }

    print(duration.toString());

    MoveEffect moveEffect = MoveEffect.to(destination,
    EffectController(duration: duration),
    );

    OpacityEffect effect = OpacityEffect.to(
      0.1,
      EffectController(duration: duration * 2/3),
      onComplete: () => {removeFromParent(),},);

    add(moveEffect);
    add(effect);
  }

}