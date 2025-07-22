import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iskar/first/onboarding.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/usermodel.dart';
import '../providers/declare.dart';

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
                child:pic.isNotEmpty?CircleAvatar(
                  radius: 68,
                  backgroundImage: NetworkImage(pic),
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
            Text("Demo Name",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 21),),
            Text(FirebaseAuth.instance.currentUser!.email??"None",style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 19,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    onTap: (){

                    },
                    child: f("assets/buy-cart-market-svgrepo-com.svg", "In Cart", context,"54")),
                InkWell(
                    onTap: (){

                    },
                    child: f("assets/delivery-svgrepo-com.svg", "In Transist", context,"69")),
                InkWell(
                    onTap: (){
                       },
                    child: f("assets/paid-svgrepo-com.svg", "Total Buyed", context,"40")),
              ],
            ),
            SizedBox(height: 10,),
            InkWell(
              onTap: (){

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

                },
                child: r(w, "All Services", Icon(Icons.account_balance_wallet))),
            InkWell(
                onTap: (){

                },
                child: r(w, "My Bookings", Icon(Icons.search))),
            InkWell(
                onTap: (){

                },
                child: r(w, "In Transit", Icon(Icons.chat))),
            InkWell(
                onTap: (){

                },
                child: r(w, "My Filled Forms", Icon(Icons.gamepad))),
            InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse('https://www.instagram.com/sukhdev_saran58');
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child: r(w, "Help & Support", Icon(Icons.support_agent_outlined))),
            InkWell(
                onTap: (){

                },
                child: r(w, "Transactions", Icon(Icons.local_activity_rounded))),
            InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse('https://sites.google.com/view/starwishterms/privacy_policy');
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child: r(w, "Privacy Policy", Icon(Icons.privacy_tip))),
            InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse('https://sites.google.com/view/starwishterms/termscondition');
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child: r(w, "Terms & Condition", Icon(Icons.accessibility_new))),
            InkWell(
                onTap: (){

                },
                child: r(w, "Refer", Icon(Icons.card_giftcard))),
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
  Widget r(double w, String str,Widget r)=>Center(
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      width: w-20,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            r,
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