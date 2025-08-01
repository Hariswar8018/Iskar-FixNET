import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:iskar/functions/flush.dart';
import 'package:iskar/model/fill_form.dart';
import 'package:iskar/notification/notify_all.dart';
import 'package:iskar/service/list_show.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:add_2_calendar_new/add_2_calendar_new.dart';

import '../global.dart';

class ChatUser extends StatelessWidget {
  FillFormModel form;bool admin;
  ChatUser({super.key,required this.form, this.admin=false});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;    print(form.toJson());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2),
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) => FullCard(form: form)));
        },
        onLongPress: (){
          if(!admin){
            return ;
          }
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Confirm"),
              content: Text("Do you want to proceed?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false); // No
                  },
                  child: Text("No"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true); // Yes
                  },
                  child: Text("Yes"),
                ),
              ],
            ),
          ).then((value) {
            if (value == true) {
              FirebaseFirestore.instance
                  .collection('services').doc(form.id).delete();
            } else {
              // User pressed No or dismissed
              print("No selected or dismissed");
            }
          });
        },
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: card(),
                  title: Text(form.serviceName+(form.added.isEmpty?"":" + ${form.added.length} more"),style: TextStyle(fontWeight: FontWeight.w800),),
                  subtitle: Text(form.status,style: TextStyle(fontWeight: FontWeight.w800),),
                  trailing: getStatusIcon(returnint(form.status)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0,right: 18,bottom: 6),
                  child: sendmessage(),
                ),
                admin?Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          onTap: () async {
                            try {
                              showStatusBottomSheet(context, (
                                  selectedStatus) async {
                                await FirebaseFirestore.instance.collection(
                                    "services").doc(form.id).update({
                                  "status": selectedStatus,
                                });
                                await NotifyAll.sendNotificationsCustomer("Your Order was marked ${selectedStatus}", "An Admin Just marked your Order Status as ${selectedStatus}", form.customerId);
                              });
                            }catch(e){
                              Send.message(context, "$e", false);
                            }
                          },
                          child: adminbox(w, "Set Order Status",Colors.yellow)),
                      InkWell(
                          onTap: () async {
                            try{
                            DateTime? dateTime = await showOmniDateTimePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate:
                              DateTime(1600).subtract(
                                  const Duration(days: 3652)),
                              lastDate: DateTime.now().add(
                                const Duration(days: 3652),
                              ),
                              is24HourMode: false,
                              isShowSeconds: false,
                              minutesInterval: 1,
                              secondsInterval: 1,
                              isForce2Digits: false,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(16)),
                              constraints: const BoxConstraints(
                                maxWidth: 350,
                                maxHeight: 650,
                              ),
                              transitionBuilder: (context, anim1, anim2,
                                  child) {
                                return FadeTransition(
                                  opacity: anim1.drive(
                                    Tween(
                                      begin: 0,
                                      end: 1,
                                    ),
                                  ),
                                  child: child,
                                );
                              },
                              transitionDuration: const Duration(
                                  milliseconds: 200),
                              barrierDismissible: true,
                              barrierColor: const Color(0x80000000),
                              selectableDayPredicate: (dateTime) {
                                // Disable 25th Feb 2023
                                if (dateTime == DateTime(2023, 2, 25)) {
                                  return false;
                                } else {
                                  return true;
                                }
                              },
                              type: OmniDateTimePickerType.dateAndTime,
                              title: Text('Select Installation Date & Time'),
                              titleSeparator: Divider(),
                              separator: SizedBox(height: 16),
                              padding: EdgeInsets.all(16),
                              insetPadding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 24),
                              theme: ThemeData.light(),
                            );
                            if (dateTime != null) {
                              await FirebaseFirestore.instance.collection(
                                  "services").doc(form.id).update({
                                "sheduledate": dateTime.toString(),
                              });
                              Send.message(context,
                                  "Order Sheduled for ${form.customerName}",
                                  true);
                              await NotifyAll.sendNotificationsCustomer("Your Order was Scheduled for ${datetime(dateTime.toString())}", "An Admin Sheduled your Installation of ${form.serviceName} at ${datetime(dateTime.toString())}", form.customerId);
                            }
                          }catch(E){
                              Send.message(context, "$E", false);
                            }
                          },
                          child: adminbox(w, "Shedule Install",Colors.lightBlueAccent.shade200)),
                    ],
                  ),
                ):SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sendmessage(){
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
  Widget adminbox(double w,String str,Color color){
    return Container(
      width: w/2-25,
      height: 40,
     decoration: BoxDecoration(
       color: color,
       borderRadius: BorderRadius.circular(5)
     ),
      child: Center(child: Text(str)),
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
                    'Update Order Status',
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

  Widget card(){
    try{
      return SvgPicture.asset(form.serviceLogo,width: 50,);
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

class FullCard extends StatefulWidget {
  FillFormModel form;
   FullCard({super.key,required this.form});

  @override
  State<FullCard> createState() => _FullCardState();
}

class _FullCardState extends State<FullCard> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Global.bg,
        title: Text("My Bookings",style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: SvgPicture.asset(widget.form.serviceLogo,width: 50,),
            title: Text(widget.form.serviceName+(widget.form.added.isEmpty?"":" + ${widget.form.added.length} More"),style: TextStyle(fontWeight: FontWeight.w800),),
            subtitle: Text(widget.form.status,style: TextStyle(fontWeight: FontWeight.w800),),
            trailing: getStatusIcon(returnint(widget.form.status)),
          ),
          widget.form.added.isEmpty?SizedBox():ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>ListShow(list: widget.form.added)));
            },
            leading: Icon(Icons.shopping_cart),
            trailing: Icon(Icons.arrow_forward_rounded),
            title: Text("Added ${widget.form.added.length} Extra Services",style: TextStyle(fontWeight: FontWeight.w800),),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.form.customerPic),
            ),
            title: Text(widget.form.customerName,style: TextStyle(fontWeight: FontWeight.w800),),
            subtitle: Text(widget.form.email,style: TextStyle(fontWeight: FontWeight.w400),),
          ),
          SizedBox(height: 13,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              rows("Installation", 0,w),rows("Contact", 1,w),rows("Address", 2,w),
            ],
          ),
          SizedBox(height: 20,),
          giveback(w),
        ],
      ),
    );
  }

  Widget giveback(double w){
    if(i==0){
      return r1(w);
    }else if (i==2){
      return r2(w);
    }
    return r3(w);
  }

  Widget rows(String str, int j , double w){
    return InkWell(
      onTap: (){
        setState((){
          i=j;
        });
      },
      child: Column(
        children: [
          Text(str,style: TextStyle(color: i==j?Global.bg:Colors.grey),),
          SizedBox(height: 4),
          Container(width: w/3,height: 4,color:i==j?Global.bg:Colors.grey),
        ],
      ),
    );
  }

  int i = 0;

  Widget r3(double w){
    return Column(
      children: [
        Center(
          child: Container(
            width: w-20,
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("    Contact Details",style: TextStyle(fontSize: 20),),
                    ListTile(
                      onTap: () async {
                        final Uri _url = Uri.parse('tel:${widget.form.phone}');
                        if (!await launchUrl(_url)) {
                        throw Exception('Could not launch $_url');
                        }
                      },
                      leading: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(Icons.call_rounded,color: Colors.white,),
                      ),
                      title: Text("+91 "+widget.form.phone,style: TextStyle(fontWeight: FontWeight.w800),),
                      subtitle: Text("Primary Contact Number",style: TextStyle(fontWeight: FontWeight.w300),),
                    ),
                    ListTile(
                      onTap: () async {
                        final Uri _url = Uri.parse('tel:${widget.form.alternatePhone}');
                        if (!await launchUrl(_url)) {
                          throw Exception('Could not launch $_url');
                        }
                      },
                      leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.call_rounded,color: Colors.white,),
                      ),
                      title: Text("+91 "+widget.form.alternatePhone,style: TextStyle(fontWeight: FontWeight.w800),),
                      subtitle: Text("Alternate Contact Number",style: TextStyle(fontWeight: FontWeight.w300),),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),SizedBox(height: 15,),
        Center(
          child: Container(
            width: w-20,
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("    Other Details",style: TextStyle(fontSize: 20),),
                    ListTile(
                      onTap: () async {
                        final Uri _url = Uri.parse('mailto:${widget.form.email}');
                        if (!await launchUrl(_url)) {
                          throw Exception('Could not launch $_url');
                        }
                      },
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: Icon(Icons.email_rounded,color: Colors.white,),
                      ),
                      title: Text(widget.form.email,style: TextStyle(fontWeight: FontWeight.w800),),
                      subtitle: Text("Verified Email from Login",style: TextStyle(fontWeight: FontWeight.w300),),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget r2(double w){
    return Column(
      children: [
        Center(
          child: Card(
            color: Colors.white,
            child: Container(
              width: w-20,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("    Address Details",style: TextStyle(fontSize: 20),),
                    SizedBox(height: 9,),
                    add("Address 1", widget.form.address1),
                    add("Address 2", widget.form.address2),
                    add("City", widget.form.city),
                    add("LandMark", widget.form.landmark),
                    add("State", widget.form.state),
                    SizedBox(height: 10,),
                    add("Pin Code", widget.form.pincode),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10,),
        Center(
          child: Card(
            color: Colors.white,
            child: Container(
              width: w-20,
              child: ListTile(
                onTap: () async {
                  try {
                    final parts = [
                      widget.form.address1,
                      widget.form.address2,
                      widget.form.landmark,
                      widget.form.city,
                      widget.form.state,
                      widget.form.pincode,
                    ];

                    final validParts = parts
                        .where((e) => e != null && e.toString().trim().isNotEmpty)
                        .map((e) => e.toString().trim())
                        .toList();

                    if (validParts.isEmpty) {
                      Send.message(context, "Address fields are empty or invalid.", false);
                      return;
                    }

                    final address = validParts.join(', ');
                    final encodedAddress = Uri.encodeComponent(address);

                    final browserUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encodedAddress');
                    final geoUrl = Uri.parse('geo:0,0?q=$encodedAddress');

                    debugPrint("Trying to launch: $geoUrl");

                    // Try geo: URI first
                    if (await canLaunchUrl(geoUrl)) {
                      await launchUrl(geoUrl, mode: LaunchMode.externalApplication);
                    }else  {
                      print("---------->");
                      await launchUrl(browserUrl, mode: LaunchMode.externalApplication);
                    }
                  } catch (e, stack) {
                    debugPrint("Map launch error: $e\n$stack");
                    Send.message(context, "Error: $e", false);
                  }

                },
                leading: Icon(CupertinoIcons.location_fill,color: Colors.red,),
                title: Text("Open in Map",style: TextStyle(fontWeight: FontWeight.w700),),
                subtitle: Text("Open Location in Google Map"),
                trailing: Icon(Icons.open_in_new,color: Colors.red,),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget add(String str, String str2){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 4),
      child: RichText(
        text: TextSpan(
          text: str +" : ",
          style: TextStyle(color: Colors.black, fontSize: 16),
          children: <TextSpan>[
            TextSpan(
              text: str2,
              style: TextStyle(
                  color: Colors.black,fontSize: 17,fontWeight: FontWeight.w700
              ),
            ),
          ],
        ),),
    );
  }

  Widget r1(double w){
    return Column(
      children: [
        sendcard(w),
        Center(
          child: Card(
            color: Colors.white,
            child: Container(
              width: w-10,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Installation details",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 19),),
                    Text(widget.form.bio),
                  ],
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Card(
            color: Colors.white,
            child: Container(
              width: w-10,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Other details",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 19),),
                    Text(widget.form.serviceName),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
  Widget sendcard(double w){
    int i = returnint(widget.form.status);
    if(i<1){
      return SizedBox();
    }else if(i>=1&&i<=4){
      return Card(
        color: Colors.white,
          child: Container(
            width: w-20,
            child: ListTile(
              onTap: (){
                try {
                  final Event event = Event(
                    title: "${widget.form.serviceName} on ${widget.form.address1}",
                    description: '',
                    location: '${widget.form.address1}, ${widget.form.address2}, ${widget.form.landmark}, ${widget.form.pincode} ',
                    startDate: dategivenow(true),
                    endDate: dategivenow(false),
                    iosParams: IOSParams(
                      reminder: Duration(/* Ex. hours:1 */),
                      // on iOS, you can set alarm notification after your event.
                      url: 'https://www.example.com', // on iOS, you can set url to your event.
                    ),
                    androidParams: AndroidParams(
                      emailInvites: [
                        "${widget.form.email}",
                        "rajishms@gmail.com",
                        "rajeesh@iskargreenhomes.com"
                      ]
                    ),
                  );
                  Add2Calendar.addEvent2Cal(event);
                  Send.message(context, "Sucess ! ", true);
                }catch(E){
                  Send.message(context, "$E", false);
                }
              },
              leading: Image.asset("assets/Google_Calendar_icon_(2020).svg.png",width: 30,),
              title:   Text("Sheduled on ${datetime(widget.form.sheduledate)}",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 16),),
              subtitle: Text("Add to Calender by clicking here",style: TextStyle(fontSize: 10),),
              trailing: Icon(Icons.open_in_new),
            )
          )
      );
    }
    return SizedBox();
  }
  Widget sendmessage(){
    int i = returnint(widget.form.status);
    if(i<1){
      return Text("Ordered done on ${datetime(widget.form.id)} ");
    }else if(i>=1&&i<=4){
      return Text("Sheduled on ${datetime(widget.form.sheduledate)}",style: TextStyle(fontWeight: FontWeight.w900),);
    }
    return Text("Installed on ${datetime(widget.form.sheduledate)}");
  }

  DateTime dategivenow(bool now) {
    try {
      DateTime give = DateTime.parse(widget.form.sheduledate);

      // Return 8 AM or 5 PM based on `now`
      return DateTime(give.year, give.month, give.day, now ? 8 : 17);
    } catch (e) {
      DateTime fallback = DateTime.now();
      return DateTime(fallback.year, fallback.month, fallback.day, now ? 8 : 17);
    }
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
  Widget adminbox(double w,String str,Color color){
    return Container(
      width: w/2-25,
      height: 40,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5)
      ),
      child: Center(child: Text(str)),
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
                    'Update Order Status',
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

  Widget card(){
    try{
      return SvgPicture.asset(widget.form.serviceLogo,width: 50,);
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
