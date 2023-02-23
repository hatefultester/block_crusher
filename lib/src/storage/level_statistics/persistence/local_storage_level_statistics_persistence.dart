
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

  @override
  Future<int> getTotalPlayedTimeInSeconds() async {
    final prefs = await instanceFuture;
    return prefs.getInt('totalPlayedTimeInSeconds') ?? 0;
  }

  @override
  Future<void> saveTotalPlayedTimeInSeconds(int totalPlayedTimeInSeconds) async {
    final prefs = await instanceFuture;
    await prefs.setInt('totalPlayedTimeInSeconds', totalPlayedTimeInSeconds);
  }

  @override
  Future<int> getDeathRate()  async {
    final prefs = await instanceFuture;
    return prefs.getInt('deathRate') ?? 0;
  }

  @override
  Future<int> getLoseRate() async  {
    final prefs = await instanceFuture;
    return prefs.getInt('loseRate') ?? 0;
  }

  @override
  Future<int> getWinRate() async {
    final prefs = await instanceFuture;
    return prefs.getInt('winRate') ?? 0;
  }

  @override
  Future<void> saveDeathRate(int deathRate) async {
    final prefs = await instanceFuture;
    await prefs.setInt('deathRate', deathRate);
  }

  @override
  Future<void> saveLoseRate(int loseRate) async {
    final prefs = await instanceFuture;
    await prefs.setInt('loseRate', loseRate);
  }

  @override
  Future<void> saveWinRate(int winRate
      )async  {
    final prefs = await instanceFuture;
    await prefs.setInt('winRate', winRate);
  }

}
