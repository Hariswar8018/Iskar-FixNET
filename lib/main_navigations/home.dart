import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iskar/global.dart';

import '../model/service.dart';

class Home extends StatelessWidget {
   Home({super.key});
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white12,
      key: _key, // Assign the key to Scaffold.
      drawer: Global.buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
          height: 380,width: w,
          color: Global.bg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height:35,),
              Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Global.bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,  // Removes the default border
                      prefixIcon: InkWell(
                          onTap: (){
                            _key.currentState!.openDrawer();
                          },
                          child: Icon(Icons.menu, color: Colors.white)),
                      hintText: 'Search for your need',hintStyle: TextStyle(color: Colors.white)
                    ),
                  ),
                ),
              ),
                  ),
              SizedBox(height:12,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text("Trending Services",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),
              ),
              SizedBox(height: 15,),
              Container(
                width: w,height: w/3,
                child: ListView.builder(
                  itemCount: 4,scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return ServiceCard.card(w, service,context);
                  },
                ),
              ),
              SizedBox(height: 15,),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13.0,vertical: 8),
                    child: Text("Show All",style: TextStyle(color: Colors.white),),
                  ),
                ),
              )
            ],
          ),
        ),
            Container(
              width: w,
              height: 60,
              child: Stack(
                children: [
                  Container(
                    width: w,
                    height: 60,
                    color: Global.bg,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                      width: w,height: 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)
                          )
                      ),
                    ),
                  )
        
                ],
              ),
            ),
            Card(
              color: Colors.white,
              child: Container(
                width: w-20,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Book in 3 Easy Step",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 18),),
                      Text("Add your Application to get Fast Delivery",style: TextStyle(fontWeight: FontWeight.w500),),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                                child: SvgPicture.asset("assets/cart-plus-svgrepo-com.svg"),
                              ),
                             a("Add"),
                              a("Applications")
                            ],
                          ),
                          Icon(Icons.arrow_forward_outlined,color: Colors.blue,),
                          Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                                child: SvgPicture.asset("assets/form-svgrepo-com.svg"),
                              ),
                              a("Shedule Date"),
                              a("& Time ")
                            ],
                          ),
                          Icon(Icons.arrow_forward_outlined,color: Colors.blue,),
                          Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                                child: SvgPicture.asset("assets/delivery-svgrepo-com.svg"),
                              ),
                              a("Book"),
                              a("Service")
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text("Featured Services",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
            ),
            SizedBox(height: 60,)
            ],
        ),
      ),
    );
  }
  Widget a(String str)=> Text(str,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),);
}
