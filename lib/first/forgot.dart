import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../functions/flush.dart';
import '../global.dart';



class ForgotP extends StatefulWidget {
  ForgotP({super.key});

  @override
  State<ForgotP> createState() => _ForgotPState();
}

class _ForgotPState extends State<ForgotP> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,

      body:Stack(
        children: [
          Image.network("https://img.freepik.com/free-vector/smart-home-background-with-smarthphone-control_23-2147846450.jpg",width: w,height: 360,fit: BoxFit.cover,),
          Padding(
            padding: const EdgeInsets.only(top:330),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
              ),
              width: w,height: h-240,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  Center(
                    child: Text("Forgot ? No Worries ! Reset your Password with Ease",textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
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
                          padding: const EdgeInsets.only( left :10, right : 18.0),
                          child: TextFormField(
                            controller: _emailController,
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

                  go?CircularProgressIndicator(
                    backgroundColor: Global.bg,
                  ):InkWell(
                      onTap: () async {
                        try{
                          await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
                          Navigator.pop(context);
                          Send.message(context, "Sent ! Please check your Email to Reset", true);
                        }catch(e){
                          Send.message(context, "$e", false);
                        }
                      },
                      child :Global.button(context,"Send Reset Link",Icon(Icons.lock_reset_outlined))),
                  Padding(
                    padding: const EdgeInsets.only(left : 15.0, right : 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children : [
                          TextButton(
                              child : Text("Not New ? Login", style : TextStyle(color : Global.bg)), onPressed : (){
                            Navigator.pop(context);
                          }
                          ),

                          SizedBox()
                        ]
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void a(){
    setState((){
      go = !go ;
    });
  }
  bool go = false;
}