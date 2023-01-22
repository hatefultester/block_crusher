
import 'package:block_crusher/src/game_internals/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/player_progress/player_progress.dart';
import 'package:block_crusher/src/screens/levels/level_selection_data.dart';
import 'package:block_crusher/src/screens/levels/widgets/level_box_widget.dart';
import 'package:block_crusher/src/screens/levels/widgets/level_page_view_child.dart';
import 'package:block_crusher/src/screens/levels/widgets/line_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CityLandLevels extends StatelessWidget {
  final int cityPageTopSectionFlex = 6;
  final int cityPageMiddleSectionFlex = 9;
  final int cityPageBottomSectionFlex = 9;

  const CityLandLevels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerProgress = context.watch<PlayerProgress>();

    List<Widget> cityPageTopSection = [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const LevelBoxWidget(id: 22),
          LineBuilder(
            expandable: false,
            width: pageHorizontalPadding + 150,
            height: levelBoxSize,
            direction: Direction.up,
            id: 22,
            count: 20,
          ),
        ],
      ),
    ];

    List<Widget> cityPageMiddleSection = [
      const LineBuilder(
          direction: Direction.right, id: 22, offset: 100, count: 20),

      SizedBox(
        height: playerProgress.highestLevelReached == 13
            ? levelBoxSize
            : levelBoxSize - 20,
        child: Row(
          children: [
            const Spacer(),
            const LevelBoxWidget(id: 21),
            SizedBox(
              height: levelBoxSize,
              width: pageHorizontalPadding + 120,
            ),
          ],
        ),
      ),

      Expanded(
        child: Stack(
          children: [
            SizedBox(
              child: Row(
                children: [
                  LineBuilder(width: pageHorizontalPadding,
                    height: levelBoxSize,
                    expandable: false,
                    direction: Direction.down,
                    count: 4,
                    offset: 8,
                    id: 18,
                  ),
                  const LevelBoxWidget(
                    id: 18,
                  ),
                ],
              ),
            ),
            const LineBuilder(
              expandable: false,
              direction: Direction.right,
              count: 15,
              id: 21,
              offset: 65,
            ),
          ],
        ),
      ),

    ];

    List<Widget> cityPageBottomSection = [
      Expanded(
        child: Stack(
          children: const [
            LineBuilder(
              expandable: false,
              id: 19,
              direction: Direction.left,
              count: 15,
            ),
            LineBuilder(
                id: 21,
                expandable: false,
                offset: 65, direction: Direction.right, count: 15),
          ],
        ),
      ),
      SizedBox(
        height: playerProgress.highestLevelReached == 15
            ? levelBoxSize
            : levelBoxSize - 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: pageHorizontalPadding),
            const LevelBoxWidget(id: 19),
            Expanded(
              child: SizedBox(
                height: levelBoxSize,
                child: Row(children: [
                  const LineBuilder(id: 20, count: 30, direction: Direction.up),
                  const LevelBoxWidget(id: 20),
                  SizedBox(width: pageHorizontalPadding + 40),
                ]),
              ),
            )
          ],
        ),
      ),
      SizedBox(height: 60 + 5 * pageHorizontalPadding),
    ];

    return LevelPageViewChild(
        topSection: cityPageTopSection,
        middleSection: cityPageMiddleSection,
        bottomSection: cityPageBottomSection,
        topSectionFlex: cityPageTopSectionFlex,
        middleSectionFlex: cityPageMiddleSectionFlex,
        bottomSectionFlex: cityPageBottomSectionFlex);
  }
}
