import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String fullName;
  final String emailAddress;
  final String password;
  final String usreUid;
  UserModel({
    required this.fullName,
    required this.emailAddress,
    required this.password,
    required this.usreUid,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      fullName: doc['fullName'],
      emailAddress: doc['emailAddress'],
      password: doc['password'],
      usreUid: doc['userUid'],
    );
  }
}
