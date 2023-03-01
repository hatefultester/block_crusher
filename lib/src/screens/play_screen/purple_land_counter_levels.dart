
import 'package:block_crusher/src/game/collector_game_helper.dart';
import 'package:flutter/material.dart';

import '../../game/world_type.dart';
import 'level_page.dart';
import 'level_box_widget.dart';
import 'line_builder.dart';


const double customBoxSize = 80;
const int maxMiddleSize = 300;
const String sideImagePathTrippie = "assets/images/enemy/trippie/1000x850/trippie_closed_mouth.png";
const String sideImagePathCounter = "assets/images/characters_skill_game/13_1200x600.png";

class PurpleLandCounterLevels extends StatelessWidget {
  final int purplePageTopSectionFlex = 3;
  final int purplePageMiddleSectionFlex = 1;
  final int purplePageBottomSectionFlex = 3;


  const PurpleLandCounterLevels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Widget> purplePageTopSection = [
      const Spacer(),
      SizedBox(
        height:  customBoxSize ,
        child: Row(
          children: const [

            Spacer(),
            LevelBoxWidget(id: 27),
            LineBuilder(direction: Direction.up, id: 28, count: 9,),
            LevelBoxWidget(id: 28, customSize: customBoxSize, sideImagePath: sideImagePathCounter,),
            SizedBox(width: levelBoxSize),
          ],
        ),
      ),
    ];

    List<Widget> purplePageMiddleSection = [
      LineBuilder(direction: Direction.right, id: 29, count:11, offset: levelBoxSize.toInt()-20),
      SizedBox(
        height:  customBoxSize ,
        child: Row(
          children: const [
            Spacer(),
            LevelBoxWidget(id: 29, customSize: customBoxSize, sideImagePath: sideImagePathCounter,),
            SizedBox(width: levelBoxSize),
          ],
        ),
      ),
      LineBuilder(direction: Direction.right, id: 30, count: 11, offset: levelBoxSize.toInt() - 20),
    ];

    List<Widget> purplePageBottomSection = [

      SizedBox(
        height:  customBoxSize ,
        child: Row(
          children: const [
            Spacer(),
            LevelBoxWidget(id: 30, customSize: customBoxSize, sideImagePath: sideImagePathCounter,),
            SizedBox(width: levelBoxSize),
          ],
        ),
      ),

      const Spacer(),
    ];

    return LevelPage(
      pageTitle: 'Math world',
      levelDifficulty: WorldType.purpleWorldMath,
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
