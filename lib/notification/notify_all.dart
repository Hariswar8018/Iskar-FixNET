

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cloud_messaging_flutter/firebase_cloud_messaging_flutter.dart';

import '../model/usermodel.dart';


class NotifyAll{
  static  sendNotificationsAdmin(String name, String desc) async {
    // Fetch tokens from Firestore where 'arrayField' contains '1257'
    try{
      List<String> allowedEmails = [
        "my@gmail.com",
        "rajishms@gmail.com",
        "rajeesh@iskargreenhomes.com"
      ];

      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', whereIn: allowedEmails)
          .get();

      print(usersSnapshot);
      List<String> tokens = [];

      // Extract tokens from the fetched documents
      // Extract tokens from the fetched documents
      usersSnapshot.docs.forEach((doc) {
        // Explicitly cast doc.data() to Map<String, dynamic>
        var data = doc.data() as Map<String, dynamic>;

        var user = UserModel.fromJson(data); // Assuming UserModel.fromJson correctly initializes from Map
        print(data);
        if (user.token != null) {
          tokens.add(user.token);
          print(tokens);
        }
      });
      await sendNotificationsCompany(name, desc, tokens);
    }catch(e){
      print(e);
    }
  }

  static  sendNotificationsCustomer(String name, String desc,String id) async {
    // Fetch tokens from Firestore where 'arrayField' contains '1257'
    try{
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('uid', isEqualTo: id)
          .get();

      List<String> tokens = [];

      // Extract tokens from the fetched documents
      // Extract tokens from the fetched documents
      usersSnapshot.docs.forEach((doc) {
        // Explicitly cast doc.data() to Map<String, dynamic>
        var data = doc.data() as Map<String, dynamic>;

        var user = UserModel.fromJson(data); // Assuming UserModel.fromJson correctly initializes from Map
        print(data);
        if (user.token != null) {
          tokens.add(user.token);
        }
      });
      await sendNotificationsCompany(name, desc, tokens);
    }catch(e){
      print(e);
    }
  }

  static Future<void> sendNotificationsCompany(String name, String desc,List tokens) async {
    var server = FirebaseCloudMessagingServer(
      serviceAccountFileContent,
    );
    for(String token in tokens){
      print(token);
      print("------------------------------------------------------->");
      try{
        var result = await server.send(
          FirebaseSend(
            validateOnly: false,
            message: FirebaseMessage(
              notification: FirebaseNotification(
                title: name,
                body: desc,
              ),
              android: FirebaseAndroidConfig(
                ttl: '3s', // Optional TTL for notification
                /// Add Delay in String. If you want to add 1 minute delay then add it like "60s"
                notification: FirebaseAndroidNotification(
                  icon: 'ic_notification', // Optional icon
                  color: '#009999', // Optional color
                ),
              ),
              token: token, // Send notification to specific user's token
            ),
          ),
        );

        // Print request response
        print(result.toString());
      }catch(e){
        print(e);
      }
    }

  }



  static Future<void> sendallhradmin(String source, String name, String desc) async {
    try {
      List<String> tokens = [];
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('type', whereIn: ['Director', 'Organisation'])
          .where('source', isEqualTo: source)
          .get();
      usersSnapshot.docs.forEach((doc) {
        var data = doc.data() as Map<String, dynamic>;
        var user = UserModel.fromJson(data);
        if (user.token != null) {
          tokens.add(user.token);
        }
      });

      if (tokens.isNotEmpty) {
        await sendNotificationsCompany(name, desc, tokens);
        print("Notifications sent successfully.");
      } else {
        print("No tokens found for the given source.");
      }
    } catch (e) {
      print("Error: $e");
    }
  }


