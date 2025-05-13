import 'package:flutter/material.dart';
import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;

class HelpAndContactPage extends StatelessWidget {
  const HelpAndContactPage(String userName, String email, String password, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.white,
      appBar: appBar(),
      body: body(),
    );
  }
}

AppBar appBar() {
  return AppBar(
    backgroundColor: colors.white.withAlpha(50),
    toolbarHeight: constants.APPBAR_HEIGHT,
    flexibleSpace: ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(color: Colors.transparent),
      ),
    ),
    elevation: 0,
    title: Image.asset('assets/logos/logo_transparent_redblack.png', width: 70),
    centerTitle: true,
  );
}

Container body() {
  return Container(
    height: double.infinity,
    alignment: Alignment.center,
    child: const Text(
      "Besoin d'aide ? Contactez-nous à tout moment.\nbenefeatefrei@gmail.com",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
