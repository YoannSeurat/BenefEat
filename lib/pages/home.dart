import 'package:flutter/material.dart';
import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.white,
      body: body(),
    );
  }
}

Container body() {
  //// ignore: avoid_unnecessary_containers
  return Container(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 20,
        children: [
          SizedBox(height: constants.APPBAR_HEIGHT + 100,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Benef", style: TextStyle(color: colors.black, fontSize: 30, fontWeight: FontWeight.w600)),
              Text("Eat", style: TextStyle(color: colors.red, fontSize: 30, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    ),
  );
}