import 'dart:io';

import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/levels.dart';
import 'package:block_crusher/src/google_play/remote_config/remote_config.dart';
import 'package:block_crusher/src/screens/play_session/styles/item_background_color_extension.dart';
import 'package:block_crusher/src/settings/audio/audio_controller.dart';
import 'package:block_crusher/src/settings/audio/sounds.dart';
import 'package:block_crusher/src/storage/treasure_counts/treasure_counter.dart';
import 'package:block_crusher/src/storage/worlds_unlock_status/world_unlock_manager.dart';
import 'package:block_crusher/src/style/confetti.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../game_internals/level_logic/level_states/collector_game/world_type.dart';


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

  final WorldType levelDifficulty;


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
    final unlockManager = context.read<WorldUnlockManager>();

    final levelOpened = unlockManager.isWorldUnlocked(widget.levelDifficulty);


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
    final treasureCounter = context.read<TreasureCounter>();

    if (treasureCounter.coinCount < widget.levelDifficulty.coinPrice() ) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        const SnackBar(
            content: Text('You don\'t have enough coins :( '),),
      );
      return;
    }

    await Future<void>.delayed(_preCelebrationDuration);
    if (!mounted) return;

    final unlockManager = context.read<WorldUnlockManager>();

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


    await unlockManager.unlockWorld(widget.levelDifficulty);
    treasureCounter.decreaseCoinCount(widget.levelDifficulty.coinPrice());
  }
}

extension CoinPriceExtension on WorldType {
  int coinPrice() {
    switch(this) {
      case WorldType.soomyLand:
        return 0;
      case WorldType.purpleWorld:
        return RemoteConfigService.to.getPurpleLandCoinPrice();
      case WorldType.alien:
        return RemoteConfigService.to.getAlienLandCoinPrice();
      case WorldType.hoomyLand:
        return RemoteConfigService.to.getHoomyLandCoinPrice();
      case WorldType.seaLand:
        return RemoteConfigService.to.getSeaLandCoinPrice();
      case WorldType.cityLand:
        return RemoteConfigService.to.getCityLandCoinPrice();
    }
  }
}

class TopLayerWidget extends StatelessWidget {
  final WorldType levelDifficulty;
  final String pageTitle;

  const TopLayerWidget({Key? key, required this.levelDifficulty, required this.pageTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final treasureCounter = context.watch<TreasureCounter>();

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
                        child: Text(treasureCounter.coinCount.toString(), style: TextStyle(color: levelDifficulty.getItemTextColor(), fontSize: 25),),
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
  final WorldType levelDifficulty;

  const BottomLayerWidget({Key? key, required this.levelDifficulty}) : super(key: key);

  @override
  Widget build(BuildContext context) {

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

  }
}

extension StringDescriptionExtension on WorldType{
  String descriptionOfWorld() {
    return "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";

  }
}