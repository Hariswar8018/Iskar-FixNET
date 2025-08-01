import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iskar/global.dart';
import 'package:iskar/main.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';
import 'package:url_launcher/url_launcher.dart';

import '../functions/flush.dart';
import '../model/usermodel.dart';
import 'info.dart';

class OtpLoginScreen extends StatefulWidget {

  OtpLoginScreen({super.key});

  @override
  State<OtpLoginScreen> createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool on=false;
  void _verifyOtp(BuildContext context) async {
    setState(() {
      go = true;
    });
    String otp = _otpController.text.trim();
    if (otp.isEmpty || otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter a valid 6-digit OTP")),
      );
      setState(() {
        go = false;
      });
      Send.message(context, "Enter a valid 6-digit OTP", false);
      return;
    }
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      String uid = userCredential.user!.uid;
      checkonce(uid);
    } catch (e) {
      setState(() {
        go = false;
      });
      Send.message(context, "$e", false);
    }
  }
  Future<void> checkonce(String uid) async {
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');
      QuerySnapshot querySnapshot = await usersCollection.where('uid', isEqualTo: uid).get();
      if (querySnapshot.docs.isNotEmpty) {
        UserModel user = UserModel.fromSnap(querySnapshot.docs.first);
        if(user.Name.isEmpty){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>Step1(phone: _email.text,)));
        }else{
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>MyApp()));
        }
        Send.message(context, "Login Success !",true);
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>Step1(phone: _email.text,)));
        Send.message(context, "Welcome, We will need some additional details for Account to Set Up", true);
      }

  }
  String verificationId = "";

  late Timer _timer;

  int _secondsRemaining = 60;

  bool _canResend = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _canResend = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        _timer.cancel();
      }
    });
  }
  void _resendOtp() {
    setState(() {
      go=true;
    });
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91"+_email.text,
      verificationCompleted: (PhoneAuthCredential credential) {
        setState(() {
          go=false;
        });

        // Handle auto-verification if needed
      },
      verificationFailed: (FirebaseAuthException e) {
        Send.message(context, e.message ?? "Verification failed", false);
        setState(() {
          go=false;
        });
      },
      codeSent: (String verificationIds, int? resendToken) {
        setState(() {
          verificationId = verificationIds;
        });
        setState(() {
          go=false;
        });
        Send.message(context, "OTP resent successfully", true);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle timeout
        setState(() {
          go=false;
        });
      },
    );
    _startTimer();
  }
  bool isChecked=false;

  OtpFieldControllerV2 otpController = OtpFieldControllerV2();
  TextEditingController _email=TextEditingController();
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      body:Stack(
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
                      width : MediaQuery.of(context).size.width  , height : 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100, // Background color of the container
                        borderRadius: BorderRadius.circular(15.0), // Rounded corners
                      ),
                      child: Center(
                        child: Padding(
                            padding: const EdgeInsets.only( left :10, right : 18.0),
                            child: TextFormField(
                              controller: _email,
                              keyboardType: TextInputType.phone,
                              readOnly: verificationId.isNotEmpty,
                              maxLength: 10,
                              decoration: InputDecoration(
                                labelText:"Your Phone Number",
                                prefixText: " +91 ",
                                isDense: true,
                                counterText: '',
                                border: InputBorder.none, // No border
                              ),
                            )
                        ),
                      ),
                    ),
                  ),
                  verificationId.isEmpty?SizedBox():OTPTextFieldV2(
                    controller: otpController,
                    length: 6,
                    width: MediaQuery.of(context).size.width,
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldWidth: w/8,
                    fieldStyle: FieldStyle.box,
                    outlineBorderRadius: 15,
                    style: TextStyle(fontSize: 18),
                    onChanged: (pin) {
                      print("Changed: " + pin);
                      _otpController.text=pin;
                    },
                    onCompleted: (pin) {
                      print("Completed: " + pin);
                      _otpController.text=pin;
                    },
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  verificationId.isEmpty?Padding(
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
                        InkWell(
                          onTap:() async {
                            final Uri _url = Uri.parse('https://www.brnrinnovations.com/app-privacy-policy');
                            if (!await launchUrl(_url)) {
                              throw Exception('Could not launch $_url');
                            }
                          },
                          child: Container(
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
                        ),

                      ],
                    ),
                  ):
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 19.0),
                    child: Row(
                      children: [
                        Text(
                          _canResend
                              ? "Didn't receive the OTP?"
                              : "Resend OTP in $_secondsRemaining seconds",
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15),
                        ),
                        if (_canResend)
                          TextButton(
                            onPressed: _resendOtp,
                            child: const Text("Resend OTP"),
                          ),
                      ],
                    ),
                  ),
                  go?CircularProgressIndicator(
                    backgroundColor: Global.bg,
                  ):InkWell(
                      onTap: () async {
                        if(verificationId.isNotEmpty){
                          _verifyOtp(context);
                          return;
                        }
                        if(!isChecked){
                          Send.message(context,"Please Accept Terms & Condition", false);
                          return ;
                        }
                        if(_email.text.length!=10){
                          Send.message(context,"Number should be 10 digits", false);
                          return ;
                        }
                        _resendOtp();
                      },
                      child :Global.button(context,verificationId.isEmpty?"Send OTP Now":"Verify OTP",verificationId.isEmpty?Icon(Icons.code):Icon(Icons.verified_user_outlined))),

                  Padding(
                    padding: const EdgeInsets.only(left : 15.0, right : 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children : [
                          TextButton(
                              child : Text("Login with Email", style : TextStyle(color : Global.bg)), onPressed : (){
                                Navigator.pop(context);

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
    );
  }

  bool go = false;
}