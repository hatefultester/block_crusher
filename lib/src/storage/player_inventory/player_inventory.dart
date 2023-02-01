
import 'dart:async';

import 'package:block_crusher/src/storage/player_inventory/persistence/player_inventory_persistence.dart';
import 'package:flutter/foundation.dart';

import '../../screens/profile_screen/profile_background_color.dart';

class PlayerInventory extends ChangeNotifier {
  final PlayerInventoryPersistence _store;
  final int maximumBackgroundColorForProfileIndex = profileBackgroundColors.length - 1;

  PlayerInventory(PlayerInventoryPersistence store) : _store = store;


  int _selectedBackgroundColorIndexForProfile = 0;
  int get selectedBackgroundColorIndexForProfile => _selectedBackgroundColorIndexForProfile;


  Future<void> getLatestFromStore() async {
    await _getLatestCoinCount();
  }

  Future<void> _getLatestCoinCount() async {
    final selectedBackgroundColorIndexForProfileFromLocalStorage = await _store.getIndexOfSelectedBackgroundColorForProfile();
    if (selectedBackgroundColorIndexForProfileFromLocalStorage != selectedBackgroundColorIndexForProfile) {
      _selectedBackgroundColorIndexForProfile = selectedBackgroundColorIndexForProfileFromLocalStorage;
      notifyListeners();
    }
  }

  void reset() async {
    _selectedBackgroundColorIndexForProfile = 0;

    notifyListeners();
    await _store.saveIndexOfSelectedBackgroundColorForProfile(_selectedBackgroundColorIndexForProfile);
  }

  void changeSelectedBackgroundColorIndexForProfile(int value) {
    _selectedBackgroundColorIndexForProfile = value;
    notifyListeners();
    unawaited(_store.saveIndexOfSelectedBackgroundColorForProfile(value));
  }

}
