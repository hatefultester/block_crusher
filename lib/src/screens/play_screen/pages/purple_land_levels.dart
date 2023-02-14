
import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:flutter/material.dart';

import '../../../game_internals/level_logic/level_states/collector_game/world_type.dart';
import '../level_page/level_page.dart';
import '../widgets/level_box_widget.dart';
import '../widgets/line_builder.dart';

class PurpleLandLevels extends StatelessWidget {
  final int purplePageTopSectionFlex = 3;
  final int purplePageMiddleSectionFlex = 1;
  final int purplePageBottomSectionFlex = 1;

  const PurpleLandLevels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Widget> purplePageTopSection = [
      const Spacer(),
      SizedBox(
        height:  levelBoxSize*1.4 ,
        child: Row(
          children: const [
            Spacer(),
            LevelBoxWidget(id: 23, customSize: levelBoxSize*1.4,),
            Spacer(),
          ],
        ),
      ),

      const LineBuilder(direction: Direction.left, id: 25, count: 25, spacer: true)
    ];

    List<Widget> purplePageMiddleSection = [
      Row(children: const [
        Spacer(),
         LevelBoxWidget(id: 24, customSize: levelBoxSize * 1.3),
        Spacer()
      ],),
    ];

    return LevelPage(
        pageTitle: 'Purple world',
        levelDifficulty: WorldType.purpleWorld,
        topSection: purplePageTopSection,
        middleSection: purplePageMiddleSection,
        topSectionFlex: purplePageTopSectionFlex,
        middleSectionFlex: purplePageMiddleSectionFlex,
        bottomSectionFlex: purplePageBottomSectionFlex);
  }
}
