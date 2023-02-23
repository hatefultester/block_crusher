
import 'package:block_crusher/src/game/collector_game_helper.dart';
import 'package:block_crusher/src/storage/level_statistics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../game/world_type.dart';
import 'level_page.dart';
import 'level_box_widget.dart';
import 'line_builder.dart';

class SharkLandLevels extends StatelessWidget {

  final int seaPageTopSectionFlex = 6;
  final int seaPageMiddleSectionFlex = 12;
  final int seaPageBottomSectionFlex = 8;

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
          children: const [

            SizedBox(width: pageHorizontalPadding + 10),

            /// LEVEL 7 BOX
            LevelBoxWidget(id: 6),

            Spacer(),
          ],
        ),
      ),
    ];

    List<Widget> seaPageMiddleSection = [

      const LineBuilder(direction: Direction.left, id: 7, count: 11),

      SizedBox(
        height: levelBoxSize,
        child: Row(
          children: const [
            SizedBox(
              width: pageHorizontalPadding + 15,
            ),

            /// BOX FOR LEVEL 8
            LevelBoxWidget(id: 7),

            Spacer(),
          ],
        ),
      ),
      const LineBuilder(direction: Direction.left, id:8, count:11),
      SizedBox(
        height: levelBoxSize,
        child: Row(
          children: const [

            SizedBox(
              width: pageHorizontalPadding + 5,
            ),

            /// BOX FOR LEVEL 9
            LevelBoxWidget(id: 8),

            Spacer(),
            // LINE BUILDER FOR LEVEL 12
            // LineBuilder(id: 11, count:30, direction: Direction.up),

            /// BOX FOR LEVEL 12
            LevelBoxWidget(id:11),


            SizedBox(width: pageHorizontalPadding + 30),
            /// LINE BUILDER FOR NEXT PAGE LEVEL 13
            // LineBuilder(
            //   expandable: false,
            //   height: levelBoxSize,
            //   width: pageHorizontalPadding + levelBoxSize / 2 + 10,
            //   direction: Direction.up,
            //   id:12, count: 15,
            // ),
          ],
        ),
      ),

      SizedBox(
        height: levelBoxSize,
        width: double.infinity,
        child: Stack(
          children: const [
            LineBuilder(expandable: false, height: levelBoxSize, direction: Direction.left, count: 11, id: 9,),
            LineBuilder(expandable: false, height: levelBoxSize, direction: Direction.right, count: 11, id: 11, offset: 30),
          ],
        ),
      ),
    ];

    List<Widget> seaPageBottomSection = [
      SizedBox(
        height: levelBoxSize,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(width: pageHorizontalPadding),

            /// BOX FOR LEVEL 10
            LevelBoxWidget(id: 9),

            /// LINE BUILDER FOR LEVEL 11
            LineBuilder(expandable: true, width: pageHorizontalPadding + levelBoxSize / 2 + 10,direction: Direction.up, count: 30, id: 10),

            /// BOX FOR LEVEL 11
            LevelBoxWidget(id: 10),
            SizedBox(width: pageHorizontalPadding + 30)


            // Expanded(
            //   child: SizedBox(
            //     height: levelBoxSize,
            //     child: Row(children: const [
            //       LineBuilder(expandable: false, width: pageHorizontalPadding + levelBoxSize / 2 + 10,direction: Direction.up, count: 15, id: 10),
            //       LevelBoxWidget(id: 10),
            //       SizedBox(width: pageHorizontalPadding + 25)
            //     ]),
            //   ),
            // )
          ],
        ),
      ),
      const Spacer(),
    ];

    return LevelPage(
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
