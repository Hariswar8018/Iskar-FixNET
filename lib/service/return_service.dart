import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iskar/global.dart';

import '../model/service.dart';

class ReturnService extends StatefulWidget {
  String search;bool shows;

  ReturnService({super.key, this.search="",this.shows=false});

  @override
  State<ReturnService> createState() => _ReturnServiceState();
}

class _ReturnServiceState extends State<ReturnService> {
  TextEditingController searchController = TextEditingController();
  List<Service> filteredServices = [];

  void initState(){
    super.initState();
    searchController.text="";
    filteredServices = services;  // Initially show all

    if(widget.search.isNotEmpty){
      searchController.text=widget.search;
      filteredServices = services
          .where((service) =>
          service.name.toLowerCase().contains(widget.search.toLowerCase()))
          .toList();
    }
    setState(() {

    });
  }

  List<Service> ser= [];

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Global.background,
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          automaticallyImplyLeading: true,
          backgroundColor: Global.bg,
          title: Text("Add More Service",style: TextStyle(color: Colors.white),),
        ),
        body:Column(
          children: [
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search Services',fillColor: Colors.white,filled: true,                     // Enable filling the background
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (query) {
                  setState(() {
                    filteredServices = services
                        .where((service) =>
                        service.name.toLowerCase().contains(query.toLowerCase()))
                        .toList();
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: w,
              height: 500,
              child: ListView.builder(
                itemCount: (filteredServices.length / 4).ceil(),
                itemBuilder: (context, rowIndex) {
                  final start = rowIndex * 4;
                  final end = (start + 4 < filteredServices.length) ? start + 4 : filteredServices.length;
                  final rowItems = filteredServices.sublist(start, end);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: rowItems.map((service) {
                        return Expanded(
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                if(ser.contains(service)){
                                  ser.remove(service);
                                }else{
                                  ser.add(service);
                                }
                              });
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
                                          color: ser.contains(service)?Colors.blue.shade200:Colors.white,
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child:ser.contains(service)?Icon(Icons.verified): SvgPicture.asset(service.assetLink),
                                      )),
                                  SizedBox(height: 6,),
                                  Container(width:w/5+10, child: Text(textAlign: TextAlign.center, service.name,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 11),)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      persistentFooterButtons: [
        InkWell(
            onTap: (){
              Navigator.pop(context,ser);
            },
            child: Global.button(context, "Select ${ser.length} Service", Icon(Icons.add)))
      ],
    );
  }
}

