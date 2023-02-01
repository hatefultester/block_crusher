import 'package:flutter/foundation.dart';

import 'persistence/player_progress_persistence.dart';

class CharacterManager extends ChangeNotifier {
  final CharacterManagerPersistence _store;

  CharacterManager(CharacterManagerPersistence store) : _store = store;

}
