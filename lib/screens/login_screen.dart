import 'package:flash_chat/components/loader.dart';
import 'package:flash_chat/components/textdecoration.dart';
import 'package:flash_chat/screens/listusers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  final Function toggleView;
  LoginScreen({this.toggleView});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String err = "";
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
                  padding: EdgeInsets.symmetric(vertical: 100, horizontal: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Login ',
                          style:
                              TextStyle(fontSize: 44, fontFamily: 'Righteous'),
                        ),
                        SizedBox(
                          height: 70,
                        ),
                        Text(
                          err,
                          style: TextStyle(color: Colors.red[300]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (val) =>
                              RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)
                                  ? null
                                  : 'Enter valid email address',
                          textAlign: TextAlign.center,
                          decoration:
                              textDecoration.copyWith(hintText: 'Email'),
                          style: TextStyle(fontFamily: 'Righteous'),
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Righteous'),
                          decoration:
                              textDecoration.copyWith(hintText: 'Password'),
                          validator: (val) => val.length <= 6
                              ? 'Password must be of length 6'
                              : null,
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        ButtonTheme(
                          height: 48,
                          minWidth: 178,
                          child: RaisedButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                FirebaseUser user;
                                try {
                                  user = await _auth.signInWithEmailAndPassword(
                                      email: email.trim(),
                                      password: password.trim());
                                } catch (e) {
                                  print(e.toString());
                                }
                                print(user);
                                setState(() {
                                  loading = false;
                                });
                                if (user == null) {
                                  setState(() {
                                    err = 'Email Id or Password are Invalid';
                                  });
                                } else {
                                  // Navigator.pushNamed(context, ListUsers.id);
                                }
                              }
                            },
                            color: Color(0xFA5E90FF),
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'New to the party?',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: 'IndieFlower'),
                            ),
                            FlatButton(
                              color: Colors.white,
                              child: Text(
                                'SignUp',
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
                        ),
                        // FlatButton.icon(
                        //   icon: Icon(Icons.ac_unit),
                        //   label: Text('Forgot Password?'),
                        //   onPressed: () async{

                        //   },)
                      ],
                    ),
                  ),
                ),
              ]),
            )),
          );
  }
}
