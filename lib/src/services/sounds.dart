// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

List<String> soundTypeToFilename(SfxType type) {
  switch (type) {
    case SfxType.connectSound:
      return const [
        'lea/collect1.mp3',
        'lea/collect1.mp3',
        'lea/collect1.mp3',
        'lea/collect1.mp3',
        'lea/collect_new_best.mp3',
      ];
    case SfxType.buttonTapSound:
      return const [
        'knock.m4a'
      ];
    case SfxType.congratulationSound:
      return const ['lea/congratulations.mp3'];
    case SfxType.collectToTraySound:
      return const [
        'lea/collect_to_tray_1.mp3',
        'lea/collect_to_tray_2.mp3',
        'lea/collect_to_tray_3.mp3',
        'lea/collect_to_tray_4.mp3',
        'lea/collect_to_tray_5.mp3',
      ];
    case SfxType.lostGameSound:
      return const [
        'lea/lose.mp3',
      ];
  }
}

/// Allows control over loudness of different SFX types.
double soundTypeToVolume(SfxType type) {
  switch (type) {
    default:
      return 1;
  }
}

enum SfxType { connectSound, buttonTapSound, congratulationSound, collectToTraySound, lostGameSound }
