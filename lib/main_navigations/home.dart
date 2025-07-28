import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:iskar/global.dart';
import 'package:iskar/main_navigations/applications.dart';

import '../model/fill_form.dart';
import '../model/service.dart';
import '../service/card.dart';

class Home extends StatelessWidget {
   Home({super.key});
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white12,
      key: _key, // Assign the key to Scaffold.
      drawer: Global.buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
          height: 380,width: w,
          color: Global.bg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height:35,),
              Center(
                child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 12,),
                  decoration: BoxDecoration(
                    color: Global.bg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: InkWell(
                            onTap: (){
                              _key.currentState!.openDrawer();
                            },
                            child: Icon(Icons.menu, color: Colors.white)),
                        hintText: 'Search for your need',hintStyle: TextStyle(color: Colors.white)
                      ),
                      onFieldSubmitted: (value){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>Applications(shows: true,search: value,)));
                      },
                      onSaved: (value){
                        if(value!=null){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>Applications(shows: true,search: value,)));
                        }
                      },
                    ),
                  ),
                ),
                    ),
              ),
              SizedBox(height:12,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text("Trending Services",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),
              ),
              SizedBox(height: 15,),
              Container(
                width: w,height: w/3,
                child: ListView.builder(
                  itemCount: 4,scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return ServiceCard.card(w, service,context);
                  },
                ),
              ),
              SizedBox(height: 15,),
              Center(
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>Applications(shows: true,)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13.0,vertical: 8),
                      child: Text("Show All",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
            Container(
              width: w,
              height: 60,
              child: Stack(
                children: [
                  Container(
                    width: w,
                    height: 60,
                    color: Global.bg,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                      width: w,height: 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)
                          )
                      ),
                    ),
                  )
        
                ],
              ),
            ),
            Center(
              child: Card(
                color: Colors.white,
                child: Container(
                  width: w-20,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Book in 3 Easy Step",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 18),),
                        Text("Add your Application to get Fast Delivery",style: TextStyle(fontWeight: FontWeight.w500),),
                        SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                  child: SvgPicture.asset("assets/cart-plus-svgrepo-com.svg"),
                                ),
                               a("Add"),
                                a("Applications")
                              ],
                            ),
                            Icon(Icons.arrow_forward_outlined,color: Colors.blue,),
                            Column(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                  child: SvgPicture.asset("assets/form-svgrepo-com.svg"),
                                ),
                                a("Shedule Date"),
                                a("& Time ")
                              ],
                            ),
                            Icon(Icons.arrow_forward_outlined,color: Colors.blue,),
                            Column(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                  child: SvgPicture.asset("assets/delivery-svgrepo-com.svg"),
                                ),
                                a("Book"),
                                a("Service")
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text("  My Orders",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
            ),
            ShowMyAllOrder(),
            SizedBox(height: 60,)
            ],
        ),
      ),
    );
  }
  Widget a(String str)=> Text(str,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),);
}

class ShowMyAllOrder extends StatelessWidget {
  ShowMyAllOrder({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Container(
      width: w,height: 150,
      child: FutureBuilder(
       future:FirebaseFirestore.instance
            .collection('services').where("customerId",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get(),
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
            padding: EdgeInsets.only(top: 10),
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final FillFormModel form = _list[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2),
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) => FullCard(form: form)));
                  },
                  child: Container(
                    width: w-80,
                    height: 100,
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: card(form.serviceLogo),
                              title: Text(form.serviceName,maxLines: 2,style: TextStyle(fontWeight: FontWeight.w800),),
                              subtitle: Text(form.status,style: TextStyle(fontWeight: FontWeight.w800),),
                              trailing: getStatusIcon(returnint(form.status)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0,right: 18,bottom: 6),
                              child: sendmessage(form),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  Widget sendmessage(FillFormModel form){
    int i = returnint(form.status);
    if(i<1){
      return Text("Ordered done on ${datetime(form.id)} ");
    }else if(i>=1&&i<=4){
      return Text("Sheduled on ${datetime(form.sheduledate)}",style: TextStyle(fontWeight: FontWeight.w900),);
    }
    return Text("Installed on ${datetime(form.sheduledate)}");
  }

  String datetime(String str){
    try {
      DateTime give = DateTime.parse(str);
      return formatDateTimeSmart(give);
    }catch(e){
      return "Unknown";
    }
  }
  String formatDateTimeSmart(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dtDay = DateTime(dt.year, dt.month, dt.day);

    final timeStr = DateFormat.jm().format(dt);

    if (dtDay == today) {
      return timeStr + "  Today";
    } else if (dtDay == tomorrow) {
      return "Tomorrow at $timeStr";
    } else {
      final dateStr = DateFormat('dd/MM/yyyy').format(dt);
      return "$timeStr on $dateStr";
    }
  }
  List<FillFormModel> _list = [];
  Widget card(service){
    try{
      return SvgPicture.asset(service,width: 50,);
    }catch(e){
      return SvgPicture.asset("assets/buy-cart-market-svgrepo-com.svg",width: 50,);
    }
  }

  int returnint(String str){
    if(str=="In Transit"){
      return 2;
    }else if(str=="Contacted"){
      return 1;
    }else if(str=="Pending"){
      return 0;
    }else if(str=="Scheduled"){
      return 3;
    }else if(str=="On Site"){
      return 4;
    }else if(str=="Installed"){
      return 5;
    }else if(str=="Rescheduled"){
      return 6;
    }else {
      return -1;
    }
  }

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
}
