import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    required this.myText,
    required this.myColor,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String myText;
  final Color myColor;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: myColor,
        borderRadius: BorderRadius.circular(20.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 46.0,
          child: Text(
            myText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
