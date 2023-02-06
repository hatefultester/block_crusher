import 'package:block_crusher/src/screens/main_screen/main_background_game.dart';
import 'package:block_crusher/src/screens/main_screen/main_heading_area.dart';
import 'package:block_crusher/src/screens/main_screen/main_menu_area.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: MainBackgroundGame()),
          //gradientWidget(),
          Column(children: const [
            Expanded(flex: 2, child: MainHeadingArea(),),
            Expanded(flex: 1, child: MainMenuArea(),),
            SizedBox(height: 50,),
          ],),
        ],
      ),
    );
  }
}
