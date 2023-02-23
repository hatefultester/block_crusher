
import 'package:block_crusher/src/game/collector_game_helper.dart';
import 'package:block_crusher/src/storage/level_statistics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../game/world_type.dart';
import 'level_page.dart';
import 'level_box_widget.dart';
import 'line_builder.dart';

class AlienLandLevels extends StatelessWidget {
  final int alienPageTopSectionFlex = 5;
  final int alienPageMiddleSectionFlex = 1;
  final int alienPageBottomSectionFlex = 1;

  const AlienLandLevels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelStatistics = context.watch<LevelStatistics>();

    List<Widget> alienPageTopSection = [
      SizedBox(
        height: levelBoxSize * 1.5,
        child: Row(
          children: const [
            Spacer(),
             LevelBoxWidget(id: 31, customSize: levelBoxSize*1.5 ,),
          Spacer(),
          ],
        ),
      ),
    ];

    return LevelPage(
      pageTitle: 'Alien land',
        levelDifficulty: WorldType.alien,
        topSection: alienPageTopSection,
        topSectionFlex: alienPageTopSectionFlex,
        middleSectionFlex: alienPageMiddleSectionFlex,
        bottomSectionFlex: alienPageBottomSectionFlex);
  }
}
