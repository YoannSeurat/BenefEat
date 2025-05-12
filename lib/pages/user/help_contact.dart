import 'package:flutter/material.dart';
import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;

class HelpAndContactPage extends StatelessWidget {
  const HelpAndContactPage(String userName, String email, String password, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.white,
      appBar: AppBar(
        backgroundColor: colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Revenir à la page précédente
          },
        ),
      ),
      body: body(),
    );
  }
}

Container body() {
  return Container(
    height: double.infinity,
    alignment: Alignment.center,
    child: const Text(
      "Besoin d'aide ? Contactez-nous à tout moment.\nbenefeat@gmail.com",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
