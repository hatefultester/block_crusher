import 'package:block_crusher/src/play_session/game_controller.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameScreen extends GetView<GameController> {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(GameController());
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            _flameLayer(),
            _appLayer(),
            _debugButton(),
          ],
        ),
      ),
    );
  }

  _debugButton() {
    return Obx(() => controller.gameIsRunning.value
        ? Align(
            alignment: const Alignment(-1, -1),
            child: InkWell(
              onTap: () => {controller.debugButtonTrigger()},
              child: Container(
                color: Colors.red,
                width: 100,
                height: 80,
                child: const Center(
                  child: Text('DEBUG RESET', style: TextStyle(fontSize: 10)),
                ),
              ),
            ),
          )
        : const SizedBox.shrink());
  }

  _flameLayer() {
    return GetBuilder<GameController>(builder: (controller) {
      return GameWidget(game: controller.game);
    });
  }

  _appLayer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [_scoreContainer(), _playButton()],
    );
  }

  _playButton() {
    return Obx(
      () => controller.gameIsRunning.value
          ? const SizedBox.shrink()
          : InkWell(
              onTap: () => {controller.startGame()},
              child: Container(
                color: Colors.red,
                width: 200,
                height: 50,
                child: const Center(
                  child: Text('Play', style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
    );
  }

  _scoreContainer() {
    return Container(
      width: 200,
      height: 100,
      decoration: const BoxDecoration(color: Colors.blue),
      child: Column(
        children: [
          Row(
            children: [
              const Text('LIVES : ', style: TextStyle(fontSize: 20)),
              Obx(
                () {
                  return Text(
                    controller.lives.value.toString(),
                    style: const TextStyle(fontSize: 20),
                  );
                },
              ),
            ],
          ),
          Row(
            children: [
              const Text('SCORE : ', style: TextStyle(fontSize: 20)),
              Obx(
                () {
                  return Text(controller.gameScore.value.toString(),
                      style: const TextStyle(fontSize: 20));
                },
              ),
            ],
          ),
          Row(
            children: [
              const Text('LEVEL : ', style: TextStyle(fontSize: 20)),
              Obx(
                () {
                  return Text(
                      controller.blockFallSpeed.value.toInt().toString(),
                      style: const TextStyle(fontSize: 20));
                },
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              const Text('BEST : ', style: TextStyle(fontSize: 20)),
              Obx(
                () {
                  return Text(controller.bestScore.value.toString(),
                      style: const TextStyle(fontSize: 20));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
