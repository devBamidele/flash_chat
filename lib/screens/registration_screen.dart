import 'dart:developer';

import 'package:flash_chat/constants.dart';
import 'package:flash_chat/reusables/my_button.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  static const id = 'RegistrationScreen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;

  displaySb(String message) =>
      ScaffoldMessenger.of(context).showSnackBar(ksnackBar(message));

  ksnackBar(String message) => SnackBar(
        duration: const Duration(milliseconds: 1200),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        title: const Text('Registration'),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: SizedBox(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            const SizedBox(
              height: 48.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
              },
              decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password'),
            ),
            const SizedBox(
              height: 24.0,
            ),
            MyButton(
                myText: 'Register',
                onPressed: () async {
                  if (email != null && password != null) {
                    // Verify that there are values in the required fields
                    try {
                      // Create a new user by passing in the email and password as parameters
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                        email: email.toString(),
                        password: password.toString(),
                      );

                      if (!mounted) return;
                      Navigator.pushNamed(context, ChatScreen.id);
                    } catch (e) {
                      displaySb('☠  ️Something\'s not right, try again');
                    }
                  } else {
                    displaySb('Please Complete Registration First');
                  }
                },
                myColor: Colors.blueAccent),
          ],
        ),
      ),
    );
  }
}

// log(email.toString());
// log(password.toString());
