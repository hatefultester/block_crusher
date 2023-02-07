
import 'package:block_crusher/src/screens/play_screen/play_screen_background_game.dart';
import 'package:block_crusher/src/screens/play_screen/play_screen_provider.dart';
import 'package:block_crusher/src/screens/play_screen/widgets/level_selection_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'level_page_helper_widgets/level_page_view_child_menu.dart';
import 'level_page_helper_widgets/levels_page_view.dart';



class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldMessengerState> scaffoldMessenger = GlobalKey<ScaffoldMessengerState>();

    return Scaffold(
      key: scaffoldMessenger,
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<PlayScreenProvider>(
            create: (context) {
              return PlayScreenProvider(
                pageController: PageController(),
                backgroundGame: LevelSelectionBackground(0),
                key: scaffoldMessenger,
              );
            }
          )
        ],
        child: Stack(
          children: const [
            PlayScreenBackgroundGame(),
            LevelsPageView(),
            TopLayerWidget(),
          ],
        ),
      ),
    );
  }
}
