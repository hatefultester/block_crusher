
import 'package:block_crusher/src/game_internals/level_logic/levels.dart';
import 'package:flutter/material.dart';

extension ItemBackgroundColorIdentifier on LevelDifficulty {
  Color getItemBackgroundColor() {
    switch(this) {
      case LevelDifficulty.soomyLand:
       return Colors.redAccent;

      case LevelDifficulty.hoomyLand:
       return Colors.black;

      case LevelDifficulty.seaLand:
        return Colors.blueAccent;

      case LevelDifficulty.cityLand:
        return Colors.yellow;

      case LevelDifficulty.purpleWorld:
        return Colors.purple;

      case LevelDifficulty.alien:
        return Colors.green;

      case LevelDifficulty.blueWorld:
        return Colors.blue;

    }
  }

  Color getItemTextColor() {
    switch (this) {

      case LevelDifficulty.soomyLand:
        return Colors.white;

      case LevelDifficulty.hoomyLand:
        return Colors.white;

      case LevelDifficulty.seaLand:
        return Colors.black;

      case LevelDifficulty.cityLand:
        return Colors.white;
      case LevelDifficulty.purpleWorld:
        return Colors.white;
      case LevelDifficulty.alien:
        return Colors.white;
      case LevelDifficulty.blueWorld:
        return Colors.white;
    }
  }
}