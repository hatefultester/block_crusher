
import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/screens/levels/level_selection_data.dart';
import 'package:block_crusher/src/screens/levels/widgets/level_box_widget.dart';
import 'package:block_crusher/src/screens/levels/widgets/line_builder.dart';
import 'package:block_crusher/src/storage/level_statistics/level_statistics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../game_internals/level_logic/level_states/collector_game/world_type.dart';
import '../level_page_helper_widgets/level_page.dart';

class SoomyLandLevels extends StatelessWidget {
  final int soomyPageTopSectionFlex = 1;
  final int soomyPageMiddleSectionFlex = 1;
  final int soomyPageBottomSectionFlex = 1;

  const SoomyLandLevels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelStatistics = context.watch<LevelStatistics>();

    List<Widget> soomyPageTopSection = [
      const LineBuilder(id: 0, direction: Direction.left, count: 30),
      SizedBox(
        height: levelStatistics.highestLevelReached == 0 ||
                levelStatistics.highestLevelReached == 1
            ? levelBoxSize
            : levelBoxSize - 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: pageHorizontalPadding,
            ),
            const LevelBoxWidget(id: 0),
            const LineBuilder(
              id: 1,
              count: 30,
              direction: Direction.down,
            ),
            const LevelBoxWidget(id: 1),
            SizedBox(
              width: pageHorizontalPadding + 20,
            ),
          ],
        ),
      ),
    ];

    List<Widget> soomyPageMiddleSection = [
      const LineBuilder(
        direction: Direction.right,
        count: 20,
        id: 2,
      ),
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
            const LevelBoxWidget(id: 3),
            const LineBuilder(id: 3, direction: Direction.up, count: 30),
            const LevelBoxWidget(id: 2),
            SizedBox(
              width: pageHorizontalPadding + 10,
            )
          ],
        ),
      ),
      const LineBuilder(count: 20, direction: Direction.left, id: 4),
    ];

    List<Widget> soomyPageBottomSection = [
      SizedBox(
        height: levelStatistics.highestLevelReached == 4 ||
                levelStatistics.highestLevelReached == 5
            ? levelBoxSize
            : levelBoxSize - 20,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: pageHorizontalPadding + 10,
            ),
            const LevelBoxWidget(id: 4),
            Expanded(
              child: Row(
                children: const [
                  LineBuilder(count: 35, direction: Direction.up, id: 5),
                  LevelBoxWidget(id: 5),
                ],
              ),
            ),
            LineBuilder(
              expandable: false,
              height: double.infinity,
              width: pageHorizontalPadding + 25,
              direction: Direction.up,
              count: 6,
              id: 6,
              offset: -20,
            ),
          ],
        ),
      ),
    ];

    return LevelPage(
        pageTitle: 'Soomy world',
        levelDifficulty: WorldType.soomyLand,
        topSection: soomyPageTopSection,
        middleSection: soomyPageMiddleSection,
        bottomSection: soomyPageBottomSection,
        topSectionFlex: soomyPageTopSectionFlex,
        middleSectionFlex: soomyPageMiddleSectionFlex,
        bottomSectionFlex: soomyPageBottomSectionFlex);
  }
}
