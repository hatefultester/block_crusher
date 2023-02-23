
import 'package:block_crusher/src/storage/persistence/world_unlock_manager_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageWorldUnlockManagerPersistence extends WorldUnlockManagerPersistence {
  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();

  @override
  Future<bool> isCityLandOpen() async{
    final prefs = await instanceFuture;
    return prefs.getBool('cityLandLockedStatus') ?? false;
  }

  @override
  Future<bool> isHoomyLandOpen() async{
    final prefs = await instanceFuture;
    return prefs.getBool('hoomyLandLockedStatus') ?? false;
  }

  @override
  Future<bool> isSeaLandOpen() async{
    final prefs = await instanceFuture;
    return prefs.getBool('seaLandLockedStatus') ?? false;
  }

  @override
  Future<void> saveCityLandLocked(bool value) async{
    final prefs = await instanceFuture;
    await prefs.setBool('cityLandLockedStatus', value);
  }

  @override
  Future<void> saveHoomyLandLocked(bool value) async{
    final prefs = await instanceFuture;
    await prefs.setBool('hoomyLandLockedStatus', value);
  }

  @override
  Future<void> saveSeaLandLocked(bool value) async {
    final prefs = await instanceFuture;
    await prefs.setBool('seaLandLockedStatus', value);
  }

  @override
  Future<bool> isAlienLandOpen() async {
    final prefs = await instanceFuture;
    return prefs.getBool('alienLandLockedStatus') ?? false;
  }

  @override
  Future<bool> isPurpleLandOpen() async {
    final prefs = await instanceFuture;
    return prefs.getBool('purpleLandLockedStatus') ?? false;
  }

  @override
  Future<void> saveAlienLandLocked(bool value) async {
    final prefs = await instanceFuture;
    await prefs.setBool('alienLandLockedStatus', value);
  }

  @override
  Future<void> savePurpleLandLocked(bool value) async {
    final prefs = await instanceFuture;
    await prefs.setBool('purpleLandLockedStatus', value);
  }

}
