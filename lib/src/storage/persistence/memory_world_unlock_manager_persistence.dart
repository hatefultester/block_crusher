
import 'package:block_crusher/src/storage/persistence/world_unlock_manager_persistence.dart';

class MemoryOnlyWorldUnlockManagerPersistence implements WorldUnlockManagerPersistence {
  bool hoomyLandUnlocked = false;
  bool seaLandUnlocked = false;
  bool cityLandUnlocked = false;
  bool alienLandUnlocked = false;
  bool purpleLandUnlocked = false;
  bool purpleLandMathUnlocked = false;

  @override
  Future<bool> isCityLandOpen() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return cityLandUnlocked;
  }

  @override
  Future<bool> isHoomyLandOpen() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return hoomyLandUnlocked;
  }

  @override
  Future<bool> isSeaLandOpen() async{
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return seaLandUnlocked;
  }

  @override
  Future<void> saveCityLandLocked(bool value) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    cityLandUnlocked = value;
  }

  @override
  Future<void> saveHoomyLandLocked(bool value) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    hoomyLandUnlocked = value;
  }

  @override
  Future<void> saveSeaLandLocked(bool value) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    seaLandUnlocked = value;
  }

  @override
  Future<bool> isAlienLandOpen() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return alienLandUnlocked;
  }

  @override
  Future<bool> isPurpleLandOpen() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return purpleLandUnlocked;
  }

  @override
  Future<bool> isPurpleLandMathOpen() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return purpleLandMathUnlocked;
  }

  @override
  Future<void> saveAlienLandLocked(bool value) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    alienLandUnlocked = value;
  }

  @override
  Future<void> savePurpleLandLocked(bool value) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    purpleLandUnlocked = value;
  }

  @override
  Future<void> savePurpleLandMathLocked(bool value) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    purpleLandMathUnlocked = value;
  }
}
