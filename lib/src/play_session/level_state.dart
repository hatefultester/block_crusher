// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';

/// An extremely silly example of a game state.
///
/// Tracks only a single variable, [score], and calls [onWin] when
/// the value of [score] reaches [goal].
class LevelState extends ChangeNotifier {
  final VoidCallback onWin;
  final VoidCallback onDie;

  final int goal;

  final int maxLives;

  late int _lives;
  int get lives => _lives;

  int _score = 0;
  int get score => _score;

  LevelState(
      {required this.onWin,
      required this.onDie,
      this.goal = 100,
      this.maxLives = 10}) {
    _lives = maxLives;
  }

  void setProgress(int value) {
    _score = value;
    notifyListeners();
  }

  void decreaseLife() {
    _lives--;
    notifyListeners();
  }

  void evaluate() {
    if (_score >= goal) {
      onWin();
    }
    if (_lives <= 0) {
      onDie();
    }
  }
}
