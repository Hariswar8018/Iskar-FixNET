import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iskar/first/onboarding.dart';
import 'package:iskar/main_navigations/applications.dart';
import 'package:iskar/main_navigations/services.dart';
import 'package:iskar/second_pages/refer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/usermodel.dart';
import '../providers/declare.dart';
import '../second_pages/my_profile.dart';

class Rewards extends StatelessWidget {

  bool back;
  Rewards({super.key,this.back=false});
  Widget f(String str, String str2,BuildContext context,String str3){
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
      ),
      width: MediaQuery.of(context).size.width/3-14,
      height: MediaQuery.of(context).size.width/4-10,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0,left: 14,right: 8,bottom: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              str,
              height: MediaQuery.of(context).size.width/7-30,
              semanticsLabel: 'Dart Logo',
            ),
            SizedBox(height: 3,),
            Text(str3,style: TextStyle(fontSize: MediaQuery.of(context).size.width/30,color: Colors.black,fontWeight: FontWeight.w600),),
            Text(str2,style: TextStyle(fontSize: MediaQuery.of(context).size.width/35,color: Colors.black),),
          ],
        ),
      ),
    );
  }
  String pic = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: back?InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)):SizedBox(),
      ),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100,),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(7),
                child:AppSession.currentUser!.pic.isNotEmpty?CircleAvatar(
                  radius: 68,
                  backgroundImage: NetworkImage(AppSession.currentUser!.pic),
                ): CircleAvatar(
                  radius: 68,
                  backgroundColor: Colors.grey.shade300,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.grey.shade300,
                          child: Center(child: Icon(Icons.person,color: Colors.black,size: 60,),),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 6,),
            Text(AppSession.currentUser!.Name,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 21),),
            Text((AppSession.currentUser!.byphone)?AppSession.currentUser!.phone:AppSession.currentUser!.Email,style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 19,),
            SizedBox(height: 10,),
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyProfile()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)
                    )
                ),
                width: w-20,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      Icon(Icons.person,color: Colors.black),
                      SizedBox(width: 7,),
                      Text("User Profile",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios,color: Colors.black,size: 18,),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Applications(shows: true,)),
                  );
                },
                child: ras(w, "All Services", Icon(Icons.segment_rounded,color: Colors.black,))),
            InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Services(shows: true, searchable: '',)),
                  );
                },
                child: ras(w, "My Bookings", Icon(Icons.menu,color: Colors.black,))),
               InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse('https://wa.me/918848371829');
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child: ras(w, "Help & Support", Icon(Icons.support_agent_outlined,color: Colors.black,))),

            InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse('https://iskargreenhomes.com/about-us/');
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child: ras(w, "Our Website", Icon(Icons.language,color: Colors.black,))),
            InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse('tel:8848371829');
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child: ras(w, "Call Us", Icon(Icons.call_rounded,color: Colors.black,))),
            InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Refer()),
                  );
                },
                child: ras(w, "Refer & Share ", Icon(Icons.share,color: Colors.black,))),
            InkWell(
              onTap: (){
                FirebaseAuth auth = FirebaseAuth.instance;
                auth.signOut().then((res) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => TestScreen()),
                  );
                });
              },
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                      )
                  ),
                  width: w-20,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        Icon(Icons.login,color: Colors.red),
                        SizedBox(width: 7,),
                        Text("Log Out",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w500),)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40,),
          ],
        ),
      ),
    );
  }
  Widget ras(double w, String str,Widget r1)=>Center(
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      width: w-20,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            r1,
            SizedBox(width: 7,),
            Text(str,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
            Spacer(),
            Icon(Icons.arrow_forward_ios,color: Colors.black,size: 18,),
          ],
        ),
      ),
    ),
  );
}