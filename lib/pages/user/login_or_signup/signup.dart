import 'package:flutter/material.dart';

import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String passwordsConfirmationMessage = "";

  passwordsDoNotMatch(String message) {
    setState(() {
      passwordsConfirmationMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: colors.white,
      appBar: appBar(),
      body: body(context, usernameController, emailController, passwordController, confirmPasswordController, passwordsConfirmationMessage, passwordsDoNotMatch),
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

Widget body(
  BuildContext context,
  TextEditingController usernameController,
  TextEditingController emailController,
  TextEditingController passwordController,
  TextEditingController confirmPasswordController,
  String passwordsConfirmationMessage,
  Function(String) onPasswordChange,
) {
  return Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Image.asset("assets/logos/logo_transparent_redblack.png", width: 100),
          Text(
            "Création de compte",
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w600,
              color: colors.black,
            ),
          ),

          const SizedBox(height: 10,),

          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: "Nom d'utilisateur",
              border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              ),
            ),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),

          TextField(
            controller: emailController,
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
            controller: passwordController,
            decoration: InputDecoration(
              labelText: "Mot de passe",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            obscureText: true,
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
              if (confirmPasswordController.text.isNotEmpty && passwordController.text != confirmPasswordController.text) {
                onPasswordChange("Les mots de passe ne sont pas les mêmes");
              } else {
                onPasswordChange("");
              }
            } 
          ),

          TextField(
            controller: confirmPasswordController,
            decoration: InputDecoration(
              labelText: "Confirmer le mot de passe",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            obscureText: true,
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
              if (passwordController.text != confirmPasswordController.text) {
                onPasswordChange("Les mots de passe ne sont pas les mêmes");
              } else {
                onPasswordChange("");
              }
            } 
          ),

          Row(
            children: [
              passwordsConfirmationMessage == ""
              ? confirmPasswordController.text.isEmpty
                ? SizedBox()
                : Row(
                    children: [
                      SizedBox(width: 20,),
                      Icon(
                        Icons.check_circle_outline, 
                        color: colors.green,
                      )
                    ],
                  )
              : Icon(
                  Icons.warning_amber_rounded, 
                  color: colors.red,
                ),

              Expanded(
                child: Text(
                  passwordsConfirmationMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.w600
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 10,),

          Align(
            alignment: Alignment.topRight,
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
              child: const Text(
                "Créer mon compte",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              onPressed: () {
                if (usernameController.text.isEmpty || emailController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        usernameController.text.isEmpty
                          ? "Le nom d'utilisateur est requis."
                          : "L'email est requis.",
                      ),
                      backgroundColor: colors.red,
                    ),
                  );
                } else if (passwordsConfirmationMessage == "" && confirmPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Le mot de passe est requis."),
                      backgroundColor: colors.red,
                    ),
                  );
                } else if (passwordController.text != confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Les mots de passe ne sont pas les mêmes."),
                      backgroundColor: colors.red,
                    ),
                  );
                } else {
                  // TODO: Add backend logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Compte créé avec succès !"),
                      backgroundColor: colors.green,
                    ),
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
            ),
          )
        ],
      ),
    ),
  );
}