import 'package:block_crusher/src/style/custom_snack_bars/scaffold_key.dart';
import 'package:flutter/material.dart';

void showInfoMessageSnackBar(String message, String title) {
  final messenger = scaffoldMessengerKey.currentState;
  messenger?.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      dismissDirection: DismissDirection.horizontal,
      clipBehavior: Clip.antiAlias,

      duration: const Duration(seconds:3),
      //  margin: EdgeInsets.only(bottom: MediaQuery.of(messenger.context).size.height-50, right: 20, left: 20, top: 0),
      content: ErrorMessageSnackBarTransitionMessageWidget(title: title, message: message),
    ),
  );
}

class ErrorMessageSnackBarTransitionMessageWidget extends StatefulWidget {
  final String title;
  final String message;
  final Color color;

  const ErrorMessageSnackBarTransitionMessageWidget({Key? key, required this.title, required this.message, this.color = Colors.white}) : super(key: key);

  @override
  State<ErrorMessageSnackBarTransitionMessageWidget> createState() => _InfoMessageSnackBarTransitionMessageWidgetState();
}

class _InfoMessageSnackBarTransitionMessageWidgetState extends State<ErrorMessageSnackBarTransitionMessageWidget> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AnimatedContainer(duration: const Duration(milliseconds: 1300),
          alignment: selected ? Alignment.topLeft : const Alignment(1.5,0),

          decoration: BoxDecoration(
            gradient: selected ? LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [widget.color, widget.color.withOpacity(0.8)]) : LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight ,colors: [widget.color.withOpacity(0.5), Colors.transparent]),
            borderRadius: selected ? BorderRadius.circular(50) : BorderRadius.circular(5),
          ),
          width: selected ? 300: 150,
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
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(widget.title, style: const TextStyle(color: Colors.black, fontFamily: 'Quikhand', fontSize: 25),)),
                          const SizedBox(height: 5,),
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(widget.message, style: const TextStyle(color: Colors.black, fontFamily: 'Quikhand', fontSize: 20),maxLines: 2,)),
                        ],
                      ),
                    ),
                  ],
                ),),
            ],
          ),
        ),
        AnimatedContainer(duration: const Duration(milliseconds: 600),
          height: selected ? 0 : 300,
        ),
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