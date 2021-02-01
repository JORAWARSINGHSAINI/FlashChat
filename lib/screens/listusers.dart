import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/loader.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/profile.dart';
import 'package:flash_chat/service/databaseService.dart';
import 'package:flutter/material.dart';

class ListUsers extends StatefulWidget {
  static const String id = 'ListUsers_screen';
  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  bool profilePage = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user;
  // User _user;
  void toggleProfile(bool value) {
    setState(() {
      profilePage = value;
    });
  }

  List<DocumentSnapshot> users = [];

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    try {
      FirebaseUser temp = await auth.currentUser();
      setState(() {
        user = temp;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return user == null
        ? CustomLoader()
        : StreamBuilder<QuerySnapshot>(
            stream: DataBaseService(uid: user.uid).alluserData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                users = snapshot.data.documents;
              }
              return snapshot.hasData == false
                  ? CustomLoader()
                  : Scaffold(
                      appBar: AppBar(
                        leading: null,
                        automaticallyImplyLeading: false,
                        actions: <Widget>[
                          FlatButton.icon(
                              icon: Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                              label: Text(
                                'Logout',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                auth.signOut();
                              }),
                        ],
                        title: Text('⚡️ Chat'),
                        centerTitle: true,
                        backgroundColor: Color(0xFA5E90FF),
                      ),
                      body: profilePage
                          ? Profile(
                              toggleProfile: toggleProfile,
                              user: user,
                            )
                          : Column(
                              children: [
                                Container(
                                  color: Color(0xFA5E90FF),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                          height: 65,
                                          child: RaisedButton.icon(
                                            color: Color(0xFA5E90FF),
                                            icon: Icon(
                                              Icons.chat,
                                              color: Colors.white,
                                            ),
                                            label: Text(
                                              'Chats',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: () {
                                              toggleProfile(false);
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                          height: 65,
                                          child: RaisedButton.icon(
                                            autofocus: true,
                                            color: Color(0xFA5E90FF),
                                            icon: Icon(
                                              Icons.account_box_sharp,
                                            ),
                                            label: Text(
                                              'Profile',
                                            ),
                                            onPressed: () {
                                              toggleProfile(true);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 400,
                                  height: 650,
                                  child: ListView.builder(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 0),
                                      scrollDirection: Axis.vertical,
                                      itemCount: users.length,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          child: ListTile(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, ChatScreen.id,
                                                  arguments: users[index].data);
                                            },
                                            title: Text(
                                                users[index].data['username']),
                                            leading: Hero(
                                              tag: users[index].data['email'],
                                              child: CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    'images/avatar.png'),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                    );
            });
  }
}
