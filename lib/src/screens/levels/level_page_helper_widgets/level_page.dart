import 'package:block_crusher/src/google_play/remote_config/remote_config.dart';
import 'package:block_crusher/src/screens/levels/level_page_helper_widgets/level_page_view_child_close_level_builder.dart';
import 'package:block_crusher/src/screens/levels/level_page_helper_widgets/level_page_view_child_open_level_builder.dart';
import 'package:block_crusher/src/settings/audio/audio_controller.dart';
import 'package:block_crusher/src/storage/worlds_unlock_status/world_unlock_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../game_internals/level_logic/level_states/collector_game/world_type.dart';

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
    final audioController = context.read<AudioController>();
    final unlockManager = context.read<WorldUnlockManager>();
    final levelOpened = unlockManager.isWorldUnlocked(widget.levelDifficulty);
    final remoteConfig = context.read<RemoteConfig>();


    if (levelOpened || opened) {
      return buildOpenLevel();
    }

    return buildCloseLevel(audioController);
  }
}


