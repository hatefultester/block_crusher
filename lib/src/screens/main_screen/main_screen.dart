import 'package:block_crusher/src/screens/main_screen/main_background_game.dart';
import 'package:block_crusher/src/screens/main_screen/main_heading_area.dart';
import 'package:block_crusher/src/screens/main_screen/main_menu_area.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../services/ads_controller.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var adsController = AdsController(MobileAds.instance);
   adsController.preloadBannerAd(AdType.dashboardAd);


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
