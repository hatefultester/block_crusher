// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'player_progress_persistence.dart';

/// An in-memory implementation of [PlayerProgressPersistence].
/// Useful for testing.
class MemoryOnlyPlayerProgressPersistence implements PlayerProgressPersistence {
  int level = 0;

  int coinCount = 0;

  bool hoomyLandUnlocked = false;

  bool seaLandUnlocked = false;

  bool cityLandUnlocked = false;

  @override
  Future<int> getHighestLevelReached() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return level;
  }

  @override
  Future<void> saveCoinCount(int value) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    coinCount = value;
  }

  @override
  Future<int> getCoinCount() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return coinCount;
  }

  @override
  Future<void> saveHighestLevelReached(int level) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    this.level = level;
  }

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
}
