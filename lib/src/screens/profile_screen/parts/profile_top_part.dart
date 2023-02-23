import 'dart:io';
import 'package:block_crusher/src/screens/profile_screen/parts/profile_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileTopWidget extends StatelessWidget {

  final Color itemBackgroundColor;
  final Color itemTextColor;
  final String title;

  const ProfileTopWidget(
      {Key? key, required this.itemBackgroundColor, required this.itemTextColor, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Spacer(),
            _ProfileTitle(
                title: title,
                color: itemBackgroundColor, textColor: itemTextColor),
            const Spacer(),
          ],
        ),
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



class _ProfileTitle extends StatelessWidget {
  final String title;
  final Color color;
  final Color textColor;

  const _ProfileTitle({Key? key, required this.color, required this.textColor, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfileContainer(
      width: 300,
      height: 60,
      color: color,
      child: Text(title, style: TextStyle(
        color: textColor,
        fontSize: 35,
        letterSpacing: 2.3
      )),
    );
  }
}


class _ProfileWallet extends StatelessWidget {
  final Color color;
  final Color textColor;

  const _ProfileWallet({Key? key, required this.color, required this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfileContainer(
        color: color,
        child: Text('test'),
    );
  }
}
