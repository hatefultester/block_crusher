import 'dart:io';

import 'package:block_crusher/src/game/world_type.dart';
import 'package:block_crusher/src/screens/play_session/item_background_color_extension.dart';
import 'package:block_crusher/src/services/audio_controller.dart';
import 'package:block_crusher/src/services/sounds.dart';
import 'package:block_crusher/src/storage/treasure_counter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TopLayerWidget extends StatelessWidget {
  final WorldType worldType;

  const TopLayerWidget(
      {Key? key, this.worldType = WorldType.hoomyLand})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final treasureCounter = context.watch<TreasureCounter>();

    return SafeArea(
      top: Platform.isIOS,
      child: Stack(
        children: [
          Align(alignment: Alignment.topLeft, child:
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.25),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            height: 80,
            width: 130,
            margin: const EdgeInsets.all(15),
            child: const LevelPageViewChildPopUpMenuButton(
            ),
          ),),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              decoration: BoxDecoration(
                image: const DecorationImage(
                    image: AssetImage("assets/images/in_app/box_background.png"),
                    fit: BoxFit.cover),
               // color: worldType.getItemBackgroundColor(),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.4),
                    spreadRadius: 4,
                    blurRadius: 8,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
                // border: Border.all(
                //   width: 1,
                //   color: worldType.getItemTextColor().withOpacity(0.7),
                // ),
              ),
              height: 80,
              width: 180,
              padding: const EdgeInsets.only(left: 15, right: 15),
              margin: const EdgeInsets.all(15),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          treasureCounter.coinCount.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.35,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      width: 35,
                      height: 35,
                      child: Image.asset('assets/images/coins/1000x1000/coin.png'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LevelPageViewChildPopUpMenuButton extends StatelessWidget {

  const LevelPageViewChildPopUpMenuButton({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioController = context.read<AudioController>();

    handleOpen() {
      audioController.playSfx(SfxType.buttonTap);
    }

    handleClose() {
      audioController.playSfx(SfxType.buttonTap);
    }

    handleSelectedItem(int value) {
      if (value == 0) {
        Navigator.pop(context);
      }
      if (value == 1) {
        GoRouter.of(context).go('/play/settings');
      }
      if (value == 2) {
        GoRouter.of(context).go('/play/profile');
      }
      if (value == 3) {
        GoRouter.of(context).go('/play/profile_market');
      }
    }

    return PopupMenuButton(
      icon: const _MoreButton(),
      color: Colors.black,
      onOpened: handleOpen,
      onCanceled: handleClose,
      onSelected: ((value) { handleSelectedItem(value);}),
      offset: const Offset(12, 80),
      itemBuilder: (BuildContext context) {
        return const [
          PopupMenuItem<int>(
            value: 3,
            child: _ItemText(text: 'Profile',),
          ),
           PopupMenuItem<int>(
            value: 2,
            child: _ItemText(text: 'Statistics',),
          ),
          PopupMenuItem<int>(
            value: 1,
            child: _ItemText(text: 'Settings',),
          ),
          PopupMenuItem<int>(
            value: 0,
            child: _ItemText(text: 'Exit',),
          ),
        ];
      },
    );
  }
}

class _ItemText extends StatelessWidget {
  final String text;

  const _ItemText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
      ),
    );
  }
}

class _MoreButton extends StatelessWidget {
  const _MoreButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120, height: 80, child:
    Image.asset('assets/images/in_app/more_button.png'),
    );
  }
}

