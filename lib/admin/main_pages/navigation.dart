import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iskar/admin/main_pages/all_users.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../first/onboarding.dart';
import '../../global.dart';
import '../../model/fill_form.dart';
import '../../service/card.dart';
import 'all_orders.dart';

class AdminLogin extends StatefulWidget {
   AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {

  Icon getStatusIcon(int status) {
    switch (status) {
      case 0: // Pending
        return const Icon(Icons.hourglass_empty, color: Colors.orange);
      case 1: // Contacted
        return const Icon(Icons.phone_in_talk, color: Colors.blueGrey);
      case 2: // In Transit
        return const Icon(Icons.local_shipping, color: Colors.teal);
      case 3: // Scheduled
        return const Icon(Icons.event_available, color: Colors.indigo);
      case 4: // On Site
        return const Icon(Icons.location_on, color: Colors.deepOrange);
      case 5: // Installed
        return const Icon(Icons.check_circle, color: Colors.green);
      case 6: // Rescheduled
        return const Icon(Icons.schedule, color: Colors.redAccent);
      default: // Unknown
        return const Icon(Icons.help_outline, color: Colors.grey);
    }
  }
  void initState(){
    fetchCounts();
  }
  int totalUsers = 0;
  int scheduledForms = 0;
  int pendingForms = 0;

  int onsite=0, instalaled=0, resheduled=0;

  void fetchCounts() async {
    // 🔢 Count Users
    final usersSnapshot = await FirebaseFirestore.instance.collection('Users').get();
    totalUsers = usersSnapshot.size;

    // 📅 Count Scheduled Forms
    final scheduledSnapshot = await FirebaseFirestore.instance
        .collection('services')
        .where('status', isEqualTo: 'Scheduled')
        .get();
    scheduledForms = scheduledSnapshot.size;

    // ⏳ Count Pending Forms
    final pendingSnapshot = await FirebaseFirestore.instance
        .collection('services')
        .where('status', isEqualTo: 'Pending')
        .get();
    pendingForms = pendingSnapshot.size;

    final onsiteSnapshot = await FirebaseFirestore.instance
        .collection('services')
        .where('status', isEqualTo: 'On Site')
        .get();
    onsite = onsiteSnapshot.size;

    final instaSnapshot = await FirebaseFirestore.instance
        .collection('services')
        .where('status', isEqualTo: 'Installed')
        .get();
    instalaled = instaSnapshot.size;
    final reSnapshot = await FirebaseFirestore.instance
        .collection('services')
        .where('status', isEqualTo: 'Rescheduled')
        .get();
    resheduled = reSnapshot.size;


    print("Users: $totalUsers");
    print("Scheduled Forms: $scheduledForms");
    print("Pending Forms: $pendingForms");
    setState((){

    });
    // Call setState() if inside a StatefulWidget
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Global.bg,
        title: Text("Admin Panel",style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(onPressed: () async {
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
          }, icon: Icon(Icons.login,color: Colors.red,))
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AllOrders(status: 'Scheduled',)));

                  },
                  child: srr("Sheduled", w, Colors.orange.shade200, scheduledForms,getStatusIcon(3))),
              InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AllOrders(status: 'Pending',)));

                  },
                  child: srr("Pending", w, Colors.blue.shade200, pendingForms,getStatusIcon(0))),
              InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AllUsers()));
                  },
                  child: srr("Total Users", w, Colors.yellow, totalUsers,Icon(Icons.person,color: Colors.black,))),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AllOrders(status: 'On Site',)));

                  },
                  child: srr("On Site", w, Colors.green.shade200, onsite,getStatusIcon(4))),
              InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AllOrders(status: 'PendingInstalled',)));

                  },
                  child: srr("Installed", w, Colors.greenAccent.shade200, instalaled,Icon(Icons.pending_actions,color: Colors.black,))),
              InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AllOrders(status: 'Rescheduled',)));
                  },
                  child: srr("Rescheduled", w, Colors.pink.shade200, resheduled,getStatusIcon(6))),
            ],
          ),
          SizedBox(height: 10,),
          Container(
            height: h-300,
            child: StreamBuilder(
              stream:FirebaseFirestore.instance
                  .collection('services')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Looks Like you haven't yet Book",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Start by Filling the Form and Apply for Service",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  );
                }
                final data = snapshot.data?.docs;
                _list.clear();
                _list.addAll(
                    data?.map((e) => FillFormModel.fromJson(e.data())).toList() ??
                        []);
                return ListView.builder(
                  itemCount: _list.length,
                  padding: EdgeInsets.only(top: 0),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUser(form: _list[index],admin: true,);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<FillFormModel> _list = [];

  Widget srr(String str,double w,Color color,int i, Widget s){
    return Container(
      width:w/3-10 ,
      height: 80,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          s,
          Text(str,style: TextStyle(fontWeight: FontWeight.w800,color: Colors.black,fontSize: 10),),
          Text("$i",style: TextStyle(fontWeight: FontWeight.w800,color: Colors.black,fontSize: 16),),
        ],
      ),
    );
  }
}
