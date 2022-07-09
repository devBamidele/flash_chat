import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    required this.myText,
    required this.navigateTo,
    required this.myColor,
    Key? key,
  }) : super(key: key);

  final String myText;
  final String? navigateTo;
  final Color myColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: myColor,
        borderRadius: BorderRadius.circular(20.0),
        child: MaterialButton(
          onPressed: () {
            Navigator.pushNamed(context, navigateTo!);
          },
          minWidth: 200.0,
          height: 46.0,
          child: Text(
            myText,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
