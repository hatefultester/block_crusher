import 'package:block_crusher/src/screens/levels/level_screen_state.dart';
import 'package:block_crusher/src/screens/levels/pages/alien_land_levels.dart';
import 'package:block_crusher/src/screens/levels/pages/city_land_levels.dart';
import 'package:block_crusher/src/screens/levels/pages/hoomy_land_levels.dart';
import 'package:block_crusher/src/screens/levels/pages/purple_land_levels.dart';
import 'package:block_crusher/src/screens/levels/pages/shark_land_levels.dart';
import 'package:block_crusher/src/screens/levels/pages/soomy_land_levels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LevelsPageView extends StatelessWidget {
  const LevelsPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelScreenState = context.read<LevelScreenState>();

    return PageView(
      controller: levelScreenState.pageController,
      onPageChanged: (int page) {
        levelScreenState.pageSwitched(page);
      },
      children: const [
        SoomyLandLevels(),
        SharkLandLevels(),
        HoomyLandLevels(),
        CityLandLevels(),
        PurpleLandLevels(),
        AlienLandLevels(),
      ],
    );
  }
}
