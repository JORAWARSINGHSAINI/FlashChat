import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/models/user.dart';

class DataBaseService {
  final String uid;
  final CollectionReference _reference = Firestore.instance.collection('users');

  DataBaseService({this.uid});

  User userDataFromSnapshot(DocumentSnapshot snapshot) {
    // print(snapshot.data);
    return User(
      uid: uid,
      username: snapshot.data['username'],
      email: snapshot.data['email'],
      status: snapshot.data['status'],
      dob: snapshot.data['dob'],
    );
  }

  Future updateUserData(String username, String email, String status,
      Timestamp dob, bool isverified) async {
    return await _reference.document(uid).setData({
      'username': username,
      'email': email,
      'status': status,
      'dob': dob,
      'isverified': isverified
    });
  }

  Stream<DocumentSnapshot> get userData {
    return _reference.document(uid).snapshots();
  }

  Stream<QuerySnapshot> get alluserData {
    return _reference.snapshots();
  }
}
