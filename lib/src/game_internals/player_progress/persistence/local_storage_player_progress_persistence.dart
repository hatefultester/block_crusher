// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:shared_preferences/shared_preferences.dart';

import 'player_progress_persistence.dart';

/// An implementation of [PlayerProgressPersistence] that uses
/// `package:shared_preferences`.
class LocalStoragePlayerProgressPersistence extends PlayerProgressPersistence {
  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();


  @override
  Future<int> getCoinCount() async {
    final prefs = await instanceFuture;
    return prefs.getInt('coinCount') ?? 0;
  }

  @override
  Future<void> saveCoinCount(int value) async {
    final prefs = await instanceFuture;
    await prefs.setInt('coinCount', value);
  }

  @override
  Future<int> getHighestLevelReached() async {
    final prefs = await instanceFuture;
    return prefs.getInt('highestLevelReached') ?? 0;
  }

  @override
  Future<void> saveHighestLevelReached(int level) async {
    final prefs = await instanceFuture;
    await prefs.setInt('highestLevelReached', level);
  }

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
}
