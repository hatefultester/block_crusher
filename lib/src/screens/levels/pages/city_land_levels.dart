
import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/screens/levels/level_selection_data.dart';
import 'package:block_crusher/src/screens/levels/widgets/level_box_widget.dart';
import 'package:block_crusher/src/screens/levels/widgets/level_page_view_child.dart';
import 'package:block_crusher/src/screens/levels/widgets/line_builder.dart';
import 'package:flutter/material.dart';

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
          children: [
            SizedBox(width: pageHorizontalPadding + 20),
            const LevelBoxWidget(id: 21),
            const LineBuilder(direction: Direction.up, id: 21, count: 20),
            const LevelBoxWidget(id: 22),
           SizedBox(width: pageHorizontalPadding+40, height: levelBoxSize - 20, child:
           const LineBuilder(id: 23, expandable: false, count: 7, direction: Direction.down,)
           ),
          ],
        ),
      ),
      const LineBuilder(height: 80, direction: Direction.left, id: 21, count: 20, offset: 30,)
    ];

    List<Widget> cityPageMiddleSection = [
      SizedBox(height: levelBoxSize - 20,
      child: Row(
        children: [SizedBox(width: pageHorizontalPadding + 30),
        const LevelBoxWidget(id: 20)],
      ),),
      const LineBuilder(direction: Direction.left, id: 20, count: 13, offset: 40,),
      SizedBox(
        height: levelBoxSize - 20,
        child: Row(
          children: [
            LineBuilder(width: pageHorizontalPadding + 60,
              height: levelBoxSize,
              expandable: false,
              direction: Direction.down,
              count: 13,
              offset: 8,
              id: 18,
            ),
            const LevelBoxWidget(
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
          children: [
            SizedBox(width: pageHorizontalPadding + 50),
            const LevelBoxWidget(id: 19),
            const Spacer(),
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
