
import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/storage/level_statistics/level_statistics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../game_internals/level_logic/level_states/collector_game/world_type.dart';
import '../level_page/level_page.dart';
import '../widgets/level_box_widget.dart';
import '../widgets/line_builder.dart';

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
        height: levelBoxSize,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            SizedBox(width: pageHorizontalPadding + 20),

            /// BOX FOR LEVEL 17
            LevelBoxWidget(id: 16),

            /// LINE BUILDER FOR LEVEL 18
            LineBuilder(direction: Direction.down, id: 17, count: 20),

            /// BOX FOR LEVEL 18
            LevelBoxWidget(id: 17),

            /// LINE BUILDER TO NEXT PAGE
            Spacer(),
            ///LineBuilder(direction: Direction.down, id: 18, count: 20),
          ],
        ),
      ),
    ];

    List<Widget> hoomyPageMiddleSection = [
      const LineBuilder(direction: Direction.left, count:20, id:16),
      SizedBox(
        height: levelBoxSize,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(width: pageHorizontalPadding + 15),

            /// BOX FOR LEVEL 15
            LevelBoxWidget(id: 14),

            /// LINE BUILDER FOR LEVEL 16
            LineBuilder(id: 15, count:30, direction: Direction.up),

            /// BOX FOR LEVEL 16
            LevelBoxWidget(id: 15),

            SizedBox(
              width: pageHorizontalPadding + 10,
            )
          ],
        ),
      ),

      /// LINE BUILDER FOR LEVEL 15
      const LineBuilder(id: 14, count: 20, direction: Direction.left),
    ];

    List<Widget> hoomyPageBottomSection = [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(width: pageHorizontalPadding + 20),

          // const LineBuilder(
          //   expandable: false,
          //   width: pageHorizontalPadding + 20,
          //   height: levelBoxSize,
          //   direction: Direction.up,
          //   count:7,
          //   id: 12,
          // ),

          /// LEVEL BOX FOR LEVEL 13
          const LevelBoxWidget(id:12),

          Expanded(
            child: SizedBox(
              height: levelBoxSize,
              child: Row(
                children: const [
                  /// LINE BUILDER FOR LEVEL 14
                  LineBuilder(id: 13, count: 35, direction: Direction.up),

                  /// BOX FOR LEVEL 14
                  LevelBoxWidget(id: 13),
                ],
              ),
            ),
          ),
          const SizedBox(width: pageHorizontalPadding),
        ],
      )
    ];

    return LevelPage(
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
