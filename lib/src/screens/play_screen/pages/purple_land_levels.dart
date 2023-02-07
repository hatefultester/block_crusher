
import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:flutter/material.dart';

import '../../../game_internals/level_logic/level_states/collector_game/world_type.dart';
import '../level_page_helper_widgets/level_page.dart';
import '../widgets/level_box_widget.dart';
import '../widgets/line_builder.dart';

class PurpleLandLevels extends StatelessWidget {
  final int purplePageTopSectionFlex = 1;
  final int purplePageMiddleSectionFlex = 1;
  final int purplePageBottomSectionFlex = 1;

  const PurpleLandLevels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Widget> purplePageTopSection = [
      const Spacer(),
      SizedBox(
        height:  levelBoxSize - 20,
        child: Row(
          children: const [
            LineBuilder(width: pageHorizontalPadding + 50, expandable: false, direction: Direction.down, id: 23, count: 15),
            LevelBoxWidget(id: 23),
            LineBuilder(width: pageHorizontalPadding + 125, direction: Direction.down, id: 24, count: 21),
            LevelBoxWidget(id: 24),
            SizedBox(width:pageHorizontalPadding),
          ],
        ),
      ),
      const LineBuilder(direction: Direction.left, id: 25, count: 25, offset: 9,)
    ];

    return LevelPage(
        pageTitle: 'Purple world',
        levelDifficulty: WorldType.purpleWorld,
        topSection: purplePageTopSection,
        topSectionFlex: purplePageTopSectionFlex,
        middleSectionFlex: purplePageMiddleSectionFlex,
        bottomSectionFlex: purplePageBottomSectionFlex);
  }
}
