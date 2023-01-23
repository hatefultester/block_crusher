import 'dart:io';
import 'package:block_crusher/src/screens/play_session/widgets/parts/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DefaultTopWidget extends StatelessWidget {
  final String title;
  final String imagePath;

  const DefaultTopWidget(
      {Key? key, required this.title, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      decoration: const BoxDecoration(color: Colors.black),
      height: 60,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25,
            ),
            onPressed: (() => {
                  GoRouter.of(context).go('/play'),
                }),
          ),
          const Spacer(),
          ImageWidget(path: imagePath),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          ImageWidget(
            path: imagePath,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
              size: 30,
            ),
            onPressed: (() => {
                  // TODO resolve refresh state
                  // _blockCrusherGame.restartGame(),
                  // setState(
                  //       () {
                  //     _startOfPlay = DateTime.now();
                  // },
                  //),
                }),
          ),
        ],
      ),
    );

    if (Platform.isIOS) {
      return Column(
        children: [
          Container(
            color: Colors.black,
            height: 40,
          ),
          content
        ],
      );
    } else {
      return content;
    }
  }
}
