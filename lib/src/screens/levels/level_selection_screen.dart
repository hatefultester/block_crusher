
import 'package:block_crusher/src/screens/levels/background_game_part.dart';
import 'package:block_crusher/src/screens/levels/level_page_helper_widgets/level_page_view_child_menu.dart';
import 'package:block_crusher/src/screens/levels/level_page_helper_widgets/levels_page_view.dart';
import 'package:block_crusher/src/screens/levels/level_screen_state.dart';
import 'package:block_crusher/src/screens/levels/widgets/level_selection_background.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<LevelScreenState>(
            create: (context) {
              return LevelScreenState(
                pageController: PageController(),
                backgroundGame: LevelSelectionBackground(0),
              );
            }
          )
        ],
        child: Stack(
          children: const [
            BackgroundGamePart(),
            LevelsPageView(),
            TopLayerWidget(),
          ],
        ),
      ),
    );
  }
}
