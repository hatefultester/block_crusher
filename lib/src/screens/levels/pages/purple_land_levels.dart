
import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/game_internals/level_logic/levels.dart';
import 'package:block_crusher/src/screens/levels/level_selection_data.dart';
import 'package:block_crusher/src/screens/levels/widgets/level_box_widget.dart';
import 'package:block_crusher/src/screens/levels/widgets/level_page_view_child.dart';
import 'package:block_crusher/src/screens/levels/widgets/line_builder.dart';
import 'package:flutter/material.dart';

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
          children: [
            LineBuilder(width: pageHorizontalPadding + 50, expandable: false, direction: Direction.down, id: 23, count: 15),
            const LevelBoxWidget(id: 23),
            LineBuilder(width: pageHorizontalPadding + 125, direction: Direction.down, id: 24, count: 21),
            const LevelBoxWidget(id: 24),
            SizedBox(width:pageHorizontalPadding),
          ],
        ),
      ),
      const LineBuilder(direction: Direction.left, id: 25, count: 25, offset: 9,)
    ];

    return LevelPageViewChild(
        pageTitle: 'Purple world',
        levelDifficulty: LevelDifficulty.purpleWorld,
        topSection: purplePageTopSection,
        topSectionFlex: purplePageTopSectionFlex,
        middleSectionFlex: purplePageMiddleSectionFlex,
        bottomSectionFlex: purplePageBottomSectionFlex);
  }
}
