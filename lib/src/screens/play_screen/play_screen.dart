
import 'package:block_crusher/src/screens/play_screen/level_arrows.dart';
import 'package:block_crusher/src/screens/play_screen/play_screen_background_game.dart';
import 'package:block_crusher/src/screens/play_screen/play_screen_provider.dart';
import 'package:block_crusher/src/screens/play_screen/level_selection_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/ads_controller.dart';
import '../../services/ads_ids.dart';
import '../../services/banner_ad_widget.dart';
import '../../services/in_app_purchase.dart';
import 'levels_page_view.dart';
import 'play_screen_menu.dart';

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
            AdBannerWidget(),
            // nelibi se mi tam
            //LevelArrows(),
          ],
        ),
      ),
    );
  }
}

class AdBannerWidget extends StatelessWidget {
  const AdBannerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adsControllerAvailable = context.watch<AdsController?>() != null;
    final adsRemoved =
        context.watch<InAppPurchaseController?>()?.adRemoval.active ?? false;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
      if (adsControllerAvailable && !adsRemoved) ...[
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
              width: bannerAdSize.width.toDouble(),
              height: bannerAdSize.height.toDouble(),
              child: const BannerAdWidget()),
        ),

      ],
    ],);
  }
}
