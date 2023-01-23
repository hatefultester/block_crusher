
import 'dart:async';

import 'package:block_crusher/src/games_services/score.dart';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final DateTime startTime;
  final Color backgroundColor;
  final Color textColor;

  const TimerWidget(this.startTime, {super.key, required this.backgroundColor, required this.textColor});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  String time = '0';

  Timer? timeDilationTimer;

  _TimerWidgetState() {
    setTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: 100, height: 50, decoration: BoxDecoration(color: widget.backgroundColor, borderRadius: BorderRadius.circular(20),), padding: const EdgeInsets.all(6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.timer, color: widget.textColor),
            Text(
              time,
              style: TextStyle(fontSize: 25, color: widget.textColor),
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }

  setTimer() {
    timeDilationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        time = DateTime.now().difference(widget.startTime).toFormattedString();
      });
    });
  }

  @override
  void dispose() {
    timeDilationTimer?.cancel();
    super.dispose();
  }
}

