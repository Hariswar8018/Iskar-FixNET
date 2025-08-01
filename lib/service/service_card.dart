import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:im_stepper/stepper.dart';
import 'package:iskar/functions/flush.dart';
import 'package:iskar/global.dart';
import 'package:iskar/model/service.dart';
import 'package:iskar/notification/notify_all.dart';
import 'package:iskar/service/list_show.dart';
import 'package:iskar/service/return_service.dart';

import '../model/fill_form.dart';
import 'package:location_manager_flutter/location_manager.dart';

import '../providers/declare.dart';

class FillForm extends StatefulWidget {

  FillForm({super.key,required this.service});

  Service service;

  @override
  State<FillForm> createState() => _FillFormState();
}

class _FillFormState extends State<FillForm> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController idController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController address1Controller = TextEditingController();

  final TextEditingController address2Controller = TextEditingController();

  final TextEditingController pincodeController = TextEditingController();

  final TextEditingController landmarkController = TextEditingController();

  final TextEditingController cityController = TextEditingController();

  final TextEditingController stateController = TextEditingController();

  final TextEditingController serviceNameController = TextEditingController();

  final TextEditingController serviceLogoController = TextEditingController();

  final TextEditingController alternatePhoneController = TextEditingController();

  final TextEditingController bioController = TextEditingController();

  final TextEditingController docController = TextEditingController();

  bool paid = false;
  int activeStep = 0; // Initial step set to 5.

  int upperBound = 3; // upperBound MUST BE total number of icons minus 1.

  getuser(){
    final user = AppSession.currentUser;
    customerpic=user!.pic;
    customername=user.Name;

    emailreadonly=!(user.byphone);
    phoneController.text=user.phone;
  }

  String customerpic = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",customername="";
  void saveForm() async{
    try {
      if(address1Controller.text.isEmpty){
        Send.message(context,"Address is Required",false);
        return ;
      }
      print(phoneController.text.length);
      if(phoneController.text.length!=10){
        Send.message(context,"Phone is Required and should be 10 digit",false);
        return ;
      }
      if(pincodeController.text.isEmpty){
        Send.message(context,"Pin Code is Required",false);
        return ;
      }
      setState(() {
        on = true;
      });
      String id = DateTime.now().toString();
      FillFormModel model = FillFormModel(
        name: nameController.text,
        id:id,
        email: emailController.text,
        phone: phoneController.text,
        address1: address1Controller.text,
        address2: address2Controller.text,
        pincode: pincodeController.text,
        landmark: landmarkController.text,
        city: cityController.text,
        state: stateController.text,
        serviceName: widget.service.name,
        serviceLogo: widget.service.assetLink,
        alternatePhone: alternatePhoneController.text,
        bio: bioController.text,
        doc: docController.text,
        paid: paid, customerId: FirebaseAuth.instance.currentUser!.uid,
        customerName: customername, customerPic: customerpic, status: 'Pending', sheduledate: '', added: added,
      );
      await FirebaseFirestore.instance.collection("services").doc(id).set(model.toJson());
      await NotifyAll.sendNotificationsAdmin("New Service applied by ${customername} ", "$customername applied for New Serivce Now ! Click to view");
      setState(() {
        on=true;
      });
      Navigator.pop(context);
      Send.message(context, "Service Applied", true);
      print('Saved Form Data: ${model.toJson()}');
    }catch(e){
      setState(() {
        on=false;
      });
      Send.message(context, "$e", false);

    }
    // You can also save this to Firestore:
    // FirebaseFirestore.instance.collection('fillForms').add.toJson());(model
  }
  bool emailreadonly=true;
  List<Service> added =[];
  void initState(){
    emailController.text=FirebaseAuth.instance.currentUser!.email ??"";
    getuser();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Global.bg,
          iconTheme: IconThemeData(color: Colors.white),
          title: const Text('Fill Form',style: TextStyle(color: Colors.white),)),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                IconStepper(
                  icons: [
                    Icon(Icons.details, color : activeStep == 0 ? Colors.white : Colors.black),
                    Icon(Icons.add_location_alt, color : activeStep == 1 ? Colors.white : Colors.black),
                    Icon(Icons.call, color : activeStep == 2 ? Colors.white : Colors.black),
                    Icon(Icons.verified, color : activeStep == 3 ? Colors.white : Colors.black),
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
    );
  }
  Widget s(BuildContext context){
    switch (activeStep) {
      case 1:
        return r2(context);
      case 2:
        return r3(context);
      case 3:
        return r4(context);
      default:
        return r1(context);
    }
  }
  Widget r1(BuildContext context){
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          width: w,
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListTile(
                leading: SvgPicture.asset(widget.service.assetLink,width: 50,),
                title: Text(widget.service.name,style: TextStyle(fontWeight: FontWeight.w800),),
                subtitle: Text("Service Selected from Services"),
              ),
            ),
          ),
        ),
        Container(
          width: w,
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListTile(
                onTap: () async {
                  List<Service> ser = await Navigator.push(
                    context,
                    MaterialPageRoute( builder: (context) =>  ReturnService(),
                    ),
                  );
                  if(ser.isNotEmpty){
                    added=ser;
                    setState(() {

                    });
                  }
                },
                leading:added.isNotEmpty?Icon(Icons.shopping_cart,) :Icon(Icons.add,color: Colors.red,),
                title: Text(added.isNotEmpty?"Added ${added.length} extra Service":"Add More Service",style: TextStyle(fontWeight: FontWeight.w800),),
                subtitle: Text(added.isNotEmpty?"You have Selected ${added.length} extra Service along with this Order":"Do 2 or more service at the same time"),
              ),
            ),
          ),
        ),
        textField4('Details of Ordered Services', serviceNameController),
        textField4('Any Additional Info you want to Submit ?', bioController),
      ],
    );
  }
  Widget r2(BuildContext context){
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Column(
      children: [
        ListTile(
          onTap: getlocation,
          tileColor: Colors.white,
          leading:  Icon(CupertinoIcons.location_fill),
          title:Text("Fetch your Location",style:TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Text("Click here to Fetch"),
          trailing:on?CircularProgressIndicator(): Icon(Icons.refresh,color: Colors.blue,),
        ),
        textField('Address 1', address1Controller),
        textField('Address 2', address2Controller),
        textField('Pincode', pincodeController),
        textField('Landmark', landmarkController),
        textField('City', cityController),
        Row(
          children: [
            Container(
                width: w/2-20,
                child: textField('State', stateController)),
            SizedBox(width: 9,),
            InkWell(
              onTap: (){
                showStatePicker();
              },
              child: Container(
                  width: w/2-20,
                  child: Center(
                    child: Container(
                      width : MediaQuery.of(context).size.width/2 - 20, height : 60,
                      decoration: BoxDecoration(
                        color: Global.bg , // Background color of the container
                        borderRadius: BorderRadius.circular(4.0), // Rounded corners
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
                          Text('Select State', style : TextStyle( color : Colors.white,fontWeight: FontWeight.w900)),
                          SizedBox(width: 10,),
                          Icon(Icons.waving_hand_rounded,color: Colors.white,),
                        ],
                      ),
                    ),
                  ),),
            ),
          ],
        ),
      ],
    );
  }
  void showStatePicker() async {
    String? result = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: indianStates.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(indianStates[index]),
              onTap: () {
                Navigator.pop(context, indianStates[index]);
              },
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedState = result;
        stateController.text=result;
      });
    }
  }

  bool on = false;
  Future<void> getlocation() async {
    try {
      setState(() {
        on = true;
      });
      LocationManager locationManager = LocationManager();
      AddressComponent? address = await locationManager.getAddressFromGPS();
      if (address != null) {
        print("Address: ${address.address1}, ${address.city}, ${address
            .country}");
        print(address);
        address1Controller.text=address.address1;
        cityController.text=address.city;
        stateController.text=address.state;
        address2Controller.text=address.address2;
        pincodeController.text=address.postalCode;
      }
      setState(() {
        on = false;
      });
    }catch(e){
      setState(() {
        on = false;
      });
    }
  }
  Widget r3(BuildContext context){
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Column(
      children: [
        textField('Name', nameController),
        Row(
          children: [
            Container(width:w*4/5, child: textField2('Email', emailController,emailreadonly,false)),
            Spacer(),
            emailreadonly?Icon(Icons.verified,color: Colors.green,):Icon(Icons.cancel,color: Colors.red,)
            ,SizedBox(width: 15,)],
        ),
        Row(
          children: [
            Container(width:w*4/5, child:   textField2('Phone', phoneController,!emailreadonly,true),),
            Spacer(),
            !emailreadonly?Icon(Icons.verified,color: Colors.green,):Icon(Icons.cancel,color: Colors.red,)
            ,SizedBox(width: 15,)],
        ),

        textFieldnum('Alternate Phone', alternatePhoneController),
      ],
    );
  }
  Widget r4(BuildContext context){
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            color: Colors.white,
            child: Container(
              width: w-20,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Service Details",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                    ListTile(
                      leading: SvgPicture.asset(widget.service.assetLink,width: 50,),
                      title: Text(widget.service.name,style: TextStyle(fontWeight: FontWeight.w800),),
                      subtitle: Text("Service Selected from Services"),
                    ),
                    added.isEmpty?SizedBox():ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>ListShow(list: added)));
                      },
                      leading: Icon(Icons.shopping_cart),
                      trailing: Icon(Icons.arrow_forward_rounded),
                      title: Text("Added ${added.length} Extra Services",style: TextStyle(fontWeight: FontWeight.w800),),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            color: Colors.white,
            child: Container(
              width: w-20,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Installation Details",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                    ListTile(
                      leading: Icon(CupertinoIcons.location_fill,color: Colors.red,),
                      title: Text(address1Controller.text,style: TextStyle(fontWeight: FontWeight.w800),),
                      subtitle: Text(pincodeController.text+ ", "+cityController.text),
                      trailing: Text(stateuppercode(stateController.text),style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17),),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            color: Colors.white,
            child: Container(
              width: w-20,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("My Details",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                    ListTile(
                      leading:CircleAvatar(
                        backgroundImage: NetworkImage(customerpic),
                      ),
                      title: Text(customername,style: TextStyle(fontWeight: FontWeight.w800),),
                      subtitle: Text(emailController.text),
                     ),
                    ListTile(
                      leading:CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.call,color: Colors.white,),
                      ),
                      title: Text("+91 "+phoneController.text,style: TextStyle(fontWeight: FontWeight.w800),),
                      subtitle: Text("Alternate Phone no : "+alternatePhoneController.text),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  String stateuppercode(String s){
    if(s.length<2){
      return "NA";
    }
    return s.substring(0,2).toUpperCase();
  }



  Widget textField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
  Widget textField4(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: 100,minLines: 4,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
  Widget textFieldnum(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        keyboardType: TextInputType.phone,
        controller: controller,maxLength: 10,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
  Widget textField2(String label, TextEditingController controller,bool readonly,bool num) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        readOnly: readonly,
        controller: controller,
        maxLength: num?10:50,
        keyboardType:num?TextInputType.number: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
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
        }else{
          saveForm();
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
        return 'Address of Installation';
      case 2:
        return 'Method of Contacts';
      case 3:
        return 'Confirmation Screen';

      default:
        return 'Service Information';
    }
  }
  String? selectedState;

  List<String> indianStates = [
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chhattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal",
    "Andaman and Nicobar Islands",
    "Chandigarh",
    "Dadra and Nagar Haveli and Daman and Diu",
    "Delhi",
    "Jammu and Kashmir",
    "Ladakh",
    "Lakshadweep",
    "Puducherry"
  ];
}
