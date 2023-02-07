
import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:flutter/material.dart';

import '../../../game_internals/level_logic/level_states/collector_game/world_type.dart';
import '../level_page/level_page.dart';
import '../widgets/level_box_widget.dart';
import '../widgets/line_builder.dart';

class CityLandLevels extends StatelessWidget {
  final int cityPageTopSectionFlex = 16;
  final int cityPageMiddleSectionFlex = 13;
  final int cityPageBottomSectionFlex = 19;

  const CityLandLevels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Widget> cityPageTopSection = [
      const Spacer(),
      SizedBox(
        height: levelBoxSize - 20,
        width: double.infinity,
        child: Row(
          children: const [
            SizedBox(width: pageHorizontalPadding + 20),
            LevelBoxWidget(id: 21),
            LineBuilder(direction: Direction.up, id: 21, count: 20),
            LevelBoxWidget(id: 22),
           SizedBox(width: pageHorizontalPadding+40, height: levelBoxSize - 20, child:
           LineBuilder(id: 23, expandable: false, count: 7, direction: Direction.down,)
           ),
          ],
        ),
      ),
      const LineBuilder(height: 80, direction: Direction.left, id: 21, count: 20, offset: 30,)
    ];

    List<Widget> cityPageMiddleSection = [
      SizedBox(height: levelBoxSize - 20,
      child: Row(
        children: const [SizedBox(width: pageHorizontalPadding + 30),
        LevelBoxWidget(id: 20)],
      ),),
      const LineBuilder(direction: Direction.left, id: 20, count: 13, offset: 40,),
      SizedBox(
        height: levelBoxSize - 20,
        child: Row(
          children: const [
            LineBuilder(width: pageHorizontalPadding + 60,
              height: levelBoxSize,
              expandable: false,
              direction: Direction.down,
              count: 13,
              offset: 8,
              id: 18,
            ),
            LevelBoxWidget(
              id: 18,
            ),
          ],
        ),
      ),

    ];

    List<Widget> cityPageBottomSection = [
      const LineBuilder(direction: Direction.left, id: 19, count: 21, offset: 30),
      SizedBox(
        height: levelBoxSize - 20,
        child: Row(
          children: const [
            SizedBox(width: pageHorizontalPadding + 50),
            LevelBoxWidget(id: 19),
            Spacer(),
          ],
        ),
      ),
      SizedBox(height: 60 + 5 * pageHorizontalPadding),
    ];

    return LevelPage(
        pageTitle: 'City World',
        levelDifficulty: WorldType.cityLand,
        topSection: cityPageTopSection,
        middleSection: cityPageMiddleSection,
        bottomSection: cityPageBottomSection,
        topSectionFlex: cityPageTopSectionFlex,
        middleSectionFlex: cityPageMiddleSectionFlex,
        bottomSectionFlex: cityPageBottomSectionFlex);
  }
}
