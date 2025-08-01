import 'dart:async';
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iskar/global.dart';
import 'package:iskar/providers/bloc.dart';

import 'firebase_options.dart';
import 'first/onboarding.dart';
import 'main_navigations/navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler); // ✅ only once
  runApp(
      const MyApp()
  );
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); // required
  print('Handling a background message: ${message.messageId}');
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iskar FixNET',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Global.bg),
        iconTheme: const IconThemeData(
          color: Colors.white, // Global icon color
        ),
      ),debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc(FirebaseAuth.instance, FirebaseFirestore.instance)..add(CheckAuthStatus()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashAuthenticated) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Navigation()));
          } else if (state is SplashUnauthenticated) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TestScreen()));
          } else if (state is SplashError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TestScreen()));
          }
        },
        child: Scaffold(
          body: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image(
                image: AssetImage('assets/logo.jpg'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
