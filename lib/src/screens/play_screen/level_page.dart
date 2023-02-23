import 'package:block_crusher/src/utils/level_open_coin_price_helper.dart';
import 'package:block_crusher/src/screens/play_screen/level_page_hidden_level.dart';
import 'package:block_crusher/src/storage/world_unlock_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../game/world_type.dart';
import '../../services/remote_config.dart';
import '../../storage/treasure_counter.dart';
import '../../utils/error_message_snack_bar.dart';
import 'level_page_close_level.dart';
import 'level_page_not_accessible.dart';
import 'level_page_open_level.dart';

class LevelPage extends StatefulWidget {
  final String pageTitle;

  final List<Widget> topSection;
  final List<Widget> middleSection;
  final List<Widget> bottomSection;

  final int topSectionFlex;
  final int middleSectionFlex;
  final int bottomSectionFlex;

  final int? topSectionMaxSize;
  final int? middleSectionMaxSize;
  final int? bottomSectionMaxSize;

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
        this.pageTitle = 'Undefined name',
        this.middleSectionMaxSize,
        this.topSectionMaxSize,
        this.bottomSectionMaxSize,
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
          topSectionMaxSize: widget.topSectionMaxSize,
          middleSectionMaxSize: widget.middleSectionMaxSize,
          bottomSectionMaxSize: widget.bottomSectionMaxSize,
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
            topSectionMaxSize: widget.topSectionMaxSize,
            middleSectionMaxSize: widget.middleSectionMaxSize,
            bottomSectionMaxSize: widget.bottomSectionMaxSize,
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
            topSectionMaxSize: widget.topSectionMaxSize,
            middleSectionMaxSize: widget.middleSectionMaxSize,
            bottomSectionMaxSize: widget.bottomSectionMaxSize,
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


