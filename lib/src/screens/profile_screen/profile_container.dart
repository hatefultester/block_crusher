
import 'package:flutter/material.dart';

class ProfileContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final double width;
  final double height;

  const ProfileContainer({Key? key, required this.child, required this.color, this.width= 100, this.height = 50,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      width: width, height: height, decoration: BoxDecoration(color: color,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.black, width: 0.2),
      boxShadow: [
        BoxShadow(
          color: Colors.white.withOpacity(0.4),
          spreadRadius: 4,
          blurRadius: 8,
          offset: const Offset(0, 3), // changes position of shadow
        ),],
    ),
      padding: const EdgeInsets.all(6),
      child: Center(child: child),
    );
  }
}