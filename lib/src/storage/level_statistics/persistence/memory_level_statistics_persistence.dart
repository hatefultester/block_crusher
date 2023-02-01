import 'package:block_crusher/src/storage/level_statistics/persistence/level_statistics_persistence.dart';

class MemoryOnlyLevelStatisticsPersistence implements LevelStatisticsPersistence {
  int level = 0;

  @override
  Future<int> getHighestLevelReached() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return level;
  }

  @override
  Future<void> saveHighestLevelReached(int level) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    this.level = level;
  }

}
