import 'package:cloud_firestore/cloud_firestore.dart';

class FillFormModel {
  FillFormModel({
    required this.name,
    required this.id,
    required this.email,
    required this.phone,
    required this.address1,
    required this.address2,
    required this.pincode,
    required this.landmark,
    required this.city,
    required this.state,
    required this.serviceName,
    required this.serviceLogo,
    required this.alternatePhone,
    required this.bio,
    required this.doc,
    required this.paid,
  });

  late final String name;
  late final String id;
  late final String email;
  late final String phone;
  late final String address1;
  late final String address2;
  late final String pincode;
  late final String landmark;
  late final String city;
  late final String state;
  late final String serviceName;
  late final String serviceLogo;
  late final String alternatePhone;
  late final String bio;
  late final String doc;
  late final bool paid;

  FillFormModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    id = json['id'] ?? '';
    email = json['email'] ?? '';
    phone = json['phone'] ?? '';
    address1 = json['address1'] ?? '';
    address2 = json['address2'] ?? '';
    pincode = json['pincode'] ?? '';
    landmark = json['landmark'] ?? '';
    city = json['city'] ?? '';
    state = json['state'] ?? '';
    serviceName = json['serviceName'] ?? '';
    serviceLogo = json['serviceLogo'] ?? '';
    alternatePhone = json['alternatePhone'] ?? '';
    bio = json['bio'] ?? '';
    doc = json['doc'] ?? '';
    paid = json['paid'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['email'] = email;
    data['phone'] = phone;
    data['address1'] = address1;
    data['address2'] = address2;
    data['pincode'] = pincode;
    data['landmark'] = landmark;
    data['city'] = city;
    data['state'] = state;
    data['serviceName'] = serviceName;
    data['serviceLogo'] = serviceLogo;
    data['alternatePhone'] = alternatePhone;
    data['bio'] = bio;
    data['doc'] = doc;
    data['paid'] = paid;
    return data;
  }

  static FillFormModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return FillFormModel.fromJson(snapshot);
  }
}
