
import 'package:block_crusher/src/game/collector_game_helper.dart';
import 'package:block_crusher/src/storage/level_statistics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../game/world_type.dart';
import 'level_page.dart';
import 'level_box_widget.dart';
import 'line_builder.dart';

class SoomyLandLevels extends StatelessWidget {

  const SoomyLandLevels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelStatistics = context.watch<LevelStatistics>();

    const int soomyPageTopSectionFlex = 1;
    const int soomyPageMiddleSectionFlex = 1;
    const int soomyPageBottomSectionFlex = 1;

    const LevelBoxStyle boxStyle = LevelBoxStyle.rounded;

    List<Widget> soomyPageTopSection = [
      SizedBox(
        height: levelBoxSize,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            SizedBox(
              width: pageHorizontalPadding + 50,
            ),

            /// LEVEL 1
            LevelBoxWidget(id: 0, style: boxStyle,),

            /// LINE TO LEVEL 2
            LineBuilder(
              id: 1,
              count: 20,
              direction: Direction.down,
            ),

            /// LEVEL 2
            LevelBoxWidget(id: 1,style: boxStyle,),

            SizedBox(
              width: pageHorizontalPadding + 20,
            ),
          ],
        ),
      ),
    ];

    List<Widget> soomyPageMiddleSection = [

      /// LINE TO LEVEL 3
      const LineBuilder(
        direction: Direction.right,
        count: 20,
        id: 2,
      ),

      SizedBox(
        height: levelBoxSize,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(width: pageHorizontalPadding + 15),

            /// LEVEL 4
            LevelBoxWidget(id: 3,style: boxStyle,),

            /// LINE TO LEVEL 4
            LineBuilder(id: 3, direction: Direction.up, count: 30),

            /// LEVEL 3
            LevelBoxWidget(id: 2,style: boxStyle,),

            SizedBox(
              width: pageHorizontalPadding + 10,
            )
          ],
        ),
      ),

      /// LINE TO LEVEL 5
      const LineBuilder(count: 20, direction: Direction.left, id: 4),

    ];

    List<Widget> soomyPageBottomSection = [
      SizedBox(
        height: levelBoxSize,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: pageHorizontalPadding + 10,
            ),

            /// LEVEL 5
            const LevelBoxWidget(id: 4,style: boxStyle,),

            Expanded(
              child: Row(
                children: const [
                  /// LINE TO LEVEL 6
                  LineBuilder(count: 30, direction: Direction.up, id: 5),

                  /// LEVEL 6
                  LevelBoxWidget(id: 5,style: boxStyle,),
                ],
              ),
            ),

            const SizedBox(width: pageHorizontalPadding + 25),

            /// LINE TO NEXT PAGE LEVEL 7
            // const LineBuilder(
            //   expandable: false,
            //   height: double.infinity,
            //   width: pageHorizontalPadding + 25,
            //   direction: Direction.up,
            //   count: 6,
            //   id: 6,
            //   offset: -20,
            // ),
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
