
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/levels.dart';
import 'package:flutter/material.dart';

import '../../../game_internals/level_logic/level_states/collector_game/world_type.dart';

extension ItemBackgroundColorIdentifier on WorldType {
  Color getItemBackgroundColor() {
    switch(this) {
      case WorldType.soomyLand:
       return Colors.redAccent;

      case WorldType.hoomyLand:
       return Colors.black;

      case WorldType.seaLand:
        return Colors.blueAccent;

      case WorldType.cityLand:
        return Colors.yellow.shade100;

      case WorldType.purpleWorld:
        return Colors.purple;

      case WorldType.alien:
        return Colors.green;

    }
  }

  Color getItemTextColor() {
    switch (this) {

      case WorldType.soomyLand:
        return Colors.white;

      case WorldType.hoomyLand:
        return Colors.white;

      case WorldType.seaLand:
        return Colors.black;

      case WorldType.cityLand:
        return Colors.black;
      case WorldType.purpleWorld:
        return Colors.white;
      case WorldType.alien:
        return Colors.white;
    }
  }
}