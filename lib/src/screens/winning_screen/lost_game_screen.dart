// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:block_crusher/src/google_play/ads/ads_controller.dart';
import 'package:block_crusher/src/google_play/ads/banner_ad_widget.dart';
import 'package:block_crusher/src/google_play/in_app_purchase/in_app_purchase.dart';
import 'package:block_crusher/src/screens/winning_screen/background.dart';
import 'package:block_crusher/src/settings/audio/audio_controller.dart';
import 'package:block_crusher/src/settings/audio/sounds.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../google_play/games_services/score.dart';
import '../../style/responsive_screen.dart';
import '../play_session/scenarios/game_play_statistics.dart';

class LostGameScreen extends StatelessWidget {
  final GamePlayStatistics score;

  const LostGameScreen({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final adsControllerAvailable = context.watch<AdsController?>() != null;
    final adsRemoved =
        context.watch<InAppPurchaseController?>()?.adRemoval.active ?? false;

    const gap = SizedBox(height: 10);

    if(adsControllerAvailable) {
      // var adsController = AdsController(MobileAds.instance);

      //adsController.takePreloadedAd();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          GameWidget(game: LostBackground()),
          ResponsiveScreen(
            squarishMainArea: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                if (adsControllerAvailable && !adsRemoved) ...[
                  const Expanded(
                    child: Center(
                      child: BannerAdWidget(),
                    ),
                  ),
                ],
                gap,
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.35),
                      spreadRadius: 8,
                      blurRadius: 16,
                      offset: const Offset(4, 8), // changes position of shadow
                    ), ],
                  ),
                  child: Column(children: [const Center(
                    child: Text(
                      'Game lost',
                      style: TextStyle(fontFamily: 'Quikhand', fontSize: 50, color: Colors.white),
                    ),
                  ),
                    gap,
                    Center(
                      child: Text(
                        'Played time: ${score.formattedTime}',
                        style: const TextStyle(
                            fontFamily: 'Quikhand', color: Colors.white, fontSize: 30),
                      ),
                    ),],),
                ),

                const SizedBox(height: 50),
              ],
            ),
            rectangularMenuArea: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: 300,
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      final audio = context.read<AudioController>();
                      audio.playSfx(SfxType.buttonTap);
                      GoRouter.of(context).go('/play');
                    },
                    child: const Text('E X I T'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: 300,
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      final audio = context.read<AudioController>();
                      audio.playSfx(SfxType.buttonTap);
                      GoRouter.of(context).go('/play/session/${score.level}/0');
                    },
                    child: const Text('P L A Y  A G A I N'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


