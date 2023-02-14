import 'package:block_crusher/src/game_internals/games/collector_game/collector_game.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/purple_land/purple_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/settings/audio/sounds.dart';
import 'package:block_crusher/src/storage/game_achievements/achievements.dart';
import 'package:flame/game.dart';

extension CollisionDetector on BlockCrusherGame {

  void collisionDetected(int level) {
    audioController.playSfx(SfxType.wssh);

    if (!gameAchievements.isAchievementOpen(GameAchievement.connectTwoPlayers)) {
      gameAchievements.openNewAchievement(GameAchievement.connectTwoPlayers);
    }

    if (gameMode == GameMode.purpleWorld) {
      if (purpleMode == PurpleMode.counter) {
        state.decreaseCountdown();
        if(level == 4) {
          state.increaseCoinCount(connectCoinCount * 5);
        } else {
          state.increaseCoinCount(connectCoinCount);
        }
        state.evaluate();
        return;
      }
    }

    int extraBonus = 0;

    /// if you get new level you will get double points
    if (state.evaluateScore(level)) {
      extraBonus = connectCoinCount * level;
      state.increaseCoinCount(level * connectCoinCount + extraBonus);
      state.evaluate();
    }
    else {
      state.increaseCoinCount(level * connectCoinCount);
    }

    /// based on level you reached you get specific score

  }

  collectedToTray(int level) {
    audioController.playSfx(SfxType.kosik);

    state.collect(level);
    state.increaseCoinCount(level * connectCoinCount);
    state.evaluate();
  }

  blockRemoved() {
    if(gameMode == GameMode.cityFood) return;
    state.decreaseLife();
    state.evaluate();
  }


  splitPurpleComponent(PurpleWorldComponent component, NotifyingVector2 position) async {
    if(component.lives == 0) return;

    var purpleComponentCopy = PurpleWorldComponent.copyFrom(component, Vector2(position.x, position.y));
    await add(purpleComponentCopy);
    purpleWorldComponents.add(purpleComponentCopy);
  }

  purpleComponentDestroyed(PurpleWorldComponent component) {
    var coinIncrease =  component.characterId == 0 ? 3 * connectCoinCount : connectCoinCount;

    state.decreaseCountdown();
    state.increaseCoinCount(coinIncrease);
    state.evaluate();
  }
}