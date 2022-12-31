// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:block_crusher/src/game_internals/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';

import '../ads/ads_controller.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../level_selection/level_state.dart';
import '../games_services/games_services.dart';
import '../games_services/score.dart';
import '../in_app_purchase/in_app_purchase.dart';
import '../level_selection/levels.dart';
import '../player_progress/player_progress.dart';
import '../style/confetti.dart';
import '../style/palette.dart';

class PlaySessionScreen extends StatefulWidget {
  final GameLevel level;

  const PlaySessionScreen(this.level, {super.key});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');

  static const _celebrationDuration = Duration(milliseconds: 2000);

  static const _preCelebrationDuration = Duration(milliseconds: 500);

  bool _duringCelebration = false;

  late BlockCrusherGame _blockCrusherGame;

  late DateTime _startOfPlay;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => LevelState(
              goal: widget.level.difficulty,
              maxLives: widget.level.lives,
              onDie: _playerDie,
              onWin: _playerWon,
            ),
          ),
        ],
        child: IgnorePointer(
          ignoring: _duringCelebration,
          child: Scaffold(
            backgroundColor: palette.backgroundPlaySession,
            body: Stack(
              children: [
                _gameWidget(),
                _celebrationWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _gameWidget() {
    return Consumer<LevelState>(
      builder: (context, levelState, child) =>
          GameWidget(game: _blockCrusherGame.set(context, levelState)),
    );
  }

  _celebrationWidget() {
    return SizedBox.expand(
      child: Visibility(
        visible: _duringCelebration,
        child: IgnorePointer(
          child: Confetti(
            isStopped: !_duringCelebration,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _blockCrusherGame = BlockCrusherGame();

    _startOfPlay = DateTime.now();

    // Preload ad for the win screen.
    final adsRemoved =
        context.read<InAppPurchaseController?>()?.adRemoval.active ?? false;
    if (!adsRemoved) {
      final adsController = context.read<AdsController?>();
      adsController?.preloadAd();
    }
  }

  Future<void> _playerDie() async {
    // TODO

    _playerWon();
  }

  Future<void> _playerWon() async {
    _log.info('Level ${widget.level.number} won');

    final score = Score(
      widget.level.number,
      widget.level.difficulty,
      DateTime.now().difference(_startOfPlay),
    );

    final playerProgress = context.read<PlayerProgress>();
    playerProgress.setLevelReached(widget.level.number);

    // Let the player see the game just after winning for a bit.
    await Future<void>.delayed(_preCelebrationDuration);
    if (!mounted) return;

    setState(() {
      _duringCelebration = true;
    });

    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.congrats);

    final gamesServicesController = context.read<GamesServicesController?>();
    if (gamesServicesController != null) {
      // Award achievement.
      if (widget.level.awardsAchievement) {
        await gamesServicesController.awardAchievement(
          android: widget.level.achievementIdAndroid!,
          iOS: widget.level.achievementIdIOS!,
        );
      }

      // Send score to leaderboard.
      await gamesServicesController.submitLeaderboardScore(score);
    }

    /// Give the player some time to see the celebration animation.
    await Future<void>.delayed(_celebrationDuration);
    if (!mounted) return;

    GoRouter.of(context).go('/play/won', extra: {'score': score});
  }
}

// class MyGameWidget extends StatelessWidget {
//   const MyGameWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     GameController.to.context = context;

//     return _myGameLayer();
//   }

//   _myGameLayer() {
//     GameController.to.gameIsRunning.value = true;

//     return Stack(
//       children: [
//         _flameLayer(),
//         _appLayer(),
//       ],
//     );
//   }

//   _flameLayer() {
//     return GetBuilder<GameController>(builder: (controller) {
//       return GameWidget(game: controller.game);
//     });
//   }

//   _appLayer() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [_scoreContainer(), _playButton()],
//     );
//   }

//   _playButton() {
//     return Obx(
//       () => GameController.to.gameIsRunning.value
//           ? const SizedBox.shrink()
//           : InkWell(
//               onTap: () => {GameController.to.startGame()},
//               child: Container(
//                 color: Colors.red,
//                 width: 200,
//                 height: 50,
//                 child: const Center(
//                   child: Text('Play', style: TextStyle(fontSize: 20)),
//                 ),
//               ),
//             ),
//     );
//   }

  
// }


//  _oldGameWidget() {
//     return Center(
//       // This is the entirety of the "game".
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Align(
//             alignment: Alignment.centerRight,
//             child: InkResponse(
//               onTap: () => GoRouter.of(context).push('/settings'),
//               child: Image.asset(
//                 'assets/images/settings.png',
//                 semanticLabel: 'Settings',
//               ),
//             ),
//           ),
//           const Spacer(),
//           Text('Drag the slider to ${widget.level.difficulty}%'
//               ' or above!'),
//           Consumer<LevelState>(
//             builder: (context, levelState, child) => Slider(
//               label: 'Level Progress',
//               autofocus: true,
//               value: levelState.score / 100,
//               onChanged: (value) =>
//                   levelState.setProgress((value * 100).round()),
//               onChangeEnd: (value) => levelState.evaluate(),
//             ),
//           ),
//           const Spacer(),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () => GoRouter.of(context).go('/play'),
//                 child: const Text('Back'),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

// _scoreContainer() {
//     return Container(
//       width: 200,
//       height: 100,
//       decoration: const BoxDecoration(color: Colors.blue),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               const Text('LIVES : ', style: TextStyle(fontSize: 20)),
//               Obx(
//                 () {
//                   return Text(
//                     GameController.to.lives.value.toString(),
//                     style: const TextStyle(fontSize: 20),
//                   );
//                 },
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               const Text('SCORE : ', style: TextStyle(fontSize: 20)),
//               Consumer<LevelState>(
//                 builder: (context, levelState, child) => Obx(
//                   () {
//                     levelState.setProgress(GameController.to.gameScore.value);
//                     levelState.evaluate();

//                     return Text(GameController.to.gameScore.value.toString(),
//                         style: const TextStyle(fontSize: 20));
//                   },
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               const Text('LEVEL : ', style: TextStyle(fontSize: 20)),
//               Obx(
//                 () {
//                   return Text(
//                       GameController.to.blockFallSpeed.value.toInt().toString(),
//                       style: const TextStyle(fontSize: 20));
//                 },
//               ),
//             ],
//           ),
//           const Spacer(),
//           Row(
//             children: [
//               const Text('BEST : ', style: TextStyle(fontSize: 20)),
//               Obx(
//                 () {
//                   return Text(GameController.to.bestScore.value.toString(),
//                       style: const TextStyle(fontSize: 20));
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }