import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      appBar: appBar(),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              "assets/backgrounds/loginpage_background.png",
              fit: BoxFit.cover, // Ensures the image covers the entire screen
            ),
          ),
          // Foreground
          SafeArea(
            child: body(),
          ),
        ],
      ),
    );
  }
}

AppBar appBar() {
  return AppBar(
    backgroundColor: colors.white.withAlpha(0),
    toolbarHeight: constants.APPBAR_HEIGHT,
    flexibleSpace: ClipRRect(
      child: Container(
        color: Colors.transparent,
      ),
    ),
    elevation: 0,
    title: Image.asset(
      'assets/logos/logo_transparent_redblack.png',
      width: 70,
    ),
    centerTitle: true,
  );
}

Container body() {
  return Container(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 50,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Pour pouvoir accéder à l'application,",
                style: TextStyle(
                  fontSize: 16,
                  color: colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "tu dois ",
                    style: TextStyle(
                      fontSize: 16,
                      color: colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "te connecter ",
                    style: TextStyle(
                      fontSize: 16,
                      color: colors.darkred,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "à ton compte.",
                    style: TextStyle(
                      fontSize: 16,
                      color: colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            style: ButtonStyle(
              fixedSize: WidgetStatePropertyAll(Size(250, 55)),
              backgroundColor: WidgetStatePropertyAll(colors.white),
              foregroundColor: WidgetStatePropertyAll(colors.red),
              shadowColor: WidgetStatePropertyAll(Colors.transparent),
              side: WidgetStatePropertyAll(
                BorderSide(color: colors.red, width: 3),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            onPressed: () {
              // go to log in
            }, 
            child: Text(
              "Se connecter",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: 200,
            child: Row(
              spacing: 10,
              children: [
                Expanded(
                  child: Divider(
                    color: colors.grey, 
                    thickness: 1, 
                  ),
                ),
                Text("ou"),
                Expanded(
                  child: Divider(
                    color: colors.grey, 
                    thickness: 1, 
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              fixedSize: WidgetStatePropertyAll(Size(250, 55)),
              backgroundColor: WidgetStatePropertyAll(colors.red),
              foregroundColor: WidgetStatePropertyAll(colors.white),
              shadowColor: WidgetStatePropertyAll(Colors.transparent),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            onPressed: () {
              // go to sign up
            }, 
            child: Text(
              "Créer un compte",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}