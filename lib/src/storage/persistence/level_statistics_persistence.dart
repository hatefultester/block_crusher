
abstract class LevelStatisticsPersistence {
  Future<int> getHighestLevelReached();
  Future<void> saveHighestLevelReached(int level);

  Future<int> getTotalPlayedTimeInSeconds();
  Future<void> saveTotalPlayedTimeInSeconds(int totalPlayedTimeInSeconds);

  Future<int> getWinRate();
  Future<int> getLoseRate();
  Future<int> getDeathRate();

  Future<void> saveWinRate(int winRate);
  Future<void> saveDeathRate(int deathRate);
  Future<void> saveLoseRate(int loseRate);

}
