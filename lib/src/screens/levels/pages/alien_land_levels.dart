
import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/levels.dart';
import 'package:block_crusher/src/screens/levels/level_selection_data.dart';
import 'package:block_crusher/src/screens/levels/widgets/level_box_widget.dart';
import 'package:block_crusher/src/screens/levels/widgets/level_page_view_child.dart';
import 'package:block_crusher/src/screens/levels/widgets/line_builder.dart';
import 'package:block_crusher/src/storage/level_statistics/level_statistics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../game_internals/level_logic/level_states/collector_game/world_type.dart';

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
          children: [
            LineBuilder(width: pageHorizontalPadding + 50, expandable: false, direction: Direction.down, id: 25, count: 15),
            const LevelBoxWidget(id: 25),
          ],
        ),
      ),
    ];

    return LevelPageViewChild(
      pageTitle: 'Alien land',
        levelDifficulty: WorldType.alien,
        topSection: alienPageTopSection,
        topSectionFlex: alienPageTopSectionFlex,
        middleSectionFlex: alienPageMiddleSectionFlex,
        bottomSectionFlex: alienPageBottomSectionFlex);
  }
}
