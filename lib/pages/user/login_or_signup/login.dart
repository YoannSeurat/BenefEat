import 'package:flutter/material.dart';

import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: colors.white,
      appBar: appBar(),
      body: body(context, emailController, passwordController),
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
  );
}

Widget body(BuildContext context, TextEditingController emailController, TextEditingController passwordController,) {
  return Center(
    child: SingleChildScrollView( // Wrap the content in a scrollable widget
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 35,
        children: [
          Image.asset("assets/logos/logo_transparent_redblack.png", width: 100),
          Text(
            "Connexion",
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w600,
              color: colors.black,
            ),
          ),

          const SizedBox(height: 5,),

          TextField(
            controller: emailController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: "Email".toUpperCase(),
              labelStyle: TextStyle(
                fontSize: 14,
              ),
              isDense: true,
            ),
            keyboardType: TextInputType.emailAddress,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),

          TextField(
            controller: passwordController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: "Mot de passe".toUpperCase(),
              labelStyle: TextStyle(
                fontSize: 14,
              ),
              isDense: true,
            ),
            obscureText: true,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),

          const SizedBox(height: 30,),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ButtonStyle(
                fixedSize: WidgetStatePropertyAll(const Size.fromHeight(55)),
                backgroundColor: WidgetStatePropertyAll(colors.red),
                foregroundColor: WidgetStatePropertyAll(colors.white),
                shadowColor: WidgetStatePropertyAll(Colors.transparent),
                side: WidgetStatePropertyAll(
                  BorderSide(color: colors.red, width: 3),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              onPressed: () {
                if (isValidTextFields(context, emailController.text, passwordController.text)) {
                  bool successfulAccountCreation = true; // a implementer quand le backend marchera

                  // TODO: Add backend logic
                  
                  if (successfulAccountCreation) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Connexion réussie !"),
                        backgroundColor: colors.darkgreen,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      ),
                    );
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Désolé, un problème est survenu lors de la connexion à votre compte. \nVeuillez réessayer ultérieurement"),
                        backgroundColor: colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  }
                }
              },
              child: const Text(
                "Me connecter",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}


bool isValidTextFields(BuildContext context, String email, String password) {
  String text;
  if (email.isEmpty) {
    text = "L'email est requis.";
  } else if (!isValidEmailFormat(email)) {
    text = "L'email doit etre de la forme exemple@mail.com";
  } else if (password.isEmpty) {
    text = "Le mot de passe est requis.";
  } else {
    return true;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: colors.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ),
  );
  return false;
}


bool isValidEmailFormat(String email) {
  final emailRegex = RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z]+\.[a-zA-Z]+$');
  return emailRegex.hasMatch(email);
}