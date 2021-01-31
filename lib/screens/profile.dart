import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/loader.dart';
import 'package:flash_chat/models/user.dart';
import 'package:flash_chat/screens/editScreen.dart';
import 'package:flash_chat/service/databaseService.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final Function toggleProfile;
  final FirebaseUser user;

  Profile({this.toggleProfile, this.user});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DateTime selectedDate = DateTime.now();
  User _user;

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Verification Email Sent'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('A verification email has been sent to the email'),
                Text('Confirm that to verify your email.'),
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

  void _modalBottomSheetMenu(User user) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return EditScreen(user: user);
        });
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(1990),
      lastDate: DateTime(2200),
    );
    if (picked != null && picked != selectedDate)
      DataBaseService(uid: widget.user.uid).updateUserData(
          _user.username,
          _user.email,
          _user.status,
          Timestamp.fromDate(picked),
          widget.user.isEmailVerified);
    // setState(() {
    //   selectedDate = picked;
    // });
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.user);
    return StreamBuilder<DocumentSnapshot>(
        stream: DataBaseService(uid: widget.user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _user = DataBaseService(uid: widget.user.uid)
                .userDataFromSnapshot(snapshot.data);
            selectedDate = _user.dob.toDate();
          }
          return snapshot.hasData == false
              ? CustomLoader()
              : Scaffold(
                  backgroundColor: Colors.white,
                  body: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
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
                                  ),
                                  label: Text(
                                    'Chats',
                                  ),
                                  onPressed: () {
                                    widget.toggleProfile(false);
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
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    'Profile',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    widget.toggleProfile(true);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      Container(
                        margin: EdgeInsets.only(top: 1),
                        padding: EdgeInsets.only(top: 50),
                        height: 300,
                        color: Color(0xFA5E9AA0),
                        child: Center(
                          child: Column(children: <Widget>[
                            CircleAvatar(
                              backgroundImage: AssetImage('images/avatar.png'),
                              radius: 60.0,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              _user.username ?? 'Username',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36.0,
                                  fontFamily: 'IndieFlower'),
                            ),
                          ]),
                        ),
                      ),
                      Divider(
                        height: 30.0,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 20.0,
                          ),
                          Icon(
                            Icons.email,
                            color: Colors.blueGrey,
                          ),
                          SizedBox(
                            width: 30.0,
                          ),
                          Expanded(
                            child: Text(
                              _user.email ?? 'Email',
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 20.0,
                                  fontFamily: 'Lobster'),
                            ),
                          ),
                          IconButton(
                            icon: widget.user.isEmailVerified
                                ? Icon(
                                    Icons.check_circle_outline,
                                    size: 24,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.warning_outlined,
                                    color: Colors.red,
                                  ),
                            onPressed: () async {
                              if (widget.user.isEmailVerified == false) {
                                widget.user.sendEmailVerification();
                                _showMyDialog();
                              }
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 20.0,
                          ),
                          Icon(
                            Icons.star_outline_sharp,
                            color: Colors.blueGrey,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Text(
                              _user.status ?? 'Status',
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 20.0,
                                  fontFamily: 'Lobster'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: Colors.blueGrey,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                              child: Container(
                                  child: Text(
                            selectedDate.day.toString() +
                                "-" +
                                selectedDate.month.toString() +
                                "-" +
                                selectedDate.year.toString(),
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 20.0,
                                fontFamily: 'Lobster'),
                          ))),
                          IconButton(
                            icon: Icon(Icons.calendar_today_outlined),
                            color: Colors.blueGrey,
                            onPressed: () =>
                                _selectDate(context), // Refer step 3
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Image(
                          image: AssetImage('images/images.png'),
                        ),
                      ),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: Color(0xFA5E90FF),
                    onPressed: () {
                      _modalBottomSheetMenu(_user);
                    },
                    child: Icon(Icons.edit),
                  ),
                );
        });
  }
}
