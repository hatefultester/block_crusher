
abstract class LevelStatisticsPersistence {
  Future<int> getHighestLevelReached();
  Future<void> saveHighestLevelReached(int level);

  Future<int> getTotalPlayedTimeInSeconds();
  Future<void> saveTotalPlayedTimeInSeconds(int totalPlayedTimeInSeconds);

}
