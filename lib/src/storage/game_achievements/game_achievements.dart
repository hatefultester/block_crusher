import 'package:block_crusher/src/storage/game_achievements/achievements.dart';
import 'package:block_crusher/src/storage/game_achievements/persistence/game_achievements_persistence.dart';
import 'package:flutter/foundation.dart';

class GameAchievements extends ChangeNotifier {
  final GameAchievementsPersistence _store;


  Map<GameAchievement, bool> _achievements = {};


  GameAchievements(GameAchievementsPersistence store) : _store = store;


  bool isAchievementOpen(GameAchievement achievement) {
    return _achievements[achievement] ?? false;
  }

  Future<void> getLatestFromStore() async {
    await _getLatestAchievementsStatus();
  }

  Future<void> _getLatestAchievementsStatus() async {
    for (int i = 0; i < GameAchievement.values.length; i++) {
      final bool achievementMemory = await _store.isAchievementUnlocked(GameAchievement.values[i]);

      if(isAchievementOpen(GameAchievement.values[i]) && !achievementMemory) {
        await _store.unlockAchievement(GameAchievement.values[i]);
      }

      if(achievementMemory && !isAchievementOpen(GameAchievement.values[i])) {
        _achievements[GameAchievement.values[i]] = achievementMemory;
        notifyListeners();
      }
    }
  }

  void reset() async {
    for (int i = 0; i < GameAchievement.values.length; i++) {
    _achievements[GameAchievement.values[i]] = true;
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
