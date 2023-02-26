
import 'dart:async';

import 'package:block_crusher/src/storage/persistence/player_inventory_persistence.dart';
import 'package:flutter/foundation.dart';

import '../screens/profile_screen/profile_background_color.dart';

class PlayerInventory extends ChangeNotifier {
  final PlayerInventoryPersistence _store;

  final int maximumBackgroundColorForProfileIndex = profileBackgroundColors.length - 1;

  PlayerInventory(PlayerInventoryPersistence store) : _store = store;

  int _selectedBackgroundColorIndexForProfile = 0;
  int get selectedBackgroundColorIndexForProfile => _selectedBackgroundColorIndexForProfile;

  List<String> _availableCharacters = [];
  List<String> get availableCharacters => _availableCharacters;
  List<String> _playerCharacters=[];
  List<String> get playerCharacters => _playerCharacters;

  Future<void> getLatestFromStore() async {
    final reloadBackgroundColor = await _getLatestBackgroundColor();
    final reloadPlayerCharacters = await _getLatestPlayerCharacters();
    final reloadAvailableCharacters = await _getLatestAvailableCharacters();

    if (reloadBackgroundColor || reloadAvailableCharacters || reloadPlayerCharacters) {
      notifyListeners();
    }
  }

  Future<bool> _getLatestBackgroundColor() async {
    final selectedBackgroundColorIndexForProfileFromLocalStorage = await _store.getIndexOfSelectedBackgroundColorForProfile();

    if (selectedBackgroundColorIndexForProfileFromLocalStorage != selectedBackgroundColorIndexForProfile) {
      _selectedBackgroundColorIndexForProfile = selectedBackgroundColorIndexForProfileFromLocalStorage;
      return true;
    }

    return false;
  }

  Future<bool> _getLatestPlayerCharacters() async {
    final playerCharactersFromStore = await _store.getPlayerCharacters();
    if(playerCharactersFromStore != _playerCharacters) {
      _playerCharacters = playerCharactersFromStore;
      return true;
    }
    return false;
  }

  Future<bool> _getLatestAvailableCharacters() async {
    final availableCharactersFromStore = await _store.getAvailableCharacters();

    if(availableCharactersFromStore != _availableCharacters) {
      _availableCharacters = availableCharactersFromStore;
      return true;
    }
    return false;
  }

  void reset() async {
    _selectedBackgroundColorIndexForProfile = 0;
    _playerCharacters = [];
    _availableCharacters = [];

    notifyListeners();
    await _store.saveIndexOfSelectedBackgroundColorForProfile(_selectedBackgroundColorIndexForProfile);
    await _store.savePlayerCharacters(_playerCharacters);
    await _store.saveAvailableCharacters(_availableCharacters);
  }

  void changeSelectedBackgroundColorIndexForProfile(int value) {
    _selectedBackgroundColorIndexForProfile = value;
    notifyListeners();
    unawaited(_store.saveIndexOfSelectedBackgroundColorForProfile(value));
  }

  void addNewPlayerCharacter(String character) async {
    await _getLatestPlayerCharacters();
    if(_playerCharacters.contains(character)) return;
    _playerCharacters.add(character);
    notifyListeners();
    unawaited(_store.savePlayerCharacters(_playerCharacters));
  }

  void addNewAvailableCharacter(String character) async {
    await _getLatestAvailableCharacters();
    if(_availableCharacters.contains(character)) return;
    _availableCharacters.add(character);
    notifyListeners();
    unawaited(_store.saveAvailableCharacters(_availableCharacters));
  }
}
