import 'package:flutter/material.dart';

import '../global.dart';

class Services extends StatelessWidget {
  const Services({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Global.bg,
        title: Text("My Bookings",style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: Text("No Booking Done !"),
      ),
    );
  }
}
