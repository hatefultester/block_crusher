
import 'package:block_crusher/src/screens/play_screen/widgets/level_arrows.dart';
import 'package:block_crusher/src/screens/play_screen/widgets/play_screen_background_game.dart';
import 'package:block_crusher/src/screens/play_screen/play_screen_provider.dart';
import 'package:block_crusher/src/screens/play_screen/widgets/level_selection_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'level_page/levels_page_view.dart';
import 'widgets/play_screen_menu.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<PlayScreenProvider>(
            create: (context) {
              return PlayScreenProvider(
                pageController: PageController(),
                backgroundGame: LevelSelectionBackground(0),
              );
            }
          )
        ],
        child: Stack(
          children: const [
            PlayScreenBackgroundGame(),
            LevelsPageView(),
            TopLayerWidget(),
            LevelArrows(),
          ],
        ),
      ),
    );
  }
}
