import 'package:flutter/material.dart';
import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;

class HelpAndContactPage extends StatelessWidget {
  const HelpAndContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.white,
      body: body(),
    );
  }
}

Container body() {
  return Container(
    child: SingleChildScrollView(
      child: Column(
        children: [
          
        ],
      ),
    ),
  );
}