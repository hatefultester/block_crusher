import 'package:block_crusher/src/screens/play_screen/default_descriptor.dart';
import 'package:block_crusher/src/screens/play_screen/shark_descriptor.dart';
import 'package:block_crusher/src/screens/play_screen/soomy_descriptor.dart';
import 'package:block_crusher/src/storage/level_statistics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../game/world_type.dart';

class LevelSectionDescriptorBuilder extends StatelessWidget {
  final WorldType worldType;

  const LevelSectionDescriptorBuilder({Key? key, required this.worldType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();

    final statistics = context.watch<LevelStatistics>();

    switch (worldType) {
      case WorldType.soomyLand:
        return DefaultDescriptor(message: statistics.highestLevelReached <= 5 ? 'Collect all the soomy characters!' : 'This world is finished, you are awesome!');
      case WorldType.seaLand:
        return DefaultDescriptor(message: statistics.highestLevelReached <= 11  ? 'Be aware, sharks wants to eat!' : 'You are the king of the sea!');
      case WorldType.hoomyLand:
        return const DefaultDescriptor(message: 'I will try to destroy everything!',color: Colors.black, size: 25, offset: 20,);
      case WorldType.cityLand:
        return const DefaultDescriptor(message: 'Collect all the food into a tray!', offset: 60, color: Colors.yellow);
      case WorldType.purpleWorld:
        return  DefaultDescriptor(message: '', offset: 40, size: 50, color: Colors.green.shade900);
      case WorldType.alien:
        return const DefaultDescriptor(message: 'Get to the last alien and conquer a game!');
      default: return const SizedBox.shrink();
    }
  }
}
