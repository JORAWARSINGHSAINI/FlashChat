import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String username;
  String email;
  String status;
  Timestamp dob = Timestamp.fromDate(DateTime(2000));
  bool isverified = false;
  // String photoUrl;

  User(
      {this.uid,
      this.username,
      this.email,
      this.status,
      this.dob,
      this.isverified});
}
