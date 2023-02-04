import 'package:block_crusher/src/screens/levels/page_view_child/level_open_coin_price_helper.dart';
import 'package:block_crusher/src/screens/levels/page_view_child/level_page_view_child.dart';
import 'package:block_crusher/src/storage/treasure_counts/treasure_counter.dart';
import 'package:block_crusher/src/storage/worlds_unlock_status/world_unlock_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


const _celebrationDuration = Duration(milliseconds: 2000);
const _preCelebrationDuration = Duration(milliseconds: 500);

extension ClosedLevel on LevelPageViewChildState {

  buy() async {
    final treasureCounter = context.read<TreasureCounter>();

    if (treasureCounter.coinCount < widget.levelDifficulty.coinPrice() ) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        const SnackBar(
          content: Text('You don\'t have enough coins :( '),),
      );
      return;
    }

    await Future<void>.delayed(_preCelebrationDuration);
    if (!mounted) return;

    final unlockManager = context.read<WorldUnlockManager>();

    if (!mounted) return;
    setState(() {
      duringCelebration = true;
    });

    await Future<void>.delayed(_celebrationDuration);
    if (!mounted) return;
    setState(() {
      duringCelebration = false;
      opened = true;
    });


    await unlockManager.unlockWorld(widget.levelDifficulty);
    treasureCounter.decreaseCoinCount(widget.levelDifficulty.coinPrice());
  }

}