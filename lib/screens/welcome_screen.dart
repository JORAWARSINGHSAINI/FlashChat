import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/listusers.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool registerPage = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  void toggleView() {
    setState(() {
      registerPage = !registerPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // print(snapshot.data);
            return ListUsers();
          } else {
            return registerPage == true
                ? RegistrationScreen(toggleView: toggleView)
                : LoginScreen(toggleView: toggleView);
          }
        });
  }
}
