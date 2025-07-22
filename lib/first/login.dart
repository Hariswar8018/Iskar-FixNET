import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'package:shared_preferences/shared_preferences.dart';

import '../functions/flush.dart';
import '../global.dart';
import '../main.dart';
import '../main_navigations/navigation.dart';
import '../model/usermodel.dart';
import 'forgot.dart';
import 'info.dart';




class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final TextEditingController _ref = TextEditingController();
  final TextEditingController _con = TextEditingController();
  String s = "Demo";
  String d = "Demo";

  @override
  void dispose() {
    _emailController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  bool isChecked = false;  // This boolean value is toggled by the Checkbox
  bool on = true;
    String var1 = " ";
    bool go = false ;
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        // Show the alert dialog and wait for a result
        bool exit = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Exit App'),
              content: Text('Are you sure you want to exit?'),
              actions: [
                ElevatedButton(
                  child: Text('No'),
                  onPressed: () {
                    // Return false to prevent the app from exiting
                    Navigator.of(context).pop(false);
                  },
                ),
                ElevatedButton(
                  child: Text('Yes'),
                  onPressed: () {
                    // Return true to allow the app to exit
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );

        // Return the result to handle the back button press
        return exit ?? false;
      },
      child: Scaffold(

        backgroundColor: Colors.white,
        body: on ? Stack(
          children: [
            Image.network("https://img.freepik.com/free-vector/smart-home-background-with-smarthphone-control_23-2147846450.jpg",width: w,height: 360,fit: BoxFit.cover,),
            Padding(
              padding: const EdgeInsets.only(top:330),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
                ),
                width: w,height: h-240,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Center(
                      child: Text("All that you need for your Home Application",textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    ),
                    SizedBox(height: 10,),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width : MediaQuery.of(context).size.width  , height : 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100, // Background color of the container
                          borderRadius: BorderRadius.circular(15.0), // Rounded corners
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only( left :10, right : 18.0),
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                isDense: true,
                                border: InputBorder.none, // No border
                              ),
                            )
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width : MediaQuery.of(context).size.width  , height : 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100, // Background color of the container
                          borderRadius: BorderRadius.circular(15.0), // Rounded corners
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only( left :10, right : 18.0),
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                isDense: true,
                                border: InputBorder.none, // No border
                              ),
                            )
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left : 20.0, right : 20),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value ?? false;
                              });
                            },
                          ),
                          Container(
                            width: w-100,
                            child: RichText(
                              text: TextSpan(
                                text: "By continuing, You agree to our ",
                                style: TextStyle(color: Colors.black, fontSize: 13),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Terms & Condition',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,fontSize: 13
                                    ),
                                  ),TextSpan(
                                    text: ' our ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13
                                    ),
                                  ),TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,fontSize: 13
                                    ),
                                  ),
                                ],
                              ),),
                          ),
                        ],
                      ),
                    ),
                    go?CircularProgressIndicator(
                      backgroundColor: Global.bg,
                    ):InkWell(
                        onTap: () async {
                          if(!isChecked){
                            Send.message(context,"Please Accept Terms & Condition", false);
                            return ;
                          }
                          setState(() {
                            go=true;
                          });
                          try {
                            final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _confirmPasswordController.text,
                            );
                            String sn = credential.user!.uid ;
                            checkonce(sn);
                            setState(() {
                              go=false;
                            });
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              go=false;
                            });
                            if (e.code == 'user-not-found') {
                              Send.message(context, "No User found for this Email", false);
                              print('No user found for that email.');
                            } else if (e.code == 'wrong-password') {
                              print('Wrong password provided for that user.');
                              Send.message(context, "Wrong password provided for that user", false);
                            } else {
                              Send.message(context, "$e", false);
                            }

                          }
                        },
                        child :Global.button(context,"Login Now",Icon(Icons.login))),
                    Padding(
                      padding: const EdgeInsets.only(left : 15.0, right : 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children : [
                          TextButton(
                            child : Text("SignUp", style : TextStyle(color : Global.bg)), onPressed : (){
                              setState((){
                                on = !on ;
                              });
                          }
                          ),

                          TextButton(
                              child : Text("Forgot Password ?", style : TextStyle(color : Global.bg)), onPressed : (){
                            Navigator.push(
                              context,
                              MaterialPageRoute( builder: (context) =>  ForgotP(),
                              ),
                            );
                          }
                          ),
                        ]
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ) :
        Stack(
          children: [
            Image.network("https://img.freepik.com/free-vector/smart-home-background-with-smarthphone-control_23-2147846450.jpg",width: w,height: 360,fit: BoxFit.cover,),
            Padding(
              padding: const EdgeInsets.only(top:330),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                ),
                width: w,height: h-240,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Center(
                      child: Text("All that you need for your Home Application",textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width : MediaQuery.of(context).size.width  , height : 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100, // Background color of the container
                          borderRadius: BorderRadius.circular(15.0), // Rounded corners
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only( left :10, right : 18.0),
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'New Email',
                                isDense: true,
                                border: InputBorder.none, // No border
                              ),
                            )
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width : MediaQuery.of(context).size.width  , height : 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100, // Background color of the container
                          borderRadius: BorderRadius.circular(15.0), // Rounded corners
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only( left :10, right : 18.0),
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                isDense: true,
                                border: InputBorder.none, // No border
                              ),
                            )
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left : 20.0, right : 20),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value ?? false;
                              });
                            },
                          ),
                          Container(
                            width: w-100,
                            child: RichText(
                              text: TextSpan(
                                text: "By continuing, You agree to our ",
                                style: TextStyle(color: Colors.black, fontSize: 13),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Terms & Condition',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,fontSize: 13
                                    ),
                                  ),TextSpan(
                                    text: ' our ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13
                                    ),
                                  ),TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,fontSize: 13
                                    ),
                                  ),
                                ],
                              ),),
                          ),
                        ],
                      ),
                    ),
                    go?CircularProgressIndicator(
                      backgroundColor: Global.bg,
                    ):InkWell(
                        onTap: () async {
                          if(!isChecked){
                            Send.message(context,"Please Accept Terms & Condition", false);
                            return ;
                          }
                          setState(() {
                            go=true;
                          });
                          try {
                            final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _confirmPasswordController.text,
                            );
                            String sn = credential.user!.uid ;
                            checkonce(sn);
                            setState(() {
                              go=false;
                            });
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              go=false;
                            });
                            if (e.code == 'user-not-found') {
                              Send.message(context, "No User found for this Email", false);
                              print('No user found for that email.');
                            } else if (e.code == 'wrong-password') {
                              print('Wrong password provided for that user.');
                              Send.message(context, "Wrong password provided for that user", false);
                            } else {
                              Send.message(context, "$e", false);
                            }
                          }
                        },
                        child :Global.button(context,"SignUp Now",Icon(Icons.logout_outlined))),
                    Padding(
                      padding: const EdgeInsets.only(left : 15.0, right : 15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children : [
                            TextButton(
                                child : Text("Not New ? Login", style : TextStyle(color : Global.bg)), onPressed : (){
                              setState((){
                                on = !on ;
                              });
                            }
                            ),

                            SizedBox()
                          ]
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> checkonce(String uid) async {
    String df=_emailController.text;
    if(df=="brnrinnovation@gmail.com"||df=="admin@signxhrm.com"){

    }else{
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');
      QuerySnapshot querySnapshot = await usersCollection.where('uid', isEqualTo: uid).get();
      if (querySnapshot.docs.isNotEmpty) {
        UserModel user = UserModel.fromSnap(querySnapshot.docs.first);
        if(user.Name.isEmpty){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Step1(strr: user.type,source: user.source)));

        }else{
          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Navigation()));


        }
        Send.message(context, "Login Success !",true);
      } else {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Step1(strr: strin,)));
        Send.message(context, "Welcome, We will need some additional details for Account to Set Up", true);
      }
    }

  }
  String strin = "Individual";
  Widget fg(double w,int i,String st){
    return InkWell(
      onTap: (){
        setState(() {
          strin=st;
        });
      },
      child: Card(
        color: st==strin?Colors.blue:Colors.white,
        child: Container(
          width: w/3-10,
          height: w/3-10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              sd(i,st==strin),
              SizedBox(height: 5,),
              Text(st,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: st==strin?Colors.white:Colors.black),)
            ],
          ),
        ),
      ),
    );
  }
  Widget sd(int i,bool yes){
    if(i==0){
      return Icon(Icons.accessibility_new,color:yes?Colors.white:Colors.black,size: 20,);
    }else if(i==1){
      return Icon(Icons.work,color:yes?Colors.white:Colors.black,size: 20,);
    }else if(i==2){
      return Icon(Icons.factory,color:yes?Colors.white:Colors.black,size: 20,);
    }else {
      return Icon(Icons.security,color:yes?Colors.white:Colors.black,size: 20,);
    }
  }


}
