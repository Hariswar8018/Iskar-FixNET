import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../functions/email_verifu.dart';
import '../service/service_card.dart';

class Service {
  final String name;
  final String assetLink;

  Service({required this.name, required this.assetLink});
}


class ServiceCard{
  static Widget card(double w, Service service,BuildContext context){
     return InkWell(
       onTap: (){
         if(FirebaseAuth.instance.currentUser!.emailVerified){
           Navigator.push(
             context,
             MaterialPageRoute( builder: (context) =>  FillForm(service: service,),
             ),
           );
         }else{
           Navigator.push(
             context,
             MaterialPageRoute( builder: (context) =>  EmailVerifu(),
             ),
           );
         }
       },
       child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width:w/5,height: w/5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(service.assetLink),
                )),
            SizedBox(height: 6,),
            Container(width:w/5+10, child: Text(textAlign: TextAlign.center, service.name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)),
          ],
        ),
           ),
     );
  }
  static Widget cards(double w, Service service,BuildContext context){
    return InkWell(
      onTap: (){

          Navigator.push(
            context,
            MaterialPageRoute( builder: (context) =>  FillForm(service: service,),
            ),
          );


      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width:w/5,height: w/5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(service.assetLink),
                )),
            SizedBox(height: 6,),
            Container(width:w/5+10, child: Text(textAlign: TextAlign.center, service.name,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 11),)),
          ],
        ),
      ),
    );
  }
}
final List<Service> services = [
  Service(name: 'Total House Renovation', assetLink: 'assets/house-svgrepo-com.svg'),
  Service(name: 'Annual Maintenance', assetLink: 'assets/house-big-svgrepo-com.svg'),
  Service(name: 'Civil Construction', assetLink: 'assets/construction-crane-lifter-svgrepo-com.svg'),
  Service(name: 'Painting & Carpentry', assetLink: 'assets/brush-paint-red-svgrepo-com.svg'),
  Service(name: 'Electrical & Plumbing Works', assetLink: 'assets/plumbing-pipe-svgrepo-com.svg'),
  Service(name: 'AC Maintenance', assetLink: 'assets/ac-svgrepo-com.svg'),
  Service(name: 'Interior & Modular Kitchen Works', assetLink: 'assets/kitchen-ecommerce-shop-svgrepo-com.svg'),
  Service(name: 'Pest Control', assetLink: 'assets/rat-svgrepo-com.svg'),
  Service(name: 'Land Survey, Plans & Estimation', assetLink: 'assets/lake-land-nature-svgrepo-com.svg'),
  Service(name: 'False Ceiling Works', assetLink: 'assets/ceiling-lamp-2-svgrepo-com.svg'),
  Service(name: 'Landscaping & Interlocking', assetLink: 'assets/landscape-mountain-svgrepo-com.svg'),
  Service(name: 'Annual & Periodic Maintenances', assetLink: 'assets/spring-icon-svgrepo-com.svg'),
  Service(name: 'Deep Cleaning', assetLink: 'assets/sweep-the-floor-svgrepo-com.svg'),
  Service(name: 'Roofing', assetLink: 'assets/roof-svgrepo-com.svg'),
  Service(name: 'Third-Party Supervision of Construction', assetLink: 'assets/construction-crane-lifter-svgrepo-com.svg'),
];


