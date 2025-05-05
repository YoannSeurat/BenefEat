import 'package:flutter/material.dart';

import 'package:benefeat/pages/user/login_or_signup/login.dart';
import 'package:benefeat/pages/user/login_or_signup/signup.dart';
import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;

class LoginOrCreatePage extends StatelessWidget {
  const LoginOrCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      appBar: appBar(),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              "assets/backgrounds/loginpage_background.png",
              fit: BoxFit.cover,
            ),
          ),
          // Foreground
          SafeArea(
            child: body(context),
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

Container body(BuildContext context) {
  return Container(
    padding: EdgeInsets.only(bottom: 50),
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
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return slidetransition(context, animation, secondaryAnimation, child);
                  },
                  transitionDuration: const Duration(milliseconds: 400),
                ),
              );
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
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => SignUpPage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return slidetransition(context, animation, secondaryAnimation, child);
                  },
                  transitionDuration: const Duration(milliseconds: 500),
                ),
              );
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

Widget slidetransition(context, animation, secondaryAnimation, child){
  return SlideTransition(
    position: animation.drive(Tween(
      begin: Offset(0.0, 1.0), 
      end: Offset.zero
    ).chain(CurveTween(curve: Curves.easeOutQuad))),
    child: child,
  );
}