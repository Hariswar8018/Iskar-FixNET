import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../global.dart';
import '../../model/fill_form.dart';
import '../../service/card.dart';

class AllOrders extends StatefulWidget {
  String status;
   AllOrders({super.key,required this.status});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  List<FillFormModel> _list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Global.bg,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        automaticallyImplyLeading: true,
        title: Text(widget.status=="All"?"All Bookings":"Bookings ${widget.status}",style: TextStyle(color: Colors.white),),
        actions: [
          TextButton.icon(onPressed: (){
            showStatusBottomSheet(context, (
                selectedStatus) async {
              widget.status=selectedStatus;
              setState(() {

              });
            });
          }, label: Text("Filter",style: TextStyle(color: Colors.white),),icon: Icon(Icons.filter_alt_sharp,color: Colors.white,),)
        ],
      ),
      body: StreamBuilder(
        stream:widget.status=="All"?FirebaseFirestore.instance
            .collection('services')
            .snapshots():FirebaseFirestore.instance
            .collection('services').where("status",isEqualTo: widget.status)
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
                    "No ${widget.status} Order",
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Enjoy ! No ${widget.status} Ordered Left in Bookings",
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
    );
  }

  void showStatusBottomSheet(BuildContext context, Function(String) onStatusSelected) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final List<String> statuses = [
          'All',
          'Pending',
          'Contacted',
          'Scheduled',
          'In Transit',
          'On Site',
          'Installed',
          'Rescheduled',
          'Cancelled',
        ];
        return Container(
          height: 800,width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'See Filter Bookings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: statuses.length,
                    physics: BouncingScrollPhysics(),
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      String status = statuses[index];
                      return ListTile(
                        leading: getStatusIcon(returnint(status)),
                        title: Text(status),
                        onTap: () {
                          Navigator.pop(context); // Close the sheet
                          onStatusSelected(status); // Pass selected status back
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
