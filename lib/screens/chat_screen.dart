import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static const id = 'ChatScreen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance; // Firestore is a
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  late String messageText;

  getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        log(loggedInUser.email.toString(), name: 'My Flutter App');
      }
    } catch (_) {}
  }

  // This function has been rendered redundant
  getMessages() async {
    final messages = await _firestore.collection('messages').get();
    for (var message in messages.docs) {
      log(message.data().toString());
    }
  }

  messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        log(message.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              //Implement logout functionality
              _auth.signOut();
              Navigator.pop(context);
              // getMessages();
            },
          ),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        messageText = value;
                        log(messageText);
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
                      //Implement send functionality.
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
