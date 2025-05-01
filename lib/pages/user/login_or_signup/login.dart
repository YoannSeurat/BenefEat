import 'package:flutter/material.dart';

import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: colors.white,
      appBar: appBar(),
      body: body(context),
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

Widget body(BuildContext context) {
  return Center(
    child: SingleChildScrollView( // Wrap the content in a scrollable widget
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 30,
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

          const SizedBox(height: 10,),

          TextField(
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),

          TextField(
            decoration: InputDecoration(
              labelText: "Mot de passe",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            obscureText: true,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),

          const SizedBox(height: 10,),

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
                // TODO backend
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