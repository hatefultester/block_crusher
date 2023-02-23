
abstract class TreasureCounterPersistence {
  Future<int> getCoinCount();
  Future<void> saveCoinCount(int value);

  Future<int> getNutCount();
  Future<void> saveNutCount(int value);

  Future<int> getTegrommCount();
  Future<void> saveTegrommCount(int value);
}
