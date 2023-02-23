
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
      width: width, height: height, decoration: BoxDecoration(color: Colors.black.withOpacity(0.6),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.black, width: 0.2),

    ),
      padding: const EdgeInsets.all(6),
      child: DefaultTextStyle(

          style: const TextStyle(color:Colors.white, fontFamily: 'Quikhand'),
          child: Center(child: child)),
    );
  }
}