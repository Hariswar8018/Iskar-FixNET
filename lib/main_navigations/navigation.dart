import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/tab_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iskar/main_navigations/profile.dart';
import 'package:iskar/main_navigations/services.dart';
import 'package:provider/provider.dart';

import '../admin/main_pages/navigation.dart';
import 'applications.dart';
import 'home.dart';

class Navigation extends StatefulWidget {
 Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  void fg() async{
    print("Going...................91");
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received message in foreground: ${message.notification?.title}");
      _showNotification(message);
    });
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id', // Replace with your channel ID
      'your_channel_name', // Replace with your channel name
      channelDescription: 'Your channel description', // Replace with your channel description
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
  }


  void requestNotificationPermission() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ User granted permission');
      fg();yu();
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('❌ User denied permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      print('❓ Permission not determined');
    }
  }

  Future<void> yu() async {
    try {
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
      CollectionReference collection =
      FirebaseFirestore.instance.collection('Users');
      String? token = await _firebaseMessaging.getToken();
      print(token);
      if (token != null) {
        await collection.doc(FirebaseAuth.instance.currentUser!.uid).update({
          'token': token,
        });
        _firebaseMessaging.requestPermission();
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  }
  int visit = 0;

  double height = 30;

  Color colorSelect =const Color(0XFF0686F8);

  Color color = const Color(0XFF7AC0FF);

  Color color2 = const Color(0XFF96B1FD);

  Color bgColor = const  Color(0XFF1752FE);

  Widget as(int i ){
    if( i == 1){
      return Services(searchable: '',);
    }else if(i == 0){
      return Home();
    }else if(i == 2){
      return Applications();
    }else{
      return Rewards();
    }
  }


  String ay(i){
    if( i == 0){
      return "Services";
    }else if(i == 1){
      return "Home";
    }else if(i == 2){
      return "Home";
    }else if(i == 3){
      return "Approvals";
    }else{
      return "More";
    }
  }


  @override
  Widget build(BuildContext context) {
    String? df=FirebaseAuth.instance.currentUser!.email;
    print(df);
    if(df!=null && df=="my@gmail.com"||df=="rajishms@gmail.com"||df=="rajeesh@iskargreenhomes.com"){
      return WillPopScope(
        onWillPop: () async {
          bool exit = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Exit App'),
                content: Text('Are you sure you want to exit?'),
                actions: [
                  ElevatedButton(
                    child: Text('No'),
                    onPressed: () {
                      // Return false to prevent the app from exiting
                      Navigator.of(context).pop(false);
                    },
                  ),
                  ElevatedButton(
                    child: Text('Yes'),
                    onPressed: () {
                      // Return true to allow the app to exit
                      Navigator.of(context).pop(true);
                      SystemNavigator.pop();
                    },
                  ),
                ],
              );
            },
          );

          // Return the result to handle the back button press
          return exit ?? false;
        },
        child: AdminLogin(),
      );
    }else{
      return  WillPopScope(
        onWillPop: () async {
          if(visit!=0){
            setState(() {
              visit=0;
            });
            return false;
          }
          bool exit = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Exit App'),
                content: Text('Are you sure you want to exit?'),
                actions: [
                  ElevatedButton(
                    child: Text('No'),
                    onPressed: () {
                      // Return false to prevent the app from exiting
                      Navigator.of(context).pop(false);
                    },
                  ),
                  ElevatedButton(
                    child: Text('Yes'),
                    onPressed: () {
                      // Return true to allow the app to exit
                      Navigator.of(context).pop(true);
                      SystemNavigator.pop();
                    },
                  ),
                ],
              );
            },
          );

          // Return the result to handle the back button press
          return exit ?? false;
        },
        child: Scaffold(

          body: as(visit),
          bottomNavigationBar: Container(
            child: BottomBarDefault(
              items: items,
              backgroundColor: Colors.white,
              color: Colors.black,
              colorSelected: colorSelect,
              indexSelected: visit,
              onTap: (int index) =>
                  setState(() {
                    visit = index;
                  }),
            ),
          ),
        ),
      );
    }
  }
}

const List<TabItem> items = [
  TabItem(
      icon: Icons.dashboard,
      title: "Home"
  ),
  TabItem(
    icon: Icons.table_chart_sharp,
    title: 'Bookings',
  ),
  TabItem(
    icon: Icons.home_work_rounded,
    title: 'Services',
  ),
  TabItem(
    icon: Icons.person,
    title: 'Profile',
  ),
];
