
abstract class WorldUnlockManagerPersistence {

  Future<bool> isHoomyLandOpen();
  Future<bool> isSeaLandOpen();
  Future<bool> isCityLandOpen();
  Future<bool> isAlienLandOpen();
  Future<bool> isPurpleLandOpen();

  Future<void> saveHoomyLandLocked(bool value);
  Future<void> saveSeaLandLocked(bool value);
  Future<void> saveCityLandLocked(bool value);
  Future<void> saveAlienLandLocked(bool value);
  Future<void> savePurpleLandLocked(bool value);

}
