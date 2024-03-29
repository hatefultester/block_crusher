

import 'package:block_crusher/src/storage/achievements.dart';

abstract class GameAchievementsPersistence {
  Future<bool> isAchievementUnlocked(GameAchievement achievement);
  Future<void> unlockAchievement(GameAchievement achievement);
  Future<void> resetAchievement(GameAchievement achievement);
}
