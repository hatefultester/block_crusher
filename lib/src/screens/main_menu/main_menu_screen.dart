
import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/screens/main_menu/background.dart';
import 'package:block_crusher/src/screens/main_menu/moving_button.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';


class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {

    mainArea() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black, Colors.transparent],
                ),
              ),
              child: Text(
                'H o o m y   H o o'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                ),
                textWidthBasis: TextWidthBasis.longestLine,
              ),
            ),

            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black, Colors.transparent],
                ),
              ),
              child: Text(
                'A d v a n t u r e s'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 38,
                  color: Colors.white,
                ),
                textWidthBasis: TextWidthBasis.longestLine,
              ),
            ),

          ],
        ),
      );
    }


    menuArea() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          MovingButton(title: 'p l a y', route : '/play', millisecondSpeed: 7, x: Direction.right),
          MovingButton(title: 's e t t i n g s', route : '/settings', millisecondSpeed: 13,),
        ],
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: MainBackgroundGame()),
          //gradientWidget(),
          Column(children: [
            Expanded(flex: 2, child: mainArea(),),
            Expanded(flex: 1, child: menuArea(),),
            const SizedBox(height: 50,),
          ],),
        ],
      ),
    );
  }
}

/*

Deprecated mute sound button

Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ValueListenableBuilder<bool>(
                valueListenable: settingsController.muted,
                builder: (context, muted, child) {
                  return IconButton(
                    onPressed: () => {settingsController.toggleMuted(),
                 //   if (!muted) achievementSnackBar('Sounds muted') else achievementSnackBar('Sounds activated')
                    },
                    icon: Icon(muted ? Icons.volume_off : Icons.volume_up),
                    iconSize: 30,
                    color: Colors.white,
                  );
                },
              ),
            ),
          ),

 */

