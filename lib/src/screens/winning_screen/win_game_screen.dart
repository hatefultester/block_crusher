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
          GameWidget(game: WinBackground()),
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
                            'New character !',
                            style: TextStyle(fontFamily: 'Quikhand', fontSize: 35, color: Colors.black),
                          ),
                        ),
                      ),

                          const SizedBox(height:15),

                          Center(
                            child: AnimatedContainer(
                              duration:const Duration(seconds: 2),
                              width: duringAnimation ?  80 : 30,
                              child: Image.asset('assets/images/${charactersForInventory[widget.score.winningCharacter]['source']}')
                            )
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Played time:',
                                style: TextStyle(
                                    fontFamily: 'Quikhand', color: Colors.black, fontSize: 25),
                              ),
                              const Spacer(),
                              Text(
                                widget.score.formattedTime,
                                style: const TextStyle(
                                    fontFamily: 'Quikhand', color: Colors.black, fontSize: 30),
                              ),
                              const SizedBox(width: 15),
                              SizedBox(width: 50,child: Image.asset('assets/images/in_app/clock.png'),),
                            ],
                          ),
                          const SizedBox(height:15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Earned:',
                                style: TextStyle(
                                    fontFamily: 'Quikhand', color: Colors.black, fontSize: 25),
                              ),
                              const Spacer(),
                              Text(
                                widget.score.coinCount.toString(),
                                style: const TextStyle(
                                    fontFamily: 'Quikhand', color: Colors.black, fontSize: 30),
                              ),
                              const SizedBox(width: 15),
                              SizedBox(width: 50,child: Image.asset('assets/images/coins/1000x677/money.png'),),
                            ],
                          ),
                        ],),
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 50),
                      Visibility(
                        visible: nextLevelVisible(widget.score.level+1),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: 300,
                          height: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              final audio = context.read<AudioController>();
                              audio.playSfx(SfxType.buttonTap);
                              GoRouter.of(context).go('/play/session/${widget.score.level+1}/0');
                            },
                            child: const Text('Continue playing', style: TextStyle(
                              fontWeight: FontWeight.w600, letterSpacing: 2,
                            ),),
                          ),
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
                            audio.playSfx(SfxType.buttonTap);
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




