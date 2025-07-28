import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iskar/admin/main_pages/bookings.dart';

import '../../global.dart';
import '../../model/usermodel.dart';

class AllUsers extends StatelessWidget {
  AllUsers({super.key});
  List<UserModel> _list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          automaticallyImplyLeading: true,
          backgroundColor: Global.bg,
          title: Text("All Users",style: TextStyle(color: Colors.white),),
        ),
      body: StreamBuilder(
        stream:FirebaseFirestore.instance
            .collection('Users')
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
              data?.map((e) => UserModel.fromJson(e.data())).toList() ??
                  []);
          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final user = _list[index];
              return Card(
                color: Colors.white,
                child: ListTile(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>Bookings(user: user,)));
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.pic),
                  ),
                  title: Text(user.Name,style: TextStyle(fontWeight: FontWeight.w800),),
                  subtitle: Text(user.Email),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
