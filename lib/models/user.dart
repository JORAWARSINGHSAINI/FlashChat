class User {
  String uid;
  String username;
  String email;
  String status;
  DateTime dob = DateTime(2000);
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
