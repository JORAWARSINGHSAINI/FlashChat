import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/models/user.dart';

class DataBaseService {
  final String uid;
  final CollectionReference _reference = Firestore.instance.collection('users');

  DataBaseService({this.uid});

  User userDataFromSnapshot(DocumentSnapshot snapshot) {
    return User(
      uid: uid,
      username: snapshot.data['username'],
      email: snapshot.data['email'],
      status: snapshot.data['status'],
      dob: snapshot.data['dob'],
    );
  }

  Future updateUserData(String username, String email, String status,
      DateTime dob, bool isverified) async {
    return await _reference.document(uid).setData({
      'username': username,
      'email': email,
      'status': status,
      'dob': dob,
      'isverified': isverified
    });
  }

  Stream<User> get userData {
    return _reference.document(uid).snapshots().map(userDataFromSnapshot);
  }

  Stream<QuerySnapshot> get alluserData {
    return _reference.snapshots();
  }
}
