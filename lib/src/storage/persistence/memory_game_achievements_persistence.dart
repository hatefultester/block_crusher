

import 'package:block_crusher/src/storage/achievements.dart';
import 'game_achievements_persistence.dart';

class MemoryOnlyGameAchievementsPersistence implements GameAchievementsPersistence {

  Map<GameAchievement, bool> achievements = {};

  MemoryOnlyGameAchievementsPersistence() {
    for (int i = 0; i < GameAchievement.values.length; i++) {
      achievements[GameAchievement.values[i]] = false;
    }
  }

  @override
  Future<bool> isAchievementUnlocked(GameAchievement achievement) async {
    await Future<void>.delayed(const Duration(milliseconds: 500),);
    return achievements[achievement] ?? false;
  }

  @override
  Future<void> unlockAchievement(GameAchievement achievement) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    achievements[achievement] = true;
  }

  @override
  Future<void> resetAchievement(GameAchievement achievement) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    achievements[achievement] = false;
  }
}
