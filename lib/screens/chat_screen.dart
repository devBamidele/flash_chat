import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static const id = 'ChatScreen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

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
            const MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'ts': Timestamp.now()
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

class MessagesStream extends StatelessWidget {
  const MessagesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .orderBy('ts', descending: true)
          .snapshots(), // Get a stream source
      builder: (context, snapshot) {
        List<MessageBubble> messageBubbles = [];
        if (!snapshot.hasData) {
          // Check for data and display an animation if there isn't
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final messages = snapshot.data?.docs;
        for (var message in messages!) {
          final data = message.data() as Map;
          final messageText = data['text'];
          final messageSender = data['sender'];
          final messageTime = data['ts'];

          final currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(
            text: messageText,
            sender: messageSender,
            isMe: currentUser == messageSender,
            time: messageTime,
          );

          messageBubbles.add(messageBubble);
        }

        if (messageBubbles.isEmpty) {
          return Center(
            child: Text(
              'Send Instant Messages',
              style: kRefreshTextStyle,
            ),
          );
        } else {
          return Expanded(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              children: messageBubbles,
            ),
          );
        }
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.text,
    required this.sender,
    required this.isMe,
    required this.time,
    Key? key,
  }) : super(key: key);

  final String text;
  final String sender;
  final bool isMe;
  final Timestamp time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(30),
              bottomRight: const Radius.circular(30),
              topLeft:
                  isMe ? const Radius.circular(30) : const Radius.circular(0),
              topRight:
                  isMe ? const Radius.circular(0) : const Radius.circular(30),
            ),
            elevation: 5,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: isMe ? Colors.white : Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
