// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// An interface of persistence stores for the player's progress.
///
/// Implementations can range from simple in-memory storage through
/// local preferences to cloud saves.
abstract class PlayerProgressPersistence {
  Future<int> getHighestLevelReached();

  Future<void> saveHighestLevelReached(int level);

  Future<int> getCoinCount();

  Future<void> saveCoinCount(int value);

  Future<bool> isHoomyLandOpen();
  Future<bool> isSeaLandOpen();
  Future<bool> isCityLandOpen();

  Future<void> saveHoomyLandLocked(bool value);
  Future<void> saveSeaLandLocked(bool value);
  Future<void> saveCityLandLocked(bool value);
}
