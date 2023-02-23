import 'package:flutter/material.dart';

class LevelPageNotAccessible extends StatelessWidget {
  const LevelPageNotAccessible({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withOpacity(0.85),
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 350,
          height: 320,
          child: Container(
            width: 250,
            height: 220,
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.8),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: Center(
              child: SizedBox(
                width: 150,
                height: 150,
                child: Image.asset(
                    'assets/images/lock/lock_locked.png'
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
