import 'package:flutter/material.dart';
import 'package:iskar/global.dart';

import '../model/service.dart';

class Applications extends StatefulWidget {
  String search;bool shows;

   Applications({super.key, this.search="",this.shows=false});

  @override
  State<Applications> createState() => _ApplicationsState();
}

class _ApplicationsState extends State<Applications> {
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

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Global.background,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        automaticallyImplyLeading: widget.shows,
        backgroundColor: Global.bg,
        title: Text("All Services",style: TextStyle(color: Colors.white),),
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
                        child: ServiceCard.cards(w, service,context),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      )


    );
  }
}

