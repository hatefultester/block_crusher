// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:animated_background/animated_background.dart';
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

class WinGameScreen extends StatefulWidget {
  final GamePlayStatistics score;

  const WinGameScreen({
    super.key,
    required this.score,
  });

  @override
  State<WinGameScreen> createState() => _WinGameScreenState();
}

class _WinGameScreenState extends State<WinGameScreen> with SingleTickerProviderStateMixin {
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


    ParticleOptions coinParticles = const ParticleOptions(
      image: Image(
        image: AssetImage('assets/images/coins/1000x1000/coin.png'),
        width: 50,
      ),
      spawnOpacity: 0.0,
      opacityChangeRate: 0.25,
      minOpacity: 0.1,
      maxOpacity: 0.4,
      particleCount: 70,
      spawnMaxRadius: 15.0,
      spawnMaxSpeed: 100.0,
      spawnMinSpeed: 30,
      spawnMinRadius: 7.0,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          GameWidget(game: WinBackground()),
          AnimatedBackground(
            vsync: this,

            behaviour: RandomParticleBehaviour(
                options: coinParticles),
            child: ResponsiveScreen(
              squarishMainArea: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  if (adsControllerAvailable && !adsRemoved) ...[
                    const Expanded(
                      child: Center(
                        child: BannerAdWidget(),
                      ),
                    ),
                  ],

                  gap,
                  const SizedBox(height: 50),
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.35),
                        spreadRadius: 8,
                        blurRadius: 16,
                        offset: const Offset(4, 8), // changes position of shadow
                      ), ],
                    ),
                    child: Column(children: [const Center(
                      child: Text(
                        'Game won',
                        style: TextStyle(fontFamily: 'Quikhand', fontSize: 50, color: Colors.black),
                      ),
                    ),
                      gap,
                      Center(
                        child: Text(
                          'Played time: ${widget.score.formattedTime}',
                          style: const TextStyle(
                              fontFamily: 'Quikhand', color: Colors.black, fontSize: 30),
                        ),
                      ),],),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 50),
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
                            GoRouter.of(context).go('/play/session/${widget.score.level+1}/0');
                          },
                          child: const Text('C O N T I N U E'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
              rectangularMenuArea: const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}


