import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:iskar/functions/flush.dart';

import '../global.dart';

class EmailVerifu extends StatelessWidget {
  const EmailVerifu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Global.background,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Global.bg,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text("Email Verify",style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/plugins_email-verification-plugin.png",width: 150,),
          Text("Verify your Email",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 22),),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 3),
            child: Text(textAlign: TextAlign.center,"Verify Your Email to Apply for Services, View Bookings, and much more",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),
          ),
          InkWell(
              onTap: () async {
                try{
                if(FirebaseAuth.instance.currentUser!.emailVerified){
                  Navigator.pop(context);
                  Send.message(context, "Email Verified !", true);
                }else{
                  Send.message(context, "Not Verified...Please Click on Link", false);
                }
                }catch(e){
                  Send.message(context, "$e", false);
                }
              },
              child: SizedBox(height: 10,)),
          Global.button(context, "Email Verify", Icon(Icons.email)),
          InkWell(
              onTap: () async {
                try {
                  await FirebaseAuth.instance.currentUser!
                      .sendEmailVerification();
                  Send.message(context, "Sended Email Verification Email", true);
                }catch(e){
                  Send.message(context, "$e", false);
                }
              },
              child: Global.button(context, "Resend Verification Email", Icon(Icons.alternate_email_rounded)))
        ],
      ),
    );
  }
}
