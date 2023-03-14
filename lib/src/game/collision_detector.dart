import 'dart:math';

import 'package:block_crusher/src/game/collector_game.dart';
import 'package:block_crusher/src/game/purple_component.dart';
import 'package:block_crusher/src/game/collector_game_helper.dart';
import 'package:block_crusher/src/services/sounds.dart';
import 'package:block_crusher/src/storage/achievements.dart';
import 'package:flame/game.dart';

import 'coin_animation_effect.dart';

extension CollisionDetector on BlockCrusherGame {

  void collisionDetected(int level, Set<Vector2> intersectionPoints) {
    audioController.playSfx(SfxType.connectSound);
    final position = intersectionPoints.first;

    if (!gameAchievements.isAchievementOpen(GameAchievement.connectTwoPlayers)) {
      gameAchievements.openNewAchievement(GameAchievement.connectTwoPlayers);
    }

    if (gameMode == GameMode.purpleWorld) {
      if (purpleMode == PurpleMode.counterToFive) {

        if(level == 4) {
          state.decreaseCountdown(value: 5);
          state.increaseCoinCount(connectCoinCount * 5);
          addCoinEffect(connectCoinCount * 5);
        } else {
          state.increaseCoinCount(connectCoinCount);
          addCoinEffect(connectCoinCount);
        }
        state.evaluate();
        return;
      }
      return;
    }

    int extraBonus = 0;

    /// if you get new level you will get double points
    if (state.evaluateScore(level)) {
      extraBonus = connectCoinCount * level;
      state.increaseCoinCount(level * connectCoinCount + extraBonus);
      addCoinEffect(connectCoinCount * 5 + extraBonus);
      state.evaluate();
    }
    else {
      state.increaseCoinCount(level * connectCoinCount);
      addCoinEffect(connectCoinCount * level);
    }

    /// based on level you reached you get specific score

  }

  collectedToTray(int level) {
    audioController.playSfx(SfxType.collectToTraySound);

    state.collect(level);
    state.increaseCoinCount(level == 0 ? connectCoinCount : level * connectCoinCount);
    addCoinEffect(connectCoinCount);
    state.evaluate();
  }

  blockRemoved() {
    if(gameMode == GameMode.cityFood) return;

    state.decreaseLife();
    state.evaluate();
  }


  splitPurpleComponent(PurpleWorldComponent component, NotifyingVector2 position) async {
    if(component.lives == 0) return;

    var purpleComponentCopy = PurpleWorldComponent.copyFrom(component, Vector2(position.x, position.y), component.type);
    await add(purpleComponentCopy);
    purpleWorldComponents.add(purpleComponentCopy);
  }

  purpleComponentDestroyed(PurpleWorldComponent component) {
    var coinIncrease =  component.characterId == 0 ? 3 * connectCoinCount : connectCoinCount;

    state.decreaseCountdown();
    state.increaseCoinCount(coinIncrease);
    state.evaluate();
  }

  addCoinEffect(int count) async {

    const int effectDurationInMilliseconds = 1000;

    for (int i = 0; i < count ; i ++ ) {

      await add(CoinAnimationComponent());

      final int delay = effectDurationInMilliseconds~/count;

      await Future.delayed(Duration(milliseconds: delay));
    }
  }
}