
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

class SharkLandLevels extends StatelessWidget {

  final int seaPageTopSectionFlex = 6;
  final int seaPageMiddleSectionFlex = 9;
  final int seaPageBottomSectionFlex = 9;

  const SharkLandLevels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelStatistics = context.watch<LevelStatistics>();

    List<Widget> seaPageTopSection = [
      SizedBox(
        height: levelBoxSize,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            LineBuilder(
              width: pageHorizontalPadding + 15,
              height: levelBoxSize,
              direction: Direction.down,
              expandable: false,
              count: 5,
              id: 12,
            ),
            const LevelBoxWidget(id: 12),
            const Spacer(),
          ],
        ),
      ),
    ];

    List<Widget> seaPageMiddleSection = [

      const LineBuilder(direction: Direction.left, id: 13, count: 11),

      SizedBox(
        height:
        levelStatistics.highestLevelReached == 13 ? levelBoxSize : levelBoxSize - 20,
        child: Row(
          children: [
            SizedBox(
              width: pageHorizontalPadding + 15,
            ),
            const LevelBoxWidget(id: 13),
            const Spacer(),
          ],
        ),
      ),
      const LineBuilder(direction: Direction.left, id:14, count:11),
      SizedBox(
        height:
        levelStatistics.highestLevelReached == 13 ? levelBoxSize : levelBoxSize - 20,
        child: Row(
          children: [
            SizedBox(
              width: pageHorizontalPadding + 5,
            ),
            const LevelBoxWidget(id: 14),
            const LineBuilder(id: 17, count:30, direction: Direction.up),const LevelBoxWidget(id:17),
            LineBuilder(
              expandable: false,
              height: levelBoxSize,
              width: pageHorizontalPadding + levelBoxSize / 2 + 10,
              direction: Direction.up,
              id:18, count: 15,
            ),
          ],
        ),
      ),
      const LineBuilder(direction: Direction.left, count: 11, id: 15,),
    ];

    List<Widget> seaPageBottomSection = [
      SizedBox(
        height:
        levelStatistics.highestLevelReached == 15 ? levelBoxSize : levelBoxSize - 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: pageHorizontalPadding),
            const LevelBoxWidget(id: 15),
            Expanded(
              child: SizedBox(
                height: levelBoxSize,
                child: Row(children: [
                  LineBuilder(expandable: false, width: pageHorizontalPadding + levelBoxSize / 2 + 10,direction: Direction.up, count: 15, id: 16),
                  const LevelBoxWidget(id: 16),
                  const Spacer(),
                ]),
              ),
            )
          ],
        ),
      ),
    ];

    return LevelPageViewChild(
        pageTitle: 'Sea world',
        levelDifficulty: WorldType.seaLand,
        topSection: seaPageTopSection,
        middleSection: seaPageMiddleSection,
        bottomSection: seaPageBottomSection,
        topSectionFlex: seaPageTopSectionFlex,
        middleSectionFlex: seaPageMiddleSectionFlex,
        bottomSectionFlex: seaPageBottomSectionFlex);
  }
}
