// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// Shows [message] in a snack bar as long as a [ScaffoldMessengerState]
/// with global key [scaffoldMessengerKey] is anywhere in the widget tree.
void showSnackBar(String message) {
  final messenger = scaffoldMessengerKey.currentState;
  messenger?.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(seconds:2),
      margin: EdgeInsets.only(bottom: MediaQuery.of(messenger.context).size.height-50, right: 20, left: 20, top: 0),
      content: TransitionMessageWidget(message: message),
    ),
  );
}

class TransitionMessageWidget extends StatefulWidget {
final String message;

  const TransitionMessageWidget({Key? key, required this.message}) : super(key: key);

  @override
  State<TransitionMessageWidget> createState() => _TransitionMessageWidgetState();
}

class _TransitionMessageWidgetState extends State<TransitionMessageWidget> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AnimatedContainer(duration: const Duration(milliseconds: 300),
        width: selected ? 0 : 80,
        ),
        AnimatedContainer(duration: const Duration(seconds: 1),
        alignment: selected ? Alignment.topLeft : const Alignment(1.5,0),

        decoration: BoxDecoration(
        gradient: selected ? LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.red, Colors.red.withOpacity(0.8)]) : LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight ,colors: [Colors.red.withOpacity(0.5), Colors.transparent]),
        borderRadius: selected ? BorderRadius.circular(50) : BorderRadius.circular(5),
        ),
        width: selected ? 300: 200,
        curve: Curves.fastOutSlowIn,
        child: Container(
            padding: const EdgeInsets.all(25),
            child: Text(widget.message, style: const TextStyle(color: Colors.white, fontFamily: 'Quikhand'),),),),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        selected = true;
      });
    });
  }


}


/// Use this when creating [MaterialApp] if you want [showSnackBar] to work.
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey(debugLabel: 'scaffoldMessengerKey');
