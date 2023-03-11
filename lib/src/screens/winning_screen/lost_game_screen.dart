// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:block_crusher/src/services/ads_controller.dart';
import 'package:block_crusher/src/services/banner_ad_widget.dart';
import 'package:block_crusher/src/screens/winning_screen/background.dart';
import 'package:block_crusher/src/services/audio_controller.dart';
import 'package:block_crusher/src/services/sounds.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/ads_ids.dart';
import '../play_session/game_play_statistics.dart';

class LostGameScreen extends StatefulWidget {
  final GamePlayStatistics score;

  const LostGameScreen({
    super.key,
    required this.score,
  });

  @override
  State<LostGameScreen> createState() => _LostGameScreenState();
}

class _LostGameScreenState extends State<LostGameScreen> {
  @override
  Widget build(BuildContext context) {
    final adsController = context.watch<AdsController>();

    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: LostBackground()),
          ListView(
            children: <Widget>[
              const SizedBox(height: 420),
              Center(
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.35),
                        spreadRadius: 8,
                        blurRadius: 16,
                        offset:
                            const Offset(4, 8), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(
                      top: 25, bottom: 25, left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: const Text(
                            'Game lost !',
                            style: TextStyle(
                                fontFamily: 'Quikhand',
                                fontSize: 35,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Played time:',
                            style: TextStyle(
                                fontFamily: 'Quikhand',
                                color: Colors.black,
                                fontSize: 25),
                          ),
                          const Spacer(),
                          Text(
                            widget.score.formattedTime,
                            style: const TextStyle(
                                fontFamily: 'Quikhand',
                                color: Colors.black,
                                fontSize: 25),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 50,
                            child:
                                Image.asset('assets/images/in_app/clock.png'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Visibility(
                        visible: widget.score.coinCount > 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Earned:',
                              style: TextStyle(
                                  fontFamily: 'Quikhand',
                                  color: Colors.black,
                                  fontSize: 25),
                            ),
                            const Spacer(),
                            Text(
                              widget.score.coinCount.toString(),
                              style: const TextStyle(
                                  fontFamily: 'Quikhand',
                                  color: Colors.black,
                                  fontSize: 25),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 50,
                              child: Image.asset(
                                  'assets/images/coins/1000x677/money.png'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                    width: bannerAdSize.width.toDouble(),
                    child: const BannerAdWidget()),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: 300,
                    height: 100,
                    child: ElevatedButton(
                      onPressed: () async {
                        final audio = context.read<AudioController>();
                        audio.playSfx(SfxType.buttonTap);

                        await adsController.showFullscreenAd(afterIntent: () {
                          GoRouter.of(context)
                              .go('/play/session/${widget.score.level}/0');
                        });


                      },
                      child: const Text('Try again'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: 300,
                    height: 100,
                    child: ElevatedButton(
                      onPressed: () async {
                        final audio = context.read<AudioController>();
                        audio.playSfx(SfxType.buttonTap);

                        await adsController.showFullscreenAd(afterIntent: () {
                          GoRouter.of(context).go('/play');
                        });

                      },
                      child: const Text('Back to levels'),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    const adsRemoved = false;

    final adsController = context.read<AdsController>();
    if (!adsRemoved) {
      adsController.loadFullscreenAd();
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      //context.watch<InAppPurchaseController?>()?.adRemoval.active ?? false;
    });
  }
}
