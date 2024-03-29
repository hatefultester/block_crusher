
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

class PurpleLandLevels extends StatelessWidget {
  final int purplePageTopSectionFlex = 3;
  final int purplePageMiddleSectionFlex = 1;
  final int purplePageBottomSectionFlex = 3;


  const PurpleLandLevels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Widget> purplePageTopSection = [
      const Spacer(),
      SizedBox(
        height:  customBoxSize ,
        child: Row(
          children: const [
            SizedBox(width: levelBoxSize),
            LevelBoxWidget(id: 23),
            LineBuilder(direction: Direction.up, id: 24, count: 9,),
            LevelBoxWidget(id: 24, customSize: customBoxSize, sideImagePath: sideImagePathCounter,),
            Spacer(),
          ],
        ),
      ),
    ];

    List<Widget> purplePageMiddleSection = [
      LineBuilder(direction: Direction.left, id: 25, count:11, offset: levelBoxSize.toInt()-20),
      SizedBox(
        height:  customBoxSize ,
        child: Row(
          children: const [
            SizedBox(width: levelBoxSize),
            LevelBoxWidget(id: 25, customSize: customBoxSize, sideImagePath: sideImagePathCounter,),
            Spacer()
          ],
        ),
      ),
      LineBuilder(direction: Direction.left, id: 26, count: 11, offset: levelBoxSize.toInt() - 20),
    ];

    List<Widget> purplePageBottomSection = [

      SizedBox(
        height:  customBoxSize ,
        child: Row(
          children: const [
            SizedBox(width: levelBoxSize),
            LevelBoxWidget(id: 26, customSize: customBoxSize, sideImagePath: sideImagePathCounter,),
            Spacer()
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
