import 'package:block_crusher/strings/achievement_snack_bar_texts.dart';
import 'package:flutter/material.dart';

import '../../storage/game_achievements/achievements.dart';
import 'game_achievement_snackbar.dart';

void showErrorMessageSnackBar(String message, String title) {

  final messenger2 = scaffoldMessengerKey.currentState;
  messenger2?.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      dismissDirection: DismissDirection.horizontal,
      clipBehavior: Clip.antiAlias,

      duration: const Duration(seconds:3),
      margin: EdgeInsets.only(bottom: MediaQuery.of(messenger2.context).size.height-50, right: 20, left: 20, top: 0),
      content: ErrorMessageSnackBarTransitionMessageWidget(title: title, message: message),
    ),
  );
}

class ErrorMessageSnackBarTransitionMessageWidget extends StatefulWidget {
  final String title;
  final String message;
  final Color color;

  const ErrorMessageSnackBarTransitionMessageWidget({Key? key, required this.title, required this.message, this.color = Colors.red}) : super(key: key);

  @override
  State<ErrorMessageSnackBarTransitionMessageWidget> createState() => _ErrorMessageSnackBarTransitionMessageWidgetState();
}

class _ErrorMessageSnackBarTransitionMessageWidgetState extends State<ErrorMessageSnackBarTransitionMessageWidget> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AnimatedContainer(duration: const Duration(milliseconds: 500),
          width: selected ? 0 : 150,
        ),
        AnimatedContainer(duration: const Duration(milliseconds: 1300),
          alignment: selected ? Alignment.topLeft : const Alignment(1.5,0),

          decoration: BoxDecoration(
            gradient: selected ? LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [widget.color, widget.color.withOpacity(0.8)]) : LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight ,colors: [widget.color.withOpacity(0.5), Colors.transparent]),
            borderRadius: selected ? BorderRadius.circular(50) : BorderRadius.circular(5),
          ),
          width: selected ? 300: 200,
          height: selected ? 110 : 150,
          curve: Curves.fastOutSlowIn,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.title, style: const TextStyle(color: Colors.white, fontFamily: 'Quikhand', fontSize: 18),),
                          const SizedBox(height: 5,),
                          Text(widget.message, style: const TextStyle(color: Colors.white, fontFamily: 'Quikhand', fontSize: 15),maxLines: 2,),
                        ],
                      ),
                    ),
                    SizedBox(width: 50, child: Image.asset('assets/images/in_app/neutral_smile.png',),),
                  ],
                ),),
              Transform.translate(
                offset: const Offset(-5,15),
                child: Align(alignment: Alignment.bottomLeft, child: Container(
                  padding: const EdgeInsets.only(right: 15, top: 20),
                  width: 40, child: Image.asset('assets/images/lock/lock_locked.png',),),),
              )

            ],
          ),),
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
