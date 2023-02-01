
import 'package:block_crusher/src/storage/game_achievements/achievements.dart';
import 'package:block_crusher/src/storage/game_achievements/persistence/game_achievements_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageGameAchievementsPersistence extends GameAchievementsPersistence {
  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();

  @override
  Future<bool> isAchievementUnlocked(GameAchievement achievement) async {
    final prefs = await instanceFuture;
    return prefs.getBool('achievement_${achievement.toString()}') ?? false;
  }

  @override
  Future<void> unlockAchievement(GameAchievement achievement) async {
    final prefs = await instanceFuture;
    await prefs.setBool('achievement_${achievement.toString()}', true);
  }

  @override
  Future<void> resetAchievement(GameAchievement achievement) async {
    final prefs = await instanceFuture;
    await prefs.setBool('achievement_${achievement.toString()}', false);
  }
}
