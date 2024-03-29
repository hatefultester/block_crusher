import 'package:block_crusher/src/services/score.dart';
import 'package:block_crusher/src/screens/profile_screen/profile_container.dart';
import 'package:block_crusher/src/storage/level_statistics.dart';
import 'package:block_crusher/src/storage/player_inventory.dart';
import 'package:block_crusher/src/storage/treasure_counter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileStatisticsSection extends StatelessWidget {
  const ProfileStatisticsSection({Key? key, required this.backgroundColor, required this.textColor}) : super(key: key);

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
          height: 440,
          color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          _StatisticsLine(title: 'Played time', value: playedTime.toFormattedString(), color: textColor, path: 'assets/images/in_app/clock.png'),
          _StatisticsLine(title: 'Wallet', value: treasureCounter.coinCount.toString(), color: textColor, path: 'assets/images/coins/1000x677/money.png'),
          _StatisticsLine(title: 'Current level', value: levelStatistics.highestLevelReached.toString(), color: textColor, path: 'assets/images/asterisks.png'),
          _StatisticsLine(title: 'Wins', value: levelStatistics.winRate.toString(), color: textColor, path: 'assets/images/in_app/win.png'),
          _StatisticsLine(title: 'Deaths', value: levelStatistics.deathRate.toString(), color: textColor, path: 'assets/images/in_app/death_heart.png'),
          _StatisticsLine(title: 'Gave up\'s', value: levelStatistics.loseRate.toString(), color: textColor, path: 'assets/images/in_app/neutral_smile.png'),

        ],
      )
      ),
    );
  }
}

class ProfileWallet extends StatelessWidget {
  final double width;

  const ProfileWallet({Key? key, this.width =  280}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final treasureCounter = context.watch<TreasureCounter>();

    return ProfileContainer(height: 60, width: width, child: _StatisticsLine(
        padding: EdgeInsets.all(4),
        value: treasureCounter.coinCount.toString(), color: Colors.black, path: 'assets/images/coins/1000x677/money.png'),
        color: Colors.white,);
  }
}

const EdgeInsets _settingsLinePadding = EdgeInsets.all(12);

class _StatisticsLine extends StatelessWidget {
  final String? title;
  final String path;
  final String value;
  final Color color;

  final EdgeInsets padding;

  const _StatisticsLine({Key? key,this.padding = _settingsLinePadding, this.title, required this.value, required this.color, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:padding,
      child: Row(
        children: [
          title == null ? SizedBox.shrink() : SizedBox(
              width: 140,
              child: Text(title!, style: TextStyle(fontSize: 30, ),)),
          const Spacer(),
          title == null ? SizedBox.shrink() : Container(height: 40, width: 1, color: color),
          const Spacer(),
          SizedBox(
              width: 120,
              child: Row(
                children: [
                  const Spacer(),
                  Text(value, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, )),
                  const Spacer(),
                  SizedBox(width:30, child: Image.asset(path)),
                  title == null ? const Spacer() : const SizedBox.shrink(),
                ],
              )),
         title == null ? const Spacer() : const SizedBox(width: 15,),
        ],
      ),
    );
  }
}
