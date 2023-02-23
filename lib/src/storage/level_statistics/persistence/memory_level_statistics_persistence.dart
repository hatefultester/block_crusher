import 'package:block_crusher/src/storage/level_statistics/persistence/level_statistics_persistence.dart';

class MemoryOnlyLevelStatisticsPersistence implements LevelStatisticsPersistence {
  int level = 0;
  int totalPlayedTimeInSeconds = 0;
  int winRate = 0;
  int loseRate = 0;
  int deathRate = 0;

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

  @override
  Future<int> getTotalPlayedTimeInSeconds() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return totalPlayedTimeInSeconds;
  }

  @override
  Future<void> saveTotalPlayedTimeInSeconds(int totalPlayedTimeInSeconds) async{
    await Future<void>.delayed(const Duration(milliseconds: 500));
    this.totalPlayedTimeInSeconds = totalPlayedTimeInSeconds;
  }

  @override
  Future<int> getDeathRate() {
    // TODO: implement getDeathRate
    throw UnimplementedError();
  }

  @override
  Future<int> getLoseRate() {
    // TODO: implement getLoseRate
    throw UnimplementedError();
  }

  @override
  Future<int> getWinRate() {
    // TODO: implement getWinRate
    throw UnimplementedError();
  }

  @override
  Future<void> saveDeathRate(int deathRate) async{
    await Future<void>.delayed(const Duration(milliseconds: 500));
    this.deathRate = deathRate;
  }

  @override
  Future<void> saveLoseRate(int loseRate) async{
    await Future<void>.delayed(const Duration(milliseconds: 500));
    this.loseRate = loseRate;
  }

  @override
  Future<void> saveWinRate(int winRate
      ) async{
    await Future<void>.delayed(const Duration(milliseconds: 500));
    this.winRate = winRate;
  }

}
