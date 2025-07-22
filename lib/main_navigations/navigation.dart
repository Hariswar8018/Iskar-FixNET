import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/tab_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  int visit = 0;

  double height = 30;

  Color colorSelect =const Color(0XFF0686F8);

  Color color = const Color(0XFF7AC0FF);

  Color color2 = const Color(0XFF96B1FD);

  Color bgColor = const  Color(0XFF1752FE);

  Widget as(int i ){
    if( i == 1){
      return Services();
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

 /* void vq() async {
    try {
      UserProvider _userprovider = Provider.of<UserProvider>(context, listen: false);
      await _userprovider.refreshuser();
      print("User Data: ${_userprovider.getUser}");
    } catch (e, stacktrace) {
      print("Error in vq: $e, Stacktrace: $stacktrace");
    }
  }
*/


  @override
  Widget build(BuildContext context) {
    String? df=FirebaseAuth.instance.currentUser!.email;
    print(df);
    if(df!=null && df=="brnrinnovation@gmail.com"||df=="admin@zeitt.com"){
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
    title: 'Applications',
  ),
  TabItem(
    icon: Icons.person,
    title: 'Profile',
  ),
];
