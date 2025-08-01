import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iskar/functions/flush.dart';
import 'package:iskar/main.dart';

import '../global.dart';
import '../providers/declare.dart';

class MyProfile extends StatefulWidget {
   MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String pic="";

  void initState(){
    name.text=AppSession.currentUser!.Name;
    pic=AppSession.currentUser!.pic;
    phone.text=AppSession.currentUser!.phone;
    bio.text=AppSession.currentUser!.bio;
    email.text=AppSession.currentUser!.Email;
    emailon=AppSession.currentUser!.byphone;
  }

  bool emailon=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Global.bg,
        title: Text("My Profile",style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
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
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width : MediaQuery.of(context).size.width  , height : 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade100, // Background color of the container
                borderRadius: BorderRadius.circular(15.0), // Rounded corners
              ),
              child: Padding(
                  padding: const EdgeInsets.only( left :25, right : 25.0),
                  child: TextFormField(
                    controller: name,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'Your Name',
                      isDense: true,
                      border: InputBorder.none, // No border
                    ),
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width : MediaQuery.of(context).size.width  , height : 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade100, // Background color of the container
                borderRadius: BorderRadius.circular(15.0), // Rounded corners
              ),
              child: Padding(
                  padding: const EdgeInsets.only( left :25, right : 25.0),
                  child: TextFormField(
                    controller: email,readOnly: !emailon,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Your Email',
                      isDense: true,
                      border: InputBorder.none, // No border
                    ),
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width : MediaQuery.of(context).size.width  , height : 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade100, // Background color of the container
                borderRadius: BorderRadius.circular(15.0), // Rounded corners
              ),
              child: Padding(
                  padding: const EdgeInsets.only( left :25, right : 25.0),
                  child: TextFormField(
                    controller: phone,readOnly: emailon,
                    keyboardType: TextInputType.phone,maxLength: 10,
                    decoration: InputDecoration(
                      labelText: 'Your Phone',
                      isDense: true,
                      counterText: '',
                      border: InputBorder.none, // No border
                    ),
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width : MediaQuery.of(context).size.width  , height : 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade100, // Background color of the container
                borderRadius: BorderRadius.circular(15.0), // Rounded corners
              ),
              child: Padding(
                  padding: const EdgeInsets.only( left :25, right : 25.0),
                  child: TextFormField(
                    controller: bio,minLines: 4,maxLines: 10,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Your Bio',
                      isDense: true,
                      border: InputBorder.none, // No border
                    ),
                  )
              ),
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        InkWell(
            onTap: () async {
              try {
                await FirebaseFirestore.instance.collection("Users").doc(
                    FirebaseAuth.instance.currentUser!.uid).update({
                  "name": name.text,
                  "phone": phone.text,
                  "bio": bio.text,
                  "pic": pic,
                });
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MyApp()));
                Send.message(context, "Profile Saved", true);
              }catch(e){
                Send.message(context, e.toString(), false);
              }
            },
            child: Global.button(context, "Save Profile", Icon(Icons.data_saver_off_outlined)))
      ],
    );
  }

  TextEditingController name = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController bio = TextEditingController();

  TextEditingController phone = TextEditingController();
}
