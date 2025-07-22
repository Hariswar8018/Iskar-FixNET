import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iskar/first/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'functions/flush.dart';

class Global {

  static Color bg = Color(0xff9C57CC);

  static Color background = Color(0xffEFE7FF);

  static Widget button(BuildContext context,String str,Widget ic){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Container(
          width : MediaQuery.of(context).size.width - 30, height : 60,
          decoration: BoxDecoration(
            color: Global.bg , // Background color of the container
            borderRadius: BorderRadius.circular(4.0), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1), // Shadow color
                spreadRadius: 5, // Spread radius
                blurRadius: 7, // Blur radius
                offset: Offset(0, 3), // Shadow position
              ),
            ],
          ),
          child : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(str, style : TextStyle( color : Colors.white,fontWeight: FontWeight.w900)),
              SizedBox(width: 10,),
              ic,
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child:SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  SizedBox(width: 10,),
                  r(Colors.red),
                  r(Colors.blue),
                  r(Colors.green),
                  Spacer(),
                  Icon(Icons.search,color: Colors.grey,size: 25,),
                  SizedBox(width: 13,),
                ],
              ),
              SizedBox(height: 23,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(width: 14,),
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/logo.jpg"),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                  Text(" Iskar InfoTech",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 21),),
                  Text(" v 1.0.0",style: TextStyle(fontWeight: FontWeight.w300,color: Colors.grey,fontSize: 9),),

                ],
              ),
              SizedBox(height: 5,),
              ty("Basic Functions"),
              InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse('https://ayusdev.xyz/');
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child:    p(Icon(Icons.language, color: Colors.black, size: 28,),"Our Website"),
              ),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                  Send.message(context, "Will function next Time", false);
                },
                child:  p(Icon(Icons.translate, color: Colors.black, size: 28,),"Change Language"),
              ),
              InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse('https://snl.starwish.fun');
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child: p(Icon(Icons.info, color: Colors.black, size: 28,),"Info"),
              ),
              InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse('https://wa.me/917000994158');
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child:  p(Icon(Icons.support, color: Colors.black, size: 28,),"Contact Us") ,
              ),
              InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse('https://wa.me/917978097489');
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child:  p(Icon(Icons.support_agent, color: Colors.green, size: 28,),"Developer Support") ,
              ),
              ty("Login Function"),
              InkWell(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  print('User signed out');
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool('Admin', false)  ;
                  prefs.setBool('Parent', false)  ;
                  prefs.setString('What', "hfhgvjhvhj")  ;
                  // Navigate to the login screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => TestScreen()),
                  );
                },
                child:  p(Icon(Icons.logout, color: Colors.red, size: 28,),"Log Out"),
              ),
              InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse('https://starwish.fun/privacy-policy-for-studio-next-light/');
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child: p(Icon(Icons.privacy_tip, color: Colors.black, size: 28,),"Privacy Policy"),
              ),
              InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse('https://snl.starwish.fun/delete-account/');
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child:  p(Icon(Icons.delete, color: Colors.black, size: 28,),"Delete Account"),
              ),
              InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse('https://snl.starwish.fun/close-account/');
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child:  p(Icon(Icons.close_rounded, color: Colors.black, size: 28,),"Close Account"),
              ),
              SizedBox(height: 25,),
              InkWell(
                onTap: ()async{

                },
                child:p(Icon(Icons.share, color: Colors.black, size: 28,),"Share App"),
              ),
              InkWell(
                onTap: () async {

                },
                child:  p(Icon(Icons.feedback, color: Colors.black, size: 28,),"Feedback"),
              ),
              ty("Social Networks"),
              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }
  static Widget ty(String yui){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20,),
        Text("  $yui",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.grey),),
      ],
    );
  }
  static p(Widget fg,String g){
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(width: 10,),
            fg,
            SizedBox(width: 9,),
            Text(g,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w300),),
          ],
        ),
      ),
    );
    return ListTile(
      leading: fg,
      title: Text(g,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
    );
  }
  static Widget r(Color color)=>Padding(
    padding: const EdgeInsets.all(3.0),
    child: Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    ),
  );
}