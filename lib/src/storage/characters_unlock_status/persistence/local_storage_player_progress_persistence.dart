
import 'package:block_crusher/src/storage/characters_unlock_status/persistence/player_progress_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageCharacterManagerPersistence extends CharacterManagerPersistence {
  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();
}
