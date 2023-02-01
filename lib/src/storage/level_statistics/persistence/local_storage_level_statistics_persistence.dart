
import 'package:block_crusher/src/storage/level_statistics/persistence/level_statistics_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageLevelStatisticsPersistence extends LevelStatisticsPersistence {
  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();

  @override
  Future<int> getHighestLevelReached() async {
    final prefs = await instanceFuture;
    return prefs.getInt('highestLevelReached') ?? 0;
  }

  @override
  Future<void> saveHighestLevelReached(int level) async {
    final prefs = await instanceFuture;
    await prefs.setInt('highestLevelReached', level);
  }

}
