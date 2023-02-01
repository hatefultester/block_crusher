import 'dart:async';

import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/settings/audio/audio_controller.dart';
import 'package:block_crusher/src/settings/audio/sounds.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MovingButton extends StatefulWidget {
  final String route;
  final String title;

  final int millisecondSpeed;

  final Direction x;
  final Direction y;

  const MovingButton({Key? key, required this.route, required this.title, this.millisecondSpeed = 10,
  this.y = Direction.down, this.x = Direction.left}) : super(key: key);

  @override
  State<MovingButton> createState() => _MovingButtonState();
}

class _MovingButtonState extends State<MovingButton> {
  late double dx;
  late double dy;
  late Timer timer;

  late Direction yDirection;
  late Direction xDirection;

  @override
  Widget build(BuildContext context) {
    final audioController = context.read<AudioController>();
    final double dx = this.dx;
    final double dy = this.dy;


    return Transform.translate(
      offset: Offset(dx, dy ),
      child: SizedBox(
        width: 220,
        height: 75,
        child: ElevatedButton(
          onPressed: () {
            audioController.playSfx(SfxType.buttonTap);
            GoRouter.of(context).go(widget.route);
          },
          child: Center(child: Text(widget.title.toUpperCase())),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    xDirection = widget.x;
    yDirection = widget.y;

    dx = 0;
    dy = 0;

    _startTimer();
  }


  _startTimer() async {
    timer = Timer.periodic(Duration(milliseconds: widget.millisecondSpeed), (timer) {
      setState(() {
        if (yDirection == Direction.down) {
          dy += 0.05;
        }
        if (yDirection == Direction.up) {
          dy -= 0.05;
        }

        if (dy > 10) {
          yDirection = Direction.up;
        }

        if (dy < -10) {
          yDirection = Direction.down;
        }

        if (xDirection == Direction.left) {
          dx += 0.04;
        }
        if (xDirection == Direction.right) {
          dx -= 0.04;
        }

        if (dy > 3) {
          xDirection = Direction.right;
        }

        if (dy < -3) {
          xDirection = Direction.left;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
}
