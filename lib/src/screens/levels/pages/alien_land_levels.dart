import 'package:block_crusher/src/game_internals/collector_game/components/sprite_block_component.dart';
import 'package:block_crusher/src/player_progress/player_progress.dart';
import 'package:block_crusher/src/screens/levels/level_selection_data.dart';
import 'package:block_crusher/src/screens/levels/widgets/level_box_widget.dart';
import 'package:block_crusher/src/screens/levels/widgets/level_page_view_child.dart';
import 'package:block_crusher/src/screens/levels/widgets/line_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlienLandLevels extends StatelessWidget {
  final int alienPageTopSectionFlex = 3;
  final int alienPageMiddleSectionFlex = 4;
  final int alienPageBottomSectionFlex = 4;

  const AlienLandLevels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerProgress = context.watch<PlayerProgress>();

    List<Widget> alienPageTopSection = [
      SizedBox(
        height: playerProgress.highestLevelReached == 4 ||
            playerProgress.highestLevelReached == 5
            ? levelBoxSize
            : levelBoxSize - 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(width: pageHorizontalPadding + 20),
            const LevelBoxWidget(id: 10),
            const LineBuilder(direction: Direction.down, id: 11, count: 30),
            const LevelBoxWidget(id: 11),
            const LineBuilder(direction: Direction.down, id: 12, count: 15),
          ],
        ),
      ),
    ];

    List<Widget> alienPageMiddleSection = [
      const LineBuilder(direction: Direction.left, count:30, id:10),
      SizedBox(
        height: playerProgress.highestLevelReached == 3 ||
            playerProgress.highestLevelReached == 2
            ? levelBoxSize
            : levelBoxSize - 20,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: pageHorizontalPadding + 15),
            const LevelBoxWidget(id: 8),
            const LineBuilder(id: 9, count:30, direction: Direction.up),
            const LevelBoxWidget(id: 9),
            SizedBox(
              width: pageHorizontalPadding + 10,
            )
          ],
        ),
      ),
      const LineBuilder(id: 8, count: 30, direction: Direction.left),
    ];

    List<Widget> alienPageBottomSection = [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LineBuilder(
            expandable: false,
            width: pageHorizontalPadding + 20,
            height: levelBoxSize,
            direction: Direction.up,
            count:6,
            id: 6,
          ),
          const LevelBoxWidget(id: 6),
          Expanded(
            child: SizedBox(
              height: playerProgress.highestLevelReached == 7
                  ? levelBoxSize
                  : levelBoxSize - 20,
              child: Row(
                children: const [
                  LineBuilder(id: 7, count: 35, direction: Direction.up),
                  LevelBoxWidget(id: 7),
                ],
              ),
            ),
          ),
          SizedBox(width: pageHorizontalPadding),
        ],
      )
    ];

    return LevelPageViewChild(
        topSection: alienPageTopSection,
        middleSection: alienPageMiddleSection,
        bottomSection: alienPageBottomSection,
        topSectionFlex: alienPageTopSectionFlex,
        middleSectionFlex: alienPageMiddleSectionFlex,
        bottomSectionFlex: alienPageBottomSectionFlex);
  }
}
