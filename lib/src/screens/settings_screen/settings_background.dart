import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class SettingsBackground extends StatelessWidget {
  const SettingsBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: _SettingsBackgroundGame());
  }
}

class _SettingsBackgroundGame extends FlameGame {
  @override
  Future<void>? onLoad() async {
    super.onLoad();
    await add(SpriteComponent(size: Vector2(size.x, size.y), sprite: await loadSprite('backgrounds/settings_background2.png'),
    ),);
  }
}