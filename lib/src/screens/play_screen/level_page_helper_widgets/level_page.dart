import 'package:block_crusher/src/helpers/extensions/level_open_coin_price_helper.dart';
import 'package:block_crusher/src/storage/worlds_unlock_status/world_unlock_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../game_internals/level_logic/level_states/collector_game/world_type.dart';
import '../../../google_play/remote_config/remote_config.dart';
import '../../../storage/treasure_counts/treasure_counter.dart';
import '../../../style/custom_snackbars/error_message_snackbar.dart';
import 'close_level/level_page_close_level.dart';
import 'open_level/level_page_open_level.dart';

class LevelPage extends StatefulWidget {
  final String pageTitle;

  final List<Widget> topSection;
  final List<Widget> middleSection;
  final List<Widget> bottomSection;

  final int topSectionFlex;
  final int middleSectionFlex;
  final int bottomSectionFlex;

  final WorldType levelDifficulty;


  const LevelPage(
      {super.key,
    required        this.levelDifficulty,
        this.topSection =  const [SizedBox.shrink()],
        this.middleSection = const [SizedBox.shrink()],
        this.bottomSection =  const [SizedBox.shrink()],
        this.topSectionFlex = 1,
        this.middleSectionFlex = 1,
        this.bottomSectionFlex = 1,
      this.pageTitle = 'Undefined name'
      });

  @override
  State<LevelPage> createState() => LevelPageState();
}

class LevelPageState extends State<LevelPage> {

  bool opened = false;
  bool duringCelebration = false;

  @override
  Widget build(BuildContext context) {
    final unlockManager = context.read<WorldUnlockManager>();
    final levelOpened = unlockManager.isWorldUnlocked(widget.levelDifficulty);

    if (levelOpened || opened) {
      return LevelPageOpenLevel(
        topSection: widget.topSection,
        middleSection: widget.middleSection,
        bottomSection: widget.bottomSection,
        topSectionFlex: widget.topSectionFlex,
        middleSectionFlex: widget.middleSectionFlex,
        bottomSectionFlex: widget.bottomSectionFlex,
      );
    } else {
      return LevelPageCloseLevel(levelDifficulty: widget.levelDifficulty, onBuy: _handleLevelBought, onError: _handleLevelBoughtError );
    }
  }

  _handleLevelBought() {
    final remoteConfig = context.read<RemoteConfigProvider>();
    final treasureCounter = context.read<TreasureCounter>();
    final unlockManager = context.read<WorldUnlockManager>();

    setState(() {
      opened = true;
    });

    unlockManager.unlockWorld(widget.levelDifficulty);
    treasureCounter
        .decreaseCoinCount(widget.levelDifficulty.coinPrice(remoteConfig));
  }

  _handleLevelBoughtError() {
    showErrorMessageSnackBar('You can\'t afford this purchase yet', 'Not enough coins');
  }
}


