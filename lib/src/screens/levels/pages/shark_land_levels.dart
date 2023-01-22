
import 'package:block_crusher/src/game_internals/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/player_progress/player_progress.dart';
import 'package:block_crusher/src/screens/levels/level_selection_data.dart';
import 'package:block_crusher/src/screens/levels/widgets/level_box_widget.dart';
import 'package:block_crusher/src/screens/levels/widgets/level_page_view_child.dart';
import 'package:block_crusher/src/screens/levels/widgets/line_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SharkLandLevels extends StatelessWidget {

  final int seaPageTopSectionFlex = 6;
  final int seaPageMiddleSectionFlex = 9;
  final int seaPageBottomSectionFlex = 9;

  const SharkLandLevels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerProgress = context.watch<PlayerProgress>();
    List<Widget> seaPageTopSection = [
      SizedBox(
        height: levelBoxSize,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            LineBuilder(
              width: pageHorizontalPadding,
              height: levelBoxSize,
              direction: Direction.down,
              expandable: false,
              count: 4,
              id: 12,
            ),
            const LevelBoxWidget(id: 12),
            const Spacer(),
          ],
        ),
      ),
    ];

    List<Widget> seaPageMiddleSection = [

      const LineBuilder(direction: Direction.left, id: 13, count: 10),

      SizedBox(
        height:
        playerProgress.highestLevelReached == 13 ? levelBoxSize : levelBoxSize - 20,
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
      const LineBuilder(direction: Direction.left, id:14, count:10),
      SizedBox(
        height:
        playerProgress.highestLevelReached == 13 ? levelBoxSize : levelBoxSize - 20,
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
              id:18, count: 20,
            ),
          ],
        ),
      ),
      const LineBuilder(direction: Direction.left, count: 10, id: 15,),
    ];

    List<Widget> seaPageBottomSection = [
      SizedBox(
        height:
        playerProgress.highestLevelReached == 15 ? levelBoxSize : levelBoxSize - 20,
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
                  const LineBuilder(direction: Direction.up, count: 30, id: 16),
                  const LevelBoxWidget(id: 16),
                  SizedBox(width: pageHorizontalPadding + levelBoxSize / 2),
                ]),
              ),
            )
          ],
        ),
      ),
    ];

    return LevelPageViewChild(
        topSection: seaPageTopSection,
        middleSection: seaPageMiddleSection,
        bottomSection: seaPageBottomSection,
        topSectionFlex: seaPageTopSectionFlex,
        middleSectionFlex: seaPageMiddleSectionFlex,
        bottomSectionFlex: seaPageBottomSectionFlex);
  }
}
