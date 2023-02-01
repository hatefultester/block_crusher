import 'dart:io';

import 'package:block_crusher/src/game_internals/level_logic/levels.dart';
import 'package:block_crusher/src/game_internals/player_progress/player_progress.dart';
import 'package:block_crusher/src/google_play/remote_config/remote_config.dart';
import 'package:block_crusher/src/screens/play_session/styles/item_background_color_extension.dart';
import 'package:block_crusher/src/settings/audio/audio_controller.dart';
import 'package:block_crusher/src/settings/audio/sounds.dart';
import 'package:block_crusher/src/style/confetti.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';


const _celebrationDuration = Duration(milliseconds: 2000);

const _preCelebrationDuration = Duration(milliseconds: 500);

class LevelPageViewChild extends StatefulWidget {
  final String pageTitle;

  final List<Widget> topSection;
  final List<Widget> middleSection;
  final List<Widget> bottomSection;

  final int topSectionFlex;
  final int middleSectionFlex;
  final int bottomSectionFlex;

  final LevelDifficulty levelDifficulty;


  const LevelPageViewChild(
      {super.key,
    required        this.levelDifficulty,
        this.topSection =  const [SizedBox.shrink()],
        this.middleSection = const [SizedBox.shrink()],
        this.bottomSection =  const [SizedBox.shrink()],
        this.topSectionFlex = 1,
        this.middleSectionFlex = 1,
        this.bottomSectionFlex = 1,
      this.pageTitle = 'Undefined name'
      });

  @override
  State<LevelPageViewChild> createState() => _LevelPageViewChildState();
}

class _LevelPageViewChildState extends State<LevelPageViewChild> {

  bool _opened = false;
  bool _duringCelebration = false;

  @override
  Widget build(BuildContext context) {
    final audioController = context.read<AudioController>();
    final playerProgress = context.read<PlayerProgress>();

    final levelOpened = playerProgress.isWorldUnlocked(widget.levelDifficulty);


    bool isOpenToBuy() {
      return false;
    }

    celebrationWidget() {
      return Visibility(
        visible: _duringCelebration,
        child: IgnorePointer(
          child: Confetti(
            isStopped: !_duringCelebration,
          ),
        ),
      );
    }

    if (levelOpened || _opened) {
      return Stack(
        children: [
          SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: widget.topSectionFlex,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: widget.topSection,
                ),
              ),
              Expanded(
                flex: widget.middleSectionFlex,
                child: Column(children: widget.middleSection),
              ),
              Expanded(
                  flex: widget.bottomSectionFlex,
                  child: Column(
                    children: widget.bottomSection,
                  ),),
            ],
          ),
    ),

          TopLayerWidget(pageTitle: widget.pageTitle, levelDifficulty: widget.levelDifficulty,),
          BottomLayerWidget(levelDifficulty: widget.levelDifficulty,),
        ],
      );
    }
    else {
          return
          Stack(
              children: [Container(
                width: double.infinity, height: double.infinity,
            color: Colors.black.withOpacity(0.7),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 350, height: 320,
                  child:
                      Container(width: 250, height: 220, margin: const EdgeInsets.all(24), decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(50),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),

                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(widget.levelDifficulty.coinPrice().toString(), style: const TextStyle(fontSize: 30, color: Colors.white),),
                              SizedBox(width: 50, height: 50, child: Image.asset('assets/images/coins/1000x1000/coin.png'),),

                            ],
                          ),

                          SizedBox(
                            height: 75, width: 250,
                            child: ElevatedButton(
                              onPressed: () {
                                audioController.playSfx(SfxType.buttonTap);
                                buy();
                              },
                              child: const Center(child: Text('O P E N', style: TextStyle(color: Colors.green),),
                            ),),
                          ),
                        ],
                      ),
                      ),

                  ),
              ),
          ),

               _duringCelebration ? Align(
                alignment: const Alignment(0,-0.7),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.2),
            spreadRadius: 4,
            blurRadius: 8,
            offset: const Offset(0, 3), // changes position of shadow
          ), ],
                  ),
                  width: 150,
                  height: 150,
                  child: Image.asset('assets/images/lock/lock_unlocked.png'),
                ),
              ) :
                Align(
                  alignment: const Alignment(0,-0.7),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.2),
                        spreadRadius: 4,
                        blurRadius: 8,
                        offset: const Offset(0, 3), // changes position of shadow
                      ), ],
                    ),
                    width: 150,
                    height: 150,
                    child: Image.asset('assets/images/lock/lock_locked.png'),
                  ),
                ),


                celebrationWidget(),
              ],);

    }
  }

  buy() async {
    final player = context.read<PlayerProgress>();
    if (player.coinCount < widget.levelDifficulty.coinPrice() ) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        const SnackBar(
            content: Text('You don\'t have enough coins :( '),),
      );
      return;
    }

    await Future<void>.delayed(_preCelebrationDuration);
    if (!mounted) return;

    final playerProgress = context.read<PlayerProgress>();
    if (!mounted) return;
    setState(() {
    _duringCelebration = true;
    });

    await Future<void>.delayed(_celebrationDuration);
    if (!mounted) return;
    setState(() {
      _duringCelebration = false;
      _opened = true;
    });


    await playerProgress.unlockWorld(widget.levelDifficulty);
  }
}

extension CoinPriceExtension on LevelDifficulty {
  coinPrice() {
    switch(this) {

      case LevelDifficulty.soomyLand:
      case LevelDifficulty.blueWorld:
        return 0;

      case LevelDifficulty.purpleWorld:
        return RemoteConfigService.to.getPurpleLandCoinPrice();
      case LevelDifficulty.alien:
        return RemoteConfigService.to.getAlienLandCoinPrice();
      case LevelDifficulty.hoomyLand:
        return RemoteConfigService.to.getHoomyLandCoinPrice();
      case LevelDifficulty.seaLand:
        return RemoteConfigService.to.getSeaLandCoinPrice();
      case LevelDifficulty.cityLand:
        return RemoteConfigService.to.getCityLandCoinPrice();
    }
  }
}

class TopLayerWidget extends StatelessWidget {
  final LevelDifficulty levelDifficulty;
  final String pageTitle;

  const TopLayerWidget({Key? key, required this.levelDifficulty, required this.pageTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioController = context.read<AudioController>();
    final playerProgress = context.read<PlayerProgress>();

    return
        SafeArea(
          top: Platform.isIOS,
          child: Container(
            margin: const EdgeInsets.all(15),
            height: 70,
            child: Stack(
               children: [

                 //   Align(
          //     alignment: Alignment.topLeft,
          //     child: Container(
          //     margin: const EdgeInsets.all(5),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(50),
          //       color: levelDifficulty.getItemBackgroundColor(),boxShadow:
          //     [
          //       BoxShadow(
          //         color: levelDifficulty.getItemBackgroundColor().withOpacity(0.4),
          //         spreadRadius: 4,
          //         blurRadius: 8,
          //         offset: const Offset(0, 3), // changes position of shadow
          //       ),
          //     ],
          //     ),
          //     height: 100,
          //     width: 60,
          //     child: PopupMenuButton(
          //       icon: Icon(
          //         Icons.menu,
          //         color: levelDifficulty.getItemTextColor(),
          //         size: 25,
          //       ),
          //       color: levelDifficulty.getItemBackgroundColor(),
          //       onSelected: ((value) {
          //         audioController.playSfx(SfxType.buttonTap);
          //         if (value == 0) {
          //           Navigator.pop(context);
          //         }
          //         if (value == 1) {
          //           GoRouter.of(context).go('/play/settings');
          //         }
          //         if (value == 2) {
          //           GoRouter.of(context).go('/play/profile');
          //         }
          //       })
          //       ,itemBuilder: (BuildContext context) { return [
          //       PopupMenuItem<int> (
          //         value: 2,
          //         child: Text('Profile', style: TextStyle(color: levelDifficulty.getItemTextColor(),),),
          //       ),
          //       PopupMenuItem<int> (
          //         value: 1,
          //         child: Text('Settings', style: TextStyle(color: levelDifficulty.getItemTextColor(),),),
          //       ),
          //
          //         PopupMenuItem<int> (
          //           value: 0,
          //           child: Text('Exit', style: TextStyle(color: levelDifficulty.getItemTextColor(),),),
          //         ),
          //     ];
          //     },
          //     ),
          // ),
          //   ),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Container(
    //                 decoration: BoxDecoration(color: levelDifficulty.getItemBackgroundColor(),
    //                 borderRadius: BorderRadius.circular(20),
    //                   boxShadow:
    //                   [
    //                     BoxShadow(
    //                       color: levelDifficulty.getItemBackgroundColor().withOpacity(0.4),
    //                       spreadRadius: 4,
    //                       blurRadius: 8,
    //                       offset: const Offset(0, 3), // changes position of shadow
    //                     ),
    //                   ],),
    //                 height: 50,
    //                 padding: const EdgeInsets.only(left: 15, right: 15),
    //                 child:
    //                     Center(
    //                       child: Text(
    //                         pageTitle,
    //                         style: TextStyle(fontSize: 35, color: levelDifficulty.getItemTextColor()),
    //                       ),
    //                     ),
    // ),
    //
    //             ],
    //           ),

                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(color: levelDifficulty.getItemBackgroundColor(),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow:
                    [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 4,
                        blurRadius: 8,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    border: Border.all(width: 1,color: levelDifficulty.getItemTextColor().withOpacity(0.7),),
                    ),
                    height: 100,
                    width: 200,
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                    [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(playerProgress.coinCount.toString(), style: TextStyle(color: levelDifficulty.getItemTextColor(), fontSize: 25),),
                      ), Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(width: 35, height: 35, child: Image.asset('assets/images/coins/1000x1000/coin.png'),),
                      ),
                    ],),
                  ),
                ),
              ],
            ),
          ),
        );
  }
}

