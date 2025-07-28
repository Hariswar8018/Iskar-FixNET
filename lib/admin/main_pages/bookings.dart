import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iskar/service/card.dart';
import 'package:iskar/service/service_card.dart';

import '../../global.dart';
import '../../model/fill_form.dart';
import '../../model/usermodel.dart';



class Bookings extends StatelessWidget {
  UserModel user;
  Bookings({super.key,required this.user});
  List<FillFormModel> _list = [];
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Global.bg,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        automaticallyImplyLeading: true,
        title: Text(user.Name,style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,width: w,
            child: Card(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15,),
                  Text("    User Details",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 19),),
                  ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>Bookings(user: user,)));
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.pic),
                    ),
                    title: Text(user.Name,style: TextStyle(fontWeight: FontWeight.w800),),
                    subtitle: Text(user.Email),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(user.bio),
                  ),
                ],
              ),
            ),
          ),
          Text("    All Bookings",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 19),),
          Container(
            height: h-300,
            child: StreamBuilder(
              stream:FirebaseFirestore.instance
                  .collection('services').where("customerId",isEqualTo: user.uid)
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
                    return ChatUser(form: _list[index],);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

