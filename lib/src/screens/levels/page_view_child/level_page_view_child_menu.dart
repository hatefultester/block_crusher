import 'dart:io';

import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/world_type.dart';
import 'package:block_crusher/src/screens/play_session/styles/item_background_color_extension.dart';
import 'package:block_crusher/src/settings/audio/audio_controller.dart';
import 'package:block_crusher/src/settings/audio/sounds.dart';
import 'package:block_crusher/src/storage/treasure_counts/treasure_counter.dart';
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
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          decoration: BoxDecoration(
            color: worldType.getItemBackgroundColor(),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 4,
                blurRadius: 8,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            border: Border.all(
              width: 1,
              color: worldType.getItemTextColor().withOpacity(0.7),
            ),
          ),
          height: 80,
          width: 200,
          padding: const EdgeInsets.only(left: 15, right: 15),
          margin: const EdgeInsets.all(15),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  treasureCounter.coinCount.toString(),
                  style: TextStyle(
                      color: worldType.getItemTextColor(), fontSize: 25),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
                  width: 35,
                  height: 35,
                  child: Image.asset('assets/images/coins/1000x1000/coin.png'),
                ),
              ),
              LevelPageViewChildPopUpMenuButton(
                worldType: worldType,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LevelPageViewChildPopUpMenuButton extends StatelessWidget {
  final WorldType worldType;

  const LevelPageViewChildPopUpMenuButton({Key? key, required this.worldType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioController = context.read<AudioController>();

    return PopupMenuButton(
      icon: Icon(
        Icons.menu,
        color: worldType.getItemTextColor(),
        size: 25,
      ),
      color: worldType.getItemBackgroundColor(),
      onOpened: () {
        audioController.playSfx(SfxType.buttonTap);
      },
      onCanceled: () {
        audioController.playSfx(SfxType.buttonTap);
      },
      onSelected: ((value) {
        audioController.playSfx(SfxType.buttonTap);
        if (value == 0) {
          Navigator.pop(context);
        }
        if (value == 1) {
          GoRouter.of(context).go('/play/settings');
        }
        if (value == 2) {
          GoRouter.of(context).go('/play/profile');
        }
      }),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<int>(
            value: 2,
            child: Text(
              'Profile',
              style: TextStyle(
                color: worldType.getItemTextColor(),
              ),
            ),
          ),
          PopupMenuItem<int>(
            value: 1,
            child: Text(
              'Settings',
              style: TextStyle(
                color: worldType.getItemTextColor(),
              ),
            ),
          ),
          PopupMenuItem<int>(
            value: 0,
            child: Text(
              'Exit',
              style: TextStyle(
                color: worldType.getItemTextColor(),
              ),
            ),
          ),
        ];
      },
    );
  }
}
