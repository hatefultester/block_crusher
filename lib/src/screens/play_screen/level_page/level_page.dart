import 'package:block_crusher/src/helpers/extensions/level_open_coin_price_helper.dart';
import 'package:block_crusher/src/screens/play_screen/level_page/hidden_level/level_page_hidden_level.dart';
import 'package:block_crusher/src/storage/worlds_unlock_status/world_unlock_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../game_internals/level_logic/level_states/collector_game/world_type.dart';
import '../../../google_play/remote_config/remote_config.dart';
import '../../../storage/treasure_counts/treasure_counter.dart';
import '../../../style/custom_snack_bars/error_message_snack_bar.dart';
import 'close_level/level_page_close_level.dart';
import 'not_accessible/level_page_not_accessible.dart';
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
        required this.levelDifficulty,
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

enum WorldState {
  finished, unlocked, locked, notAccessible, unspecified, hidden
}

class LevelPageState extends State<LevelPage> {

  WorldState _state = WorldState.unspecified;

  @override
  void initState() {
    super.initState();
    _getLevelPageStateType();
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case WorldState.finished:
      case WorldState.unlocked:
        return LevelPageOpenLevel(
          topSection: widget.topSection,
          middleSection: widget.middleSection,
          bottomSection: widget.bottomSection,
          topSectionFlex: widget.topSectionFlex,
          middleSectionFlex: widget.middleSectionFlex,
          bottomSectionFlex: widget.bottomSectionFlex,
        );
      case WorldState.locked:
        return Stack(
          children: [
          LevelPageOpenLevel(
          topSection: widget.topSection,
          middleSection: widget.middleSection,
          bottomSection: widget.bottomSection,
          topSectionFlex: widget.topSectionFlex,
          middleSectionFlex: widget.middleSectionFlex,
          bottomSectionFlex: widget.bottomSectionFlex,
        ),
            LevelPageCloseLevel(
              title: widget.pageTitle,
              levelDifficulty: widget.levelDifficulty,
              onBuy: _handleLevelBought,
              onError: _handleLevelBoughtError,
            ),
          ],
        );
      case WorldState.notAccessible:
        return  Stack(
          children: [
          LevelPageOpenLevel(
          topSection: widget.topSection,
          middleSection: widget.middleSection,
          bottomSection: widget.bottomSection,
          topSectionFlex: widget.topSectionFlex,
          middleSectionFlex: widget.middleSectionFlex,
          bottomSectionFlex: widget.bottomSectionFlex,
        ), const LevelPageNotAccessible(),],);
      case WorldState.unspecified:
        return const SizedBox.shrink();
      case WorldState.hidden:
        return const LevelPageHidden();
    }
  }

  _handleLevelBought(Duration? delay) async {
    final remoteConfig = context.read<RemoteConfigProvider>();
    final treasureCounter = context.read<TreasureCounter>();
    final unlockManager = context.read<WorldUnlockManager>();

    unlockManager.unlockWorld(widget.levelDifficulty);
    treasureCounter
        .decreaseCoinCount(widget.levelDifficulty.coinPrice(remoteConfig));

    await Future.delayed(delay ?? const Duration(milliseconds: 100));

    setState(() {
      _getLevelPageStateType();
    });
  }

  _handleLevelBoughtError() {
    showErrorMessageSnackBar('You can\'t afford this purchase yet', 'Not enough coins');
  }

  _getLevelPageStateType() {
    final unlockManager = context.read<WorldUnlockManager>();
    final worldOpened = unlockManager.isWorldUnlocked(widget.levelDifficulty);

    if (worldOpened) {
      _state = WorldState.unlocked;
      return;
    }

    if (!worldOpened) {
      final canBeOpened = unlockManager.canBeOpened(widget.levelDifficulty);

      if (!canBeOpened) {
        final isHidden = unlockManager.isHiddenLevel(widget.levelDifficulty);
        if(isHidden) {
          _state = WorldState.hidden;
        } else {
          _state = WorldState.notAccessible;
        }
      }

      if (canBeOpened) {
        _state = WorldState.locked;
      }
    }
  }
}


