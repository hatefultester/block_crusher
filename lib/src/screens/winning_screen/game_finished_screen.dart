// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:animated_background/animated_background.dart';
import 'package:block_crusher/src/database/levels.dart';
import 'package:block_crusher/src/services/ads_controller.dart';
import 'package:block_crusher/src/services/banner_ad_widget.dart';
import 'package:block_crusher/src/services/in_app_purchase.dart';
import 'package:block_crusher/src/screens/winning_screen/background.dart';
import 'package:block_crusher/src/services/audio_controller.dart';
import 'package:block_crusher/src/services/sounds.dart';
import 'package:block_crusher/src/storage/world_unlock_manager.dart';
import 'package:block_crusher/src/database/player_inventory_database.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/score.dart';
import '../../utils/responsive_screen.dart';
import '../play_session/game_play_statistics.dart';

class GameFinishedScreen extends StatefulWidget {

  const GameFinishedScreen({
    super.key
  });

  @override
  State<GameFinishedScreen> createState() => _GameFinishedScreenState();
}

class _GameFinishedScreenState extends State<GameFinishedScreen> with SingleTickerProviderStateMixin {


  bool duringAnimation = false;

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
      body: Stack(
        children: [
          GameWidget(game: FinishBackground()),
          AnimatedBackground(
            vsync: this,

            behaviour: RandomParticleBehaviour(
                options: coinParticles),
            child: ListView(
              children: <Widget>[

                // if (adsControllerAvailable && !adsRemoved) ...[
                //   const Expanded(
                //     child: Center(
                //       child: BannerAdWidget(),
                //     ),
                //   ),
                // ],

                const SizedBox(height: 50),
                Center(
                  child: Container(
                    width: 300,
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.35),
                        spreadRadius: 8,
                        blurRadius: 16,
                        offset: const Offset(4, 8), // changes position of shadow
                      ), ],
                    ),
                    padding: const EdgeInsets.only(top: 25, bottom: 25, left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Center(
                          child:
                          Container(
                            padding: const EdgeInsets.only(bottom:5),
                            child: Text(
                              'You won the game !',
                              style: TextStyle(fontFamily: 'Quikhand', fontSize: 35, color: Colors.black),
                            ),
                          ),
                        ),

                        const SizedBox(height:15),


                      ],),
                  ),
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
                          audio.playSfx(SfxType.buttonTapSound);
                          GoRouter.of(context).go('/play');
                        },
                        child: const Text('Back to levels', style: TextStyle(
                            fontWeight: FontWeight.normal
                        ),),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: 300,
                      height: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          final audio = context.read<AudioController>();
                          audio.playSfx(SfxType.buttonTapSound);
                          GoRouter.of(context).pushReplacement('/play/profile_market');
                        },
                        child: const Text('Go to profile',style: TextStyle(
                            fontWeight: FontWeight.normal
                        ),),
                      ),
                    ),

                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        duringAnimation = true;
      });
    });
  }

  bool nextLevelVisible(int levelId) {
    final level = gameLevels.singleWhere((e) => e.levelId == levelId);

    if(!level.openByDefault) return false;

    final worldUnlockManager = context.read<WorldUnlockManager>();

    return worldUnlockManager.isWorldUnlocked(level.worldType);
  }
}




