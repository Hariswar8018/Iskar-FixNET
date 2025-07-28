import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    required this.Name,
    required this.Email,
    required this.uid,
    required this.lastLogin,
    required this.token,
    required this.bio,
    required this.phone,
    required this.dob,
    required this.pic,
  });

  late final String Name;
  late final String pic;
  late final String Email;
  late final String uid;
  late final String lastLogin;
  late final String token;
  late final String bio;
  late final String phone;
  late final String dob;

  UserModel.fromJson(Map<String, dynamic> json) {
    Name = json['name'] ?? '';
    Email = json['email'] ?? '';
    uid = json['uid'] ?? '';
    lastLogin = json['last'] ?? '';
    token = json['token'] ?? '';
    bio = json['bio'] ?? '';
    phone = json['phone'] ?? '';
    dob = json['bday'] ?? '';
    pic=json['pic']??'';
  }

  Map<String, dynamic> toJson() {
    return {
      'name': Name,
      'email': Email,
      'uid': uid,
      'last': lastLogin,
      'token': token,
      'bio': bio,
      'phone': phone,
      'bday': dob,
      'pic':pic,
    };
  }

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel.fromJson(snapshot);
  }
}
