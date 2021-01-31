import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OProfile extends StatefulWidget {
  static const String id = "oscreen";

  @override
  _OProfileState createState() => _OProfileState();
}

class _OProfileState extends State<OProfile> {
  DateTime selectedDate;
  @override
  Widget build(BuildContext context) {
    final Map<String, Object> user = ModalRoute.of(context).settings.arguments;
    Timestamp t = user['dob'];
    selectedDate = DateTime.fromMillisecondsSinceEpoch(t.seconds * 1000);
    print(user['dob']);
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Color(0xFA5E90FF),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                    user['username'] ?? 'Username',
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
                    user['email'] ?? 'Email',
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 20.0,
                        fontFamily: 'Lobster'),
                  ),
                ),
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
                Text(
                  user['status'] ?? 'Status',
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 20.0,
                      fontFamily: 'Lobster'),
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
                  // user['dob'].toString(),
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
      ),
    );
  }
}
