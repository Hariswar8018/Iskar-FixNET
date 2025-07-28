import 'dart:typed_data' as lk ;
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../functions/flush.dart';
import '../global.dart';
import '../main.dart' show MyHomePage;
import '../main_navigations/navigation.dart';
import '../model/usermodel.dart' show UserModel;


class Step1 extends StatefulWidget {

   Step1({super.key,});

  @override
  State<Step1> createState() => _Step1State();
}

class _Step1State extends State<Step1> {

  List l5 = [];
  String drinkk = " ", smoke = " ", goall = " ", gen = " " , looki = " ", pic = " ";

  int activeStep = 0; // Initial step set to 5.
  int upperBound = 1; // upperBound MUST BE total number of icons minus 1.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          return  false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Your Details'), automaticallyImplyLeading: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  IconStepper(
                    icons: [
                      Icon(Icons.face, color : activeStep == 0 ? Colors.white : Colors.black),
                      Icon(Icons.phone_android, color : activeStep == 1 ? Colors.white : Colors.black),
                    ],
                    activeStep: activeStep,stepColor: Colors.grey.shade200, activeStepColor:Global.bg ,
                    onStepReached: (index) {
                      setState(() {
                        activeStep = index;
                      });
                    },
                  ),
                  header(),
                  s(context),
            
                ],
              ),
            ),
          ),
            persistentFooterButtons:[
          Container(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                previousButton(),
                nextButton(),
              ],
            ),
          ),
        ]
        ),
      ),
    );
  }

  Widget s(BuildContext context){
    switch (activeStep) {
      case 1:
        return r5(context);
      default:
        return r1(context);
    }
  }

  Widget nextButton() {
    return InkWell(
      onTap: ()  async {
        print(activeStep+upperBound);
        print(activeStep);
        print(upperBound);
        if (activeStep < upperBound) {
          print(activeStep+upperBound);
          setState(() {
            activeStep ++ ;
          });
        }else {
          if(name.text.isEmpty){
            Send.message(context, "Name is Mandatory", false);
          }else{
            CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');
            String h = FirebaseAuth.instance.currentUser!.uid ;
            String hu = FirebaseAuth.instance.currentUser!.email ?? "No Email Provided";
            print("No");
            try {
              UserModel u = UserModel(
                  Email: hu,
                  Name: name.text,
                  uid: h,
                  pic: pic,
                  bio: bio.text, lastLogin: '', token: '', phone: '', dob: '',
              );
              print("haan be");
              try{
                await usersCollection.doc(h).update(u.toJson());
              }catch(e){
                try{
                  await usersCollection.doc(h).set(u.toJson());
                }catch(e){
                  Send.message(context, "$e", false);
                }
              }
              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Navigation()));
              Send.message(context, "Account Created Success ! Welcome ${name.text}", true);
              print("gh");
            } catch (e) {
              Send.message(context, "${e}", false);
            }
          }


        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Container(
              width : MediaQuery.of(context).size.width - 100, height : 60,
              decoration: BoxDecoration(
                color: Global.bg , // Background color of the container
                borderRadius: BorderRadius.circular(5.0), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1), // Shadow color
                    spreadRadius: 5, // Spread radius
                    blurRadius: 7, // Blur radius
                    offset: Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              child : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(activeStep < upperBound?"Continue  ":"Submit   ", style : TextStyle( color : Colors.white)),
                  Icon(Icons.arrow_forward,  color : Colors.white),
                ],
              ),
          ),
        ),
      ),
    );
  }

  TextEditingController phone = TextEditingController();
  TextEditingController bio = TextEditingController();

  TextEditingController adhaar = TextEditingController();
  Widget r5(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          t1("Your Phone Number"),
          SizedBox(height : 7),
          t2("This will Private and only Orders notification will be issued"),
          SizedBox(height : 18),
          sd1(phone, context, 10),
          SizedBox(height : 10),
          t1("Your Bio"),
          SizedBox(height : 7),
          t2("Your Short Bio"),
          SizedBox(height : 18),
          sd(bio, context),
        ],
      ),
    );
  }
  /// Returns the previous button.
  Widget previousButton() {
    return InkWell(
      onTap: () {
        // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
        if (activeStep > 0) {
          setState(() {
            activeStep--;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Global.bg ,
            child: Icon(Icons.arrow_back, color : Colors.white),
          ),
        ),
      ),
    );
  }

  /// Returns the header wrapping the header text.
  Widget header() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        headerText(),
        style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.w200,
          fontSize: 20,
        ),
      ),
    );
  }

  // Returns the header text based on the activeStep.
  String headerText() {
    switch (activeStep) {
      case 1:
        return 'Address Details';

      default:
        return 'Personal Information';
    }
  }

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }

  bool up = false ;
  void a (){
    setState((){
      up = !up ;
    });
  }
  Widget r1(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          t1("Your Picture & Name"),
          SizedBox(height : 7),
          up ? Center(
              child : CircularProgressIndicator()
          ) : InkWell(
            onTap: () async {
              a();
              try {
                lk.Uint8List? file = await pickImage(ImageSource.gallery);
                if (file != null) {
                  String photoUrl = "";
                  setState(() {
                    pic = photoUrl;
                  });
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Profile Pic Uploaded"),
                  ),
                );
              }catch(e){
                print(e);
              }
              a();
            },
            child: pic == " "? Center(
              child: Container(
                  height:  170, width:  140,
                  decoration: BoxDecoration(
                      color : Colors.grey.shade300,
                    shape: BoxShape.circle
                  ),

                  child : Icon(Icons.camera_alt)
              ),
            ) : Center(
              child: Container(
                height:  170, width:  140,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(pic),
                      fit: BoxFit.cover,
                    )
                ),
              ),
            ),
          ),
          t2("Your Real/Business Name"),
          SizedBox(height : 18),
          sd(name, context),

        ],
      ),
    );
  }

  bool teac = false ;

  Widget rt(String jh){
    return InkWell(
        onTap : (){
          if(l5.contains(jh)){
            setState(() {
              l5.remove(jh);
            });
            print(l5);
          }else{
            setState(() {
              l5 = l5 + [jh];
            });
            print(l5);
          }
        }, child : Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
            color: l5.contains(jh) ? Color(0xff6A9D40) : Colors.grey.shade100, // Background color of the container
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          child : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(jh, style : TextStyle(fontSize: 19, color : l5.contains(jh) ? Colors.white : Colors.black )),
          )
      ),
    )
    );
  }


  Widget rtn(String jh, int i ){
    if ( i == 0 ){
      return InkWell(
          onTap : (){
            setState(() {
              smoke = jh ;
            });
          }, child : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
              color: smoke == jh ? Color(0xff6A9D40) : Colors.grey.shade100, // Background color of the container
              borderRadius: BorderRadius.circular(15.0), // Rounded corners
            ),
            child : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(jh, style : TextStyle(fontSize: 19, color : smoke == jh ? Colors.white : Colors.black )),
            )
        ),
      )
      );
    }else if ( i == 1 ){
      return InkWell(
          onTap : (){
            setState(() {
              drinkk = jh ;
            });
          }, child : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
              color: drinkk == jh ? Color(0xff6A9D40) : Colors.grey.shade100, // Background color of the container
              borderRadius: BorderRadius.circular(15.0), // Rounded corners
            ),
            child : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(jh, style : TextStyle(fontSize: 19, color : drinkk == jh ? Colors.white : Colors.black )),
            )
        ),
      )
      );
    }else if ( i == 2){
      return InkWell(
          onTap : (){
            setState(() {
              goall = jh ;
            });
          }, child : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
              color: goall == jh ? Color(0xff6A9D40) : Colors.grey.shade100, // Background color of the container
              borderRadius: BorderRadius.circular(15.0), // Rounded corners
            ),
            child : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(jh, style : TextStyle(fontSize: 19, color : goall == jh ? Colors.white : Colors.black )),
            )
        ),
      )
      );
    }else if ( i == 3 ){
      return InkWell(
          onTap : (){
            setState(() {
              gen = jh ;
            });
          }, child : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
              color: gen == jh ? Color(0xff6A9D40) : Colors.grey.shade100, // Background color of the container
              borderRadius: BorderRadius.circular(15.0), // Rounded corners
            ),
            child : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(jh, style : TextStyle(fontSize: 19, color : gen == jh ? Colors.white : Colors.black )),
            )
        ),
      )
      );
    }else{
      return InkWell(
          onTap : (){
            setState(() {
              looki = jh ;
            });
          }, child : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
              color: looki == jh ? Color(0xff6A9D40) : Colors.grey.shade100, // Background color of the container
              borderRadius: BorderRadius.circular(15.0), // Rounded corners
            ),
            child : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(jh, style : TextStyle(fontSize: 19, color : looki == jh ? Colors.white : Colors.black )),
            )
        ),
      )
      );
    }

  }
  TextEditingController name = TextEditingController();
  TextEditingController bday = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController inte = TextEditingController();
  TextEditingController goal = TextEditingController();
  TextEditingController height = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController hobbies = TextEditingController();
  TextEditingController drink = TextEditingController();
  TextEditingController smooking = TextEditingController();
  TextEditingController education = TextEditingController();
  TextEditingController work = TextEditingController();

  Widget t1(String g){
    return Text(g, style : TextStyle(fontSize: 27, fontWeight: FontWeight.w700));
  }
  Widget t2(String g){
    return Text(g, style : TextStyle(fontSize: 18, fontWeight: FontWeight.w300));
  }
  String _getValueText(
      CalendarDatePicker2Type datePickerType,
      List<DateTime?> values,
      ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
          .map((v) => v.toString().replaceAll('00:00:00.000', ''))
          .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }
  Widget sd (TextEditingController cg,  BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width : MediaQuery.of(context).size.width  , height : 50,
        decoration: BoxDecoration(
          color: Colors.blue.shade50, // Background color of the container
          borderRadius: BorderRadius.circular(15.0), // Rounded corners
        ),
        child: Padding(
            padding: const EdgeInsets.only( left :10, right : 18.0, top : 5, bottom: 5),
            child: Center(
              child: TextFormField(
                controller: cg,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none, // No border
                  counterText: '',

                ),
              ),
            )
        ),
      ),
    );
  }
  Widget sd1 (TextEditingController cg,  BuildContext context, int yu){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width : MediaQuery.of(context).size.width  , height : 50,
        decoration: BoxDecoration(
          color: Colors.blue.shade50, // Background color of the container
          borderRadius: BorderRadius.circular(15.0), // Rounded corners
        ),
        child: Padding(
            padding: const EdgeInsets.only( left :10, right : 18.0, top : 5, bottom: 5),
            child: Center(
              child: TextFormField(
                controller: cg, maxLength: yu,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none, // No border
                  counterText: '',

                ),
              ),
            )
        ),
      ),
    );
  }
}