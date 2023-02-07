import 'dart:async';

import 'package:block_crusher/src/storage/game_achievements/achievements.dart';
import 'package:block_crusher/src/storage/game_achievements/persistence/game_achievements_persistence.dart';
import 'package:flutter/foundation.dart';

import '../../style/custom_snack_bars/game_achievement_snack_bar.dart';

class GameAchievements extends ChangeNotifier {
  final GameAchievementsPersistence _store;
  Map<GameAchievement, bool> _achievements = {};

  GameAchievements(GameAchievementsPersistence store) : _store = store;

  Map<GameAchievement, bool> get achievements => _achievements;

  void openNewAchievement(GameAchievement achievement) {
    _achievements[achievement] = true;
    showAchievementSnackBar(achievement);
    unawaited(_store.unlockAchievement(achievement));
  }

  bool isAchievementOpen(GameAchievement achievement) {
    return _achievements[achievement] ?? false;
  }

  Future<void> getLatestFromStore() async {
    for (var element in GameAchievement.values) {
      _achievements[element] = await _store.isAchievementUnlocked(element);
    }
  }



  void reset() async {
    for (int i = 0; i < GameAchievement.values.length; i++) {
    _achievements[GameAchievement.values[i]] = false;
    await _store.resetAchievement(GameAchievement.values[i]);
    }
    notifyListeners();
  }

  void cheat() async {
    for (int i = 0; i < GameAchievement.values.length; i++) {
      _achievements[GameAchievement.values[i]] = true;
      await _store.unlockAchievement(GameAchievement.values[i]);
    }
    notifyListeners();
  }
}
