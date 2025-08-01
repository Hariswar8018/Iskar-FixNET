import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../global.dart';
import '../model/service.dart';

class ListShow extends StatelessWidget {
  final List<Service> list;

  const ListShow({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        backgroundColor: Global.bg,
        title: Text(
          "Selected Service (${list.length})",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final service = list[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 3),
            child: ListTile(
              leading: SvgPicture.asset(service.assetLink,width: 50,),
              title: Text(service.name ?? 'No Name'),
            ),
          );
        },
      ),
    );
  }
}
