import 'package:block_crusher/src/services/score.dart';
import 'package:block_crusher/src/screens/profile_screen/profile_container.dart';
import 'package:block_crusher/src/storage/level_statistics.dart';
import 'package:block_crusher/src/storage/player_inventory.dart';
import 'package:block_crusher/src/storage/treasure_counter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileActionButtonSection extends StatelessWidget {
  const ProfileActionButtonSection({Key? key, required this.backgroundColor, required this.textColor}) : super(key: key);

  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final levelStatistics = context.watch<LevelStatistics>();
    final playedTime = Duration(seconds : levelStatistics.totalPlayedTimeInSeconds);
    final playerInventory = context.watch<PlayerInventory>();
    final treasureCounter = context.watch<TreasureCounter>();

    return Align(
      alignment: Alignment.center,
      child: ProfileContainer(
          width: 350,
          height: 220,
          color: backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StatisticsLine(title: 'Wallet', value: treasureCounter.coinCount.toString(), color: textColor, path: 'assets/images/coins/1000x677/money.png'),
              _StatisticsLine(title: 'Played time', value: playedTime.toFormattedString(), color: textColor, path: 'assets/images/in_app/clock.png'),
              _StatisticsLine(title: 'Current level', value: levelStatistics.highestLevelReached.toString(), color: textColor, path: 'assets/images/asterisks.png'),

            ],
          )
      ),
    );
  }
}

class _StatisticsLine extends StatelessWidget {
  final String title;
  final String path;
  final String value;
  final Color color;

  const _StatisticsLine({Key? key, required this.title, required this.value, required this.color, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          SizedBox(
              width: 140,
              child: Text(title, style: TextStyle(fontSize: 30, color: color),)),
          const Spacer(),
          Container(height: 40, width: 1, color: color),
          const Spacer(),
          SizedBox(
              width: 120,
              child: Row(
                children: [
                  const Spacer(),
                  Text(value, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: color)),
                  const Spacer(),
                  SizedBox(width:30, child: Image.asset(path)),
                ],
              )),
          const SizedBox(width: 15,),
        ],
      ),
    );
  }
}
