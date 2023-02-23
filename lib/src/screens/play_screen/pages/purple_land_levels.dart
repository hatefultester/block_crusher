
import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:flutter/material.dart';

import '../../../game_internals/level_logic/level_states/collector_game/world_type.dart';
import '../level_page/level_page.dart';
import '../widgets/level_box_widget.dart';
import '../widgets/line_builder.dart';


const double customBoxSize = 80;
const int maxMiddleSize = 200;
const String sideImagePathTrippie = "assets/images/enemy/trippie/1000x850/trippie_closed_mouth.png";
const String sideImagePathCounter = "assets/images/characters_skill_game/13_1200x600.png";

class PurpleLandLevels extends StatelessWidget {
  final int purplePageTopSectionFlex = 3;
  final int purplePageMiddleSectionFlex = 1;
  final int purplePageBottomSectionFlex = 5;


  const PurpleLandLevels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Widget> purplePageTopSection = [
      const Spacer(),
      SizedBox(
        height:  customBoxSize ,
        child: Row(
          children: const [
            Spacer(),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: LevelBoxWidget(id: 23, customSize: customBoxSize, sideImagePath: sideImagePathTrippie,),
            ),
            LineBuilder(direction: Direction.up, id: 24, count: 5,),
            LevelBoxWidget(id: 24, customSize: customBoxSize, sideImagePath: sideImagePathCounter,),
            LineBuilder(direction: Direction.up, id: 24, count: 6,),
            Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: LevelBoxWidget(id: 25, customSize: customBoxSize, sideImagePath: sideImagePathTrippie,),
            ),
            const Spacer(),
          ],
        ),
      ),
    ];

    List<Widget> purplePageMiddleSection = [
      LineBuilder(direction: Direction.right, id: 26, count: 9,),
      SizedBox(
        height:  customBoxSize ,
        child: Row(
          children: const [
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 9),
              child: LevelBoxWidget(id: 28, customSize: customBoxSize, sideImagePath: sideImagePathCounter,),
            ),
            LineBuilder(direction: Direction.up, id: 28, count: 5,),
            Padding(
              padding: EdgeInsets.only(top: 2),
              child: LevelBoxWidget(id: 27, customSize: customBoxSize, sideImagePath: sideImagePathTrippie,),
            ),
            LineBuilder(direction: Direction.up, id: 27, count: 5,),
            LevelBoxWidget(id: 26, customSize: customBoxSize, sideImagePath: sideImagePathCounter,),
            Spacer(),
          ],
        ),
      ),
      LineBuilder(direction: Direction.left, id: 29, count: 9,),
    ];

    List<Widget> purplePageBottomSection = [
      SizedBox(
        height:  customBoxSize ,
        child: Row(
          children: const [
            Spacer(),
            LevelBoxWidget(id: 29, customSize: customBoxSize, sideImagePath: sideImagePathTrippie,),

            LineBuilder(direction: Direction.up, id: 30, count: 5,),
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: LevelBoxWidget(id: 30, customSize: customBoxSize, sideImagePath: sideImagePathCounter,),
            ),
            LineBuilder(direction: Direction.up, id: 31, count: 5,),
            LevelBoxWidget(id: 31, customSize: customBoxSize, sideImagePath: sideImagePathTrippie,),
            Spacer(),
          ],
        ),
      ),
      LineBuilder(direction: Direction.right, id: 32, count: 9,),
      SizedBox(
        height:  customBoxSize ,
        child: Row(
          children: const [
            Spacer(),
            LevelBoxWidget(id: 34, customSize: customBoxSize, sideImagePath: sideImagePathCounter,),
            LineBuilder(direction: Direction.up, id: 34, count: 5,),
            LevelBoxWidget(id: 33, customSize: customBoxSize, sideImagePath: sideImagePathTrippie,),
            LineBuilder(direction: Direction.up, id: 33, count: 5,),
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: LevelBoxWidget(id: 32, customSize: customBoxSize, sideImagePath: sideImagePathCounter,),
            ),
            Spacer(),
          ],
        ),
      ),
      const Spacer(),
    ];

    return LevelPage(
        pageTitle: 'Purple world',
        levelDifficulty: WorldType.purpleWorld,
        topSection: purplePageTopSection,
        middleSection: purplePageMiddleSection,
        bottomSection: purplePageBottomSection,
        topSectionFlex: purplePageTopSectionFlex,
        middleSectionFlex: purplePageMiddleSectionFlex,
        bottomSectionFlex: purplePageBottomSectionFlex,
        middleSectionMaxSize: maxMiddleSize,
    );
  }
}
