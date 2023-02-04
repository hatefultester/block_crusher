
import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/levels.dart';
import 'package:block_crusher/src/screens/levels/level_selection_data.dart';
import 'package:block_crusher/src/screens/levels/widgets/level_box_widget.dart';
import 'package:block_crusher/src/screens/levels/page_view_child/level_page_view_child.dart';
import 'package:block_crusher/src/screens/levels/widgets/line_builder.dart';
import 'package:block_crusher/src/storage/level_statistics/level_statistics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../game_internals/level_logic/level_states/collector_game/world_type.dart';

class HoomyLandLevels extends StatelessWidget {
  final int hoomyPageTopSectionFlex = 3;
  final int hoomyPageMiddleSectionFlex = 4;
  final int hoomyPageBottomSectionFlex = 4;

  const HoomyLandLevels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelStatistics = context.watch<LevelStatistics>();

    List<Widget> hoomyPageTopSection = [
      SizedBox(
        height: levelStatistics.highestLevelReached == 4 ||
            levelStatistics.highestLevelReached == 5
            ? levelBoxSize
            : levelBoxSize - 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(width: pageHorizontalPadding + 20),
            const LevelBoxWidget(id: 16),
            const LineBuilder(direction: Direction.down, id: 17, count: 20),
            const LevelBoxWidget(id: 17),
            const LineBuilder(direction: Direction.down, id: 18, count: 20),
          ],
        ),
      ),
    ];

    List<Widget> hoomyPageMiddleSection = [
      const LineBuilder(direction: Direction.left, count:20, id:16),
      SizedBox(
        height: levelStatistics.highestLevelReached == 3 ||
            levelStatistics.highestLevelReached == 2
            ? levelBoxSize
            : levelBoxSize - 20,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: pageHorizontalPadding + 15),
            const LevelBoxWidget(id: 14),
            const LineBuilder(id: 15, count:30, direction: Direction.up),
            const LevelBoxWidget(id: 15),
            SizedBox(
              width: pageHorizontalPadding + 10,
            )
          ],
        ),
      ),
      const LineBuilder(id: 14, count: 20, direction: Direction.left),
    ];

    List<Widget> hoomyPageBottomSection = [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LineBuilder(
            expandable: false,
            width: pageHorizontalPadding + 20,
            height: levelBoxSize,
            direction: Direction.up,
            count:7,
            id: 12,
          ),
          const LevelBoxWidget(id:12),
          Expanded(
            child: SizedBox(
              height: levelStatistics.highestLevelReached == 13
                  ? levelBoxSize
                  : levelBoxSize - 20,
              child: Row(
                children: const [
                  LineBuilder(id: 13, count: 35, direction: Direction.up),
                  LevelBoxWidget(id: 13),
                ],
              ),
            ),
          ),
          SizedBox(width: pageHorizontalPadding),
        ],
      )
    ];

    return LevelPageViewChild(
        pageTitle: 'Hoomy World',
        levelDifficulty: WorldType.hoomyLand,
        topSection: hoomyPageTopSection,
        middleSection: hoomyPageMiddleSection,
        bottomSection: hoomyPageBottomSection,
        topSectionFlex: hoomyPageTopSectionFlex,
        middleSectionFlex: hoomyPageMiddleSectionFlex,
        bottomSectionFlex: hoomyPageBottomSectionFlex);
  }
}
