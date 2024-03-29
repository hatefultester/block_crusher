import 'package:block_crusher/src/game/collector_game_helper.dart';
import 'package:flutter/material.dart';

import '../../game/world_type.dart';
import 'level_page.dart';
import 'level_box_widget.dart';
import 'line_builder.dart';

class CityLandLevels extends StatelessWidget {
  final int cityPageTopSectionFlex = 12;
  final int cityPageMiddleSectionFlex = 8;
  final int cityPageBottomSectionFlex = 8;

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
            SizedBox(width: pageHorizontalPadding + 50),

            /// BOX FOR LEVEL 22
            LevelBoxWidget(id: 21),

            /// LINE BUILDER FOR LEVEL 23
            LineBuilder(direction: Direction.up, id: 21, count: 20),

            /// BOX LEVEL FOR LEVEL 23
            LevelBoxWidget(id: 22),

            SizedBox(width: pageHorizontalPadding + 30)
          ],
        ),
      ),

      /// LINE BUILDER FOR LEVEL 22
      const LineBuilder(
        height: 100,
        expandable: false,
        direction: Direction.left,
        id: 21,
        count: 15,
        offset: 30,
      )
    ];

    List<Widget> cityPageMiddleSection = [
      SizedBox(
        height: levelBoxSize - 20,
        child: Row(
          children: const [
            SizedBox(width: pageHorizontalPadding + 30),
            LevelBoxWidget(id: 20)
          ],
        ),
      ),
      const LineBuilder(
        direction: Direction.left,
        id: 20,
        count: 15,
        offset: 40,
      ),
      SizedBox(
        height: levelBoxSize - 20,
        child: Row(
          children: [
            const SizedBox(width: pageHorizontalPadding + 50),
            // LineBuilder(
            //   width: pageHorizontalPadding + 60,
            //   height: levelBoxSize,
            //   expandable: false,
            //   direction: Direction.down,
            //   count: 13,
            //   offset: 8,
            //   id: 18,
            // ),
            Row(
              children: const [
                LevelBoxWidget(
                  id: 18,
                ),

                LineBuilder(id: 19, direction: Direction.up, count: 15, expandable: false, width: 80),

                LevelBoxWidget(id: 19),
              ],
            ),
          ],
        ),
      ),
    ];

    List<Widget> cityPageBottomSection = [
      // const LineBuilder(
      //     direction: Direction.left, id: 19, count: 15, offset: 30,
      // ),
      // SizedBox(
      //   height: levelBoxSize - 20,
      //   child: Row(
      //     children: const [
      //       SizedBox(width: pageHorizontalPadding + 50),
      //       LevelBoxWidget(id: 19),
      //       Spacer(),
      //     ],
      //   ),
      // ),
      const SizedBox(height: 60 + 5 * pageHorizontalPadding),
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