  static final serviceAccountFileContent = <String, String>{
    'type': 'service_account',
    'project_id': 'iskar-home-managment',
    'private_key_id': '2f364ed9fe4663955726e028027188e105f7fa96',
    'private_key': '-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDDTDpa501//fxq\niJ9nXjwovumowna2whNCcN8hGBIarhHq8Y/+JkMTgkeoxxTJMLNK9R2D8fX1v+qZ\nN8MsISDlGQ3i+MXwIaBTfUmHy0vQ9kFiazfNCbv7r9fFbqDnvrQQ8UGerRDhMhdm\nrXxY/1/yk5yPTqq2TYCb0faJrjLeHskjMqJRi8I1U1LSfGcLBWPeLbRuFkiv/H4w\nAxvZBv+JBkVydhBCmCDYe3rguQ/mhb74NIJtnuG2W8Nagy2/KWXuAMzRGacvYIEN\nKTfNfKn1dtAFaaEUvnqLyoxi8DnoSCz3C45AcYr9kut6OntOom27efnvovnzyPUP\nEgQ0emhLAgMBAAECggEAHs+ybzAJ0pUcEySt3W2JGTaRf536g7fXuQY8tahqBsqK\nqiHlQUgBEh1eN9r8xQcJalyEhRIR520ZUoXxJU+utGZBAhuUgt+TP0jHZoSk1/lZ\n9HCM86zC+yDRbmUXPqigGQIvA50zSgwQlBLvyMy1cvxl2VgkZ7GPhkXYWv1gKhmz\nNfC8c18cCXaipnk6BsBGtAtAkobuUPW5SJF+KNg3DqRBJmdQde9ZBCpVz8n5plpE\n9be8jQDpkIY0s0uw010EEFxgHpjHKfj1aq6tvooAV6jXMV1xdB0effDmytTPUmfN\naQhCeSwYZVwqutsvBB4doe7aymen/KdLI2lgbrLmSQKBgQD8swhGT+Oi7bVB5zwl\ngeGpjKd4+Vmj8O6STLCm5EaKNgOJJKV4o9D9fLPVCSFdEZhkySNTUh5Tr72lBc0E\nvKwUMBcsWR5iNTpjuuvU05R4IvzL3GGEteZ5dJ1u8MxZZ3wadWWXq71KRRLJdglU\nW3OeNrNIN+MaTKe1GCNN6HjoYwKBgQDF2UIU5Q7gQ+Y2U+ZUbXz5aO97Tbp0yj6h\nK1DOAeCcX5fXiRCix9JEyI06gctJTIq6UAeImCqv/CZtB1dQ9SxCPtlJPe+Dv5oq\nJ8/qKEAkm+oq7a4T45PDwo0Z/HTDHuhgelo5WKkr2YDWF070CYANbaneY8RSFU1m\nq7zc5Rwg+QKBgQDp+LpIn9+dE4soIfnGoKNYYSsPD5C4AnRicS9+1w2ZGrnbWVr8\ngHEYw0Wekn2ZtpjreHCEzRvXUHi/OsfBAxAxAPXz0fAX7kDJ5mBFBkIJmhuGhd6l\nCecDvb2m4r3Saca2mMwfypvREHN8pRWuTZ6Xdv44d8aGq0L8ogTONdj9EQKBgA58\n1UDwcQFtF2t9A03FYrRkwbyWuYOZ17I3mMgtDQSGX3kR+VziIvyUbvsMzBUG/NWd\nzJ9s/Rs77JhpRDSSb3Y+YeziEyrjmediWPA9mEzV+fTAyNF+BbD9CxYPDYHIPp3p\n97dhTan/WFbVCBwIog7Zq+m0Bok4NB3Dj6XhRQkJAoGBALpBd6NB+pyNh+WFJh6y\nY+xrGxRH/FDi6LJkAE1ZDIULi3ceGuagjvplX36zEVi5iQWYJpzKlh0vLiYQ9uJd\nYp7AHbrfKsKnRkPDhcejHJGSPCENymfX/mZ3yC2AphqtArxfbpa4MEc/BmlSDpVX\ngKmmOKukHlUVh3qA46ur1sOL\n-----END PRIVATE KEY-----\n',
    'client_email': 'firebase-adminsdk-fbsvc@iskar-home-managment.iam.gserviceaccount.com',
    'client_id': '116854763838177635647',
    'auth_uri': 'https://accounts.google.com/o/oauth2/auth',
    'token_uri': 'https://oauth2.googleapis.com/token',
    'auth_provider_x509_cert_url': 'https://www.googleapis.com/oauth2/v1/certs',
    'client_x509_cert_url': 'https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40iskar-home-managment.iam.gserviceaccount.com',
  };

}
