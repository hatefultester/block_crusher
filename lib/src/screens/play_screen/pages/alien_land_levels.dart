
import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/storage/level_statistics/level_statistics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../game_internals/level_logic/level_states/collector_game/world_type.dart';
import '../level_page_helper_widgets/level_page.dart';
import '../widgets/level_box_widget.dart';
import '../widgets/line_builder.dart';

class AlienLandLevels extends StatelessWidget {
  final int alienPageTopSectionFlex = 5;
  final int alienPageMiddleSectionFlex = 1;
  final int alienPageBottomSectionFlex = 1;

  const AlienLandLevels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelStatistics = context.watch<LevelStatistics>();

    List<Widget> alienPageTopSection = [
      SizedBox(
        height: levelStatistics.highestLevelReached == 4 ||
            levelStatistics.highestLevelReached == 5
            ? levelBoxSize
            : levelBoxSize - 20,
        child: Row(
          children: const [
            LineBuilder(width: pageHorizontalPadding + 50, expandable: false, direction: Direction.down, id: 25, count: 15),
            LevelBoxWidget(id: 25),
          ],
        ),
      ),
    ];

    return LevelPage(
      pageTitle: 'Alien land',
        levelDifficulty: WorldType.alien,
        topSection: alienPageTopSection,
        topSectionFlex: alienPageTopSectionFlex,
        middleSectionFlex: alienPageMiddleSectionFlex,
        bottomSectionFlex: alienPageBottomSectionFlex);
  }
}
