import 'package:flutter/material.dart';

import '../global.dart';
import 'package:share_plus/share_plus.dart';


class Refer extends StatelessWidget {
  const Refer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Global.bg,
        title: Text("Refer our App",style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          Image.asset("assets/refer_a_friend_10-1.webp"),
          SizedBox(height: 10,),
          Text(
            "Share & Refer",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              textAlign: TextAlign.center,
              "Invite your friends to join Iskar and earn rewards! Share your referral code and grow the community.",
              style: TextStyle(fontSize: 17, color: Colors.black,
            ),),
          ),
          SizedBox(height: 15,),
          InkWell(
              onTap: (){
                SharePlus.instance.share(
                    ShareParams(text: 'Download Iskar now: https://play.google.com/com.starwish.iskar')
                );
              },
              child: Global.button(context, "Share App Now", Icon(Icons.share))),
        ],
      ),
    );
  }
}
