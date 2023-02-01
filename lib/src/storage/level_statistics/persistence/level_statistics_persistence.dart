
abstract class LevelStatisticsPersistence {
  Future<int> getHighestLevelReached();
  Future<void> saveHighestLevelReached(int level);
}