class BottomLayerWidget extends StatelessWidget {
  final LevelDifficulty levelDifficulty;

  const BottomLayerWidget({Key? key, required this.levelDifficulty}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerProgress = context.read<PlayerProgress>();

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: SizedBox(
          height: 70,
          width: 210,
          child: MaterialButton(
            onPressed: () {
              final audio = context.read<AudioController>();
              audio.playSfx(SfxType.buttonTap);
                   GoRouter.of(context).go('/play/profile');  },
            child: Container(
              width: 200, height: 75,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 1, color: levelDifficulty.getItemTextColor().withOpacity(0.7),), color: levelDifficulty.getItemBackgroundColor(),
                boxShadow:
                [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 4,
                    blurRadius: 8,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],),
              child: Center(
                child: Text('P R O F I L E '
                , style: TextStyle(color: levelDifficulty.getItemTextColor(), fontSize: 25, fontFamily: 'Quikhand'),),
              ),
            ),
          ),
        ),
      ),
    );

    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
          height: 60,
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Your progress',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                width: 200,
                child: LinearPercentIndicator(
                  percent:
                  playerProgress.highestLevelReached / gameLevels.length,
                  lineHeight: 20,
                  width: 200,
                  backgroundColor: Colors.white,
                  linearGradient: LinearGradient(
                    end: Alignment.centerLeft,
                    begin: Alignment.centerRight,
                    colors: [
                      Colors.red,
                      Colors.red.shade400,
                      Colors.yellow.shade200,
                      Colors.yellow,
                    ],
                  ),
                  barRadius: const Radius.circular(8),
                  center: Text(
                      '${playerProgress.highestLevelReached} / ${gameLevels
                          .length}'),
                ),
              ),
              Text(playerProgress.coinCount.toString()),
            ],
          )),
    );
  }
}

extension StringDescriptionExtension on LevelDifficulty{
  String descriptionOfWorld() {
    return "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";

    switch (this) {

      case LevelDifficulty.soomyLand:
        // TODO: Handle this case.
        break;
      case LevelDifficulty.hoomyLand:
        // TODO: Handle this case.
        break;
      case LevelDifficulty.seaLand:
        // TODO: Handle this case.
        break;
      case LevelDifficulty.cityLand:
        // TODO: Handle this case.
        break;
      case LevelDifficulty.purpleWorld:
        // TODO: Handle this case.
        break;
      case LevelDifficulty.alien:
        // TODO: Handle this case.
        break;
      case LevelDifficulty.blueWorld:
        // TODO: Handle this case.
        break;
    }
  }
}