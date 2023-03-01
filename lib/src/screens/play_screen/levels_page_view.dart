
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'alien_land_levels.dart';
import 'city_land_levels.dart';
import 'hoomy_land_levels.dart';
import 'purple_land_counter_levels.dart';
import 'purple_land_levels.dart';
import 'shark_land_levels.dart';
import 'soomy_land_levels.dart';
import 'play_screen_provider.dart';

class LevelsPageView extends StatelessWidget {
  const LevelsPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelScreenState = context.read<PlayScreenProvider>();

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
        PurpleLandCounterLevels(),
        AlienLandLevels(),
      ],
    );
  }
}
