import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iskar/global.dart';
import 'package:iskar/model/service.dart';

import '../model/fill_form.dart';


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

  void saveForm() {
    FillFormModel model = FillFormModel(
      name: nameController.text,
      id: idController.text,
      email: emailController.text,
      phone: phoneController.text,
      address1: address1Controller.text,
      address2: address2Controller.text,
      pincode: pincodeController.text,
      landmark: landmarkController.text,
      city: cityController.text,
      state: stateController.text,
      serviceName: serviceNameController.text,
      serviceLogo: serviceLogoController.text,
      alternatePhone: alternatePhoneController.text,
      bio: bioController.text,
      doc: docController.text,
      paid: paid,
    );

    print('Saved Form Data: ${model.toJson()}');

    // You can also save this to Firestore:
    // FirebaseFirestore.instance.collection('fillForms').add.toJson());(model
  }

  void initState(){
    emailController.text=FirebaseAuth.instance.currentUser!.email ??"har@g.com";
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
        padding: const EdgeInsets.all(8),
        child: Container(width: w,
          child: Column(
            children: [
              Container(
                width: w,
                height: 90,
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListTile(
                      leading: SvgPicture.asset(widget.service.assetLink,width: 50,),
                      title: Text(widget.service.name,style: TextStyle(fontWeight: FontWeight.w800),),
                      subtitle: Text("Service Selected "),
                    ),
                  ),
                ),
              ),
              textField('Name', nameController),
              Row(
                children: [
                  Container(width:w*4/5, child: textField2('Email', emailController)),
                  Spacer(),
                  FirebaseAuth.instance.currentUser!.emailVerified?Icon(Icons.verified,color: Colors.green,):Icon(Icons.cancel,color: Colors.red,)
                ,SizedBox(width: 15,)],
              ),
              textField('Phone', phoneController),
              textField('Address 1', address1Controller),
              textField('Address 2', address2Controller),
              textField('Pincode', pincodeController),
              textField('Landmark', landmarkController),
              textField('City', cityController),
              textField('State', stateController),
              textField('Service Name', serviceNameController),
              textField('Service Logo', serviceLogoController),
              textField('Alternate Phone', alternatePhoneController),
              textField('Bio', bioController),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        InkWell(
            onTap: (){
              saveForm();
            },
            child: Global.button(context, "Apply for Service", Icon(Icons.save,color: Colors.white,)))
      ],
    );
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

  Widget textField2(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        readOnly: true,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
