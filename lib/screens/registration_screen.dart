import 'package:flash_chat/components/loader.dart';
import 'package:flash_chat/components/textdecoration.dart';
import 'package:flash_chat/screens/listusers.dart';
import 'package:flash_chat/service/databaseService.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  final Function toggleView;
  RegistrationScreen({this.toggleView});
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey2 = GlobalKey<FormState>();
  String username = "";
  String email = "";
  String password = "";
  String cPassword = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? CustomLoader()
        : Scaffold(
            backgroundColor: Colors.white,
            // resizeToAvoidBottomInset: false,
            body: Container(
                child: SingleChildScrollView(
              child: Column(children: <Widget>[
                Row(children: <Widget>[
                  Image(
                    image: AssetImage('images/Design1.png'),
                  ),
                ]),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 100, horizontal: 35),
                  child: Form(
                    key: _formKey2,
                    child: Column(
                      children: <Widget>[
                        Text(
                          'SignUp',
                          style:
                              TextStyle(fontSize: 44, fontFamily: 'Righteous'),
                        ),
                        SizedBox(
                          height: 70,
                        ),
                        TextFormField(
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Righteous'),
                          decoration:
                              textDecoration.copyWith(hintText: 'Username'),
                          onChanged: (val) {
                            setState(() {
                              username = val;
                            });
                          },
                          validator: (val) => val.length > 0
                              ? null
                              : 'Enter valid email address',
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Righteous'),
                          decoration:
                              textDecoration.copyWith(hintText: 'Email'),
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                          validator: (val) =>
                              RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)
                                  ? null
                                  : 'Enter valid email address',
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Righteous'),
                          decoration:
                              textDecoration.copyWith(hintText: ' Password'),
                          validator: (val) => val.length < 6
                              ? 'Password must atleast be of length 6'
                              : null,
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Righteous'),
                          decoration: textDecoration.copyWith(
                              hintText: 'Confirm Password'),
                          validator: (val) =>
                              val != password ? 'Passwords do no match' : null,
                          onChanged: (val) {
                            setState(() {
                              cPassword = val;
                            });
                          },
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        ButtonTheme(
                          height: 50,
                          minWidth: 188,
                          child: RaisedButton(
                            onPressed: () async {
                              if (_formKey2.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                FirebaseUser user;
                                try {
                                  user = await _auth
                                      .createUserWithEmailAndPassword(
                                          email: email.trim(),
                                          password: password.trim());
                                  await DataBaseService(uid: user.uid)
                                      .updateUserData(username, email,
                                          'Hello World', DateTime(2000), false);
                                } catch (e) {
                                  print(e.toString());
                                }
                                setState(() {
                                  loading = false;
                                });
                                if (user == null) {
                                  print('not working');
                                } else {
                                  // Navigator.pushNamed(context, ListUsers.id);
                                }
                              }
                            },
                            color: Color(0xFA5E90FF),
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Existing User?',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: 'IndieFlower'),
                            ),
                            FlatButton(
                              color: Colors.white,
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Righteous',
                                    color: Color(0xFFFF6584)),
                              ),
                              onPressed: () {
                                widget.toggleView();
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ]),
            )),
          );
  }
}
