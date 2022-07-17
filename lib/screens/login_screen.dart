import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../reusables/my_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const id = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
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
        title: const Text('Login'),
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        opacity: 0.45,
        color: Colors.grey,
        inAsyncCall: showSpinner,
        progressIndicator: kSpinKit,
        child: Padding(
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
                  myText: 'Log In',
                  onPressed: () async {
                    if (email != null && password != null) {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        // Verify that the user attempting to sign in is already registered
                        final regUser = await _auth.signInWithEmailAndPassword(
                          email: email.toString(),
                          password: password.toString(),
                        );
                        if (!mounted) return;
                        Navigator.pushNamed(context, ChatScreen.id);
                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        setState(() {
                          showSpinner = false;
                        });
                        displaySb('☠  ️Something\'s not right, try again');
                      }
                    } else {
                      displaySb('Please Complete Login First');
                    }
                  },
                  myColor: Colors.lightBlueAccent),
            ],
          ),
        ),
      ),
    );
  }
}
