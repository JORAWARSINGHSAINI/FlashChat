import 'package:flash_chat/screens/oprofile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  // final user;
  // ChatScreen({this.user});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Message could not be sent!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'You need to verify your address before you can send any message.'),
                Text(
                    'Go to Profile and click unchecked button to verify email. '),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  FirebaseUser user;
  String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> receiver =
        ModalRoute.of(context).settings.arguments;
    // print(receiver);

    return Scaffold(
      appBar: AppBar(
        title: receiver['username'] != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: receiver['email'],
                    child: CircleAvatar(
                      backgroundImage: AssetImage('images/avatar.png'),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(receiver['username']),
                  Expanded(
                    child: IconButton(
                      alignment: Alignment.centerRight,
                      icon: Icon(
                        Icons.supervised_user_circle_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, OProfile.id,
                            arguments: receiver);
                      },
                      // label: Text('Profile'),
                    ),
                  )
                ],
              )
            : Text('⚡️Chat'),
        centerTitle: true,
        backgroundColor: Color(0xFA5E90FF),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      if (loggedInUser.isEmailVerified == false) {
                        _showMyDialog();
                        return;
                      }
                      if (messageText == null || receiver['email'] == null)
                        return;
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'receiver': receiver['email'],
                        'sender': loggedInUser.email,
                      });
                    },
                    child: Text(
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
  @override
  Widget build(BuildContext context) {
    final Map<String, Object> receiver =
        ModalRoute.of(context).settings.arguments;
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageBubbles = [];
        print(receiver);
        for (var message in messages) {
          final messageText = message.data['text'].trim();
          final messageSender = message.data['sender'].trim();
          final messageReceiver = message.data['receiver']?.trim();
          final currentUser = loggedInUser.email;
          final messageBubble = MessageBubble(
            text: messageText,
            isMe: currentUser == messageSender,
          );
          if ((messageReceiver == receiver['email'].toString().trim() &&
                  messageSender == currentUser) ||
              (messageSender == receiver['email'].toString().trim() &&
                  messageReceiver == currentUser)) {
            print(messageSender);
            print(messageReceiver);
            messageBubbles.add(messageBubble);
          }
          // messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.isMe});

  // final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
