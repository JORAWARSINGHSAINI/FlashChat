import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/textdecoration.dart';
import 'package:flash_chat/models/user.dart';
import 'package:flash_chat/service/databaseService.dart';
import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  final User user;
  EditScreen({this.user});
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  String username;
  String status;
  String email;
  DateTime dob;

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: dob, // Refer step 1
      firstDate: DateTime(1980),
      lastDate: DateTime(2200),
    );
    if (picked != null)
      setState(() {
        dob = picked;
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    username = widget.user.username;
    status = widget.user.status;
    dob = DateTime.fromMicrosecondsSinceEpoch(widget.user.dob.seconds * 1000);
    print(dob);
    email = widget.user.email;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 700,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  'Update Settings',
                  style: TextStyle(fontSize: 20, fontFamily: 'Righteous'),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Username',
                style: TextStyle(fontSize: 16, fontFamily: 'Righteous'),
              ),
              TextFormField(
                // textAlign: TextAlign.center,
                initialValue: username,
                decoration: textDecoration,
                onChanged: (val) {
                  username = val;
                },
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Status',
                style: TextStyle(fontSize: 16, fontFamily: 'Righteous'),
              ),
              TextFormField(
                decoration: textDecoration,
                initialValue: status,
                onChanged: (val) {
                  setState(() {
                    status = val;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  InputDatePickerFormField(
                    onDateSaved: (value) {
                      setState(() {
                        dob = value;
                      });
                    },
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1990),
                    lastDate: DateTime(2050),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: FlatButton(
                  color: Colors.blue,
                  child: Text(
                    'Submit',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Indie-Flower'),
                  ),
                  onPressed: () {
                    DataBaseService(uid: widget.user.uid).updateUserData(
                        username, email, status, Timestamp.fromDate(dob), true);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
