import 'package:flutter/material.dart';

import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;
import 'package:benefeat/constants/user_info.dart' as userinfo;

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController streetNameController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController cityNameController = TextEditingController();

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
      body: body(
        context, 
        
        usernameController, 
        emailController, 
        passwordController, 
        confirmPasswordController, 

        streetNameController,
        zipCodeController,
        cityNameController,
      
        passwordsConfirmationMessage, 
        passwordsDoNotMatch
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
  );
}

Widget body(
  BuildContext context,

  TextEditingController usernameController,
  TextEditingController emailController,
  TextEditingController passwordController,
  TextEditingController confirmPasswordController,

  TextEditingController streetNameController,
  TextEditingController zipCodeController,
  TextEditingController cityNameController,

  String passwordsConfirmationMessage,
  Function(String) onPasswordChange,
) {
  return Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          SizedBox(height: constants.APPBAR_HEIGHT,),

          Image.asset("assets/logos/logo_transparent_redblack.png", width: 100),
          Text(
            "Création de compte",
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w600,
              color: colors.black,
            ),
          ),

          const SizedBox(height: 5,),

          TextField(
            controller: usernameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: "Nom d'utilisateur".toUpperCase(),
              labelStyle: TextStyle(
                fontSize: 14,
              ),
              isDense: true,
            ),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),

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
            textInputAction: TextInputAction.next,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Mot de passe".toUpperCase(),
              labelStyle: TextStyle(
                fontSize: 14,
              ),
              isDense: true,
            ),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            onChanged: (event) => displayIfValidPassword(passwordController.text, confirmPasswordController.text, onPasswordChange),
          ),

          TextField(
            controller: confirmPasswordController,
            textInputAction: TextInputAction.next,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Confirmer le mot de passe".toUpperCase(),
              labelStyle: TextStyle(
                fontSize: 14,
              ),
              isDense: true,
            ),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            onChanged: (event) => displayIfValidPassword(passwordController.text, confirmPasswordController.text, onPasswordChange),
          ),

          Row(
            children: [
              passwordsConfirmationMessage == ""
                ? confirmPasswordController.text.isEmpty
                  ? SizedBox()
                  : Row(
                      children: [
                        SizedBox(width: 10,),
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

          TextField(
            controller: streetNameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: "Numéro et nom de rue".toUpperCase(),
              labelStyle: TextStyle(
                fontSize: 14,
              ),
              isDense: true,
            ),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),

          TextField(
            controller: zipCodeController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: "Code postal".toUpperCase(),
              labelStyle: TextStyle(
                fontSize: 14,
              ),
              isDense: true,
            ),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),

          TextField(
            controller: cityNameController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: "Ville".toUpperCase(),
              labelStyle: TextStyle(
                fontSize: 14,
              ),
              isDense: true,
            ),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),

          const SizedBox(height: 25,),

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

              onPressed: () async {
                if (isValidTextFields(
                  context, 
                  passwordsConfirmationMessage, 
                  usernameController.text, 
                  emailController.text, 
                  passwordController.text, 
                  confirmPasswordController.text,
                  streetNameController.text,
                  zipCodeController.text,
                  cityNameController.text
                  )) {
                  final adress = "${streetNameController.text}, ${zipCodeController.text} ${cityNameController.text}";
                  final successfulAccountCreation = await userinfo.addUser(usernameController.text, emailController.text, passwordController.text, adress);
                  if (!context.mounted) return;

                  /* 
                  Returns:
                    O: write error
                    1: success
                    2: user already exists
                  */

                  String message;
                  Color bgcolor = colors.red;
                  switch (successfulAccountCreation) {
                    case 0:
                      message = "Une erreur d'écriture s'est produite\nVeuillez réessayer ultérieurement";
                      break;
                    case 1:
                      message = "Compte créé avec succès !";
                      bgcolor = colors.darkgreen;
                      break;
                    case 2:
                      message = "Un autre utilisateur possède déja ce nom d'utilisateur";
                      break;
                    default:
                      message = "Erreur";
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: bgcolor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    ),
                  );

                  if (successfulAccountCreation == 1) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                }
              },
            ),
          ),

          SizedBox(height: 15,),
        ],
      ),
    ),
  );
}



bool isValidTextFields(BuildContext context, String passwordsConfirmationMessage, String username, String email, String password, String confirmPassword, String streetName, String zipCode, String cityName) {
  String text;
  if (username.isEmpty) {
    text = "Le nom d'utilisateur est requis.";
  } else if (email.isEmpty) {
    text = "L'email est requis.";
  } else if (!isValidEmailFormat(email)) {
    text = "L'email doit etre de la forme exemple@mail.com";
  } else if (passwordsConfirmationMessage == "" && confirmPassword.isEmpty) {
    text = "Le mot de passe est requis.";
  } else if (password != confirmPassword) {
    text = "Les mots de passe ne sont pas les mêmes.";
  } else if (streetName.isEmpty) {
    text = "Le numéro et le nom de rue sont requis";
  } else if (zipCode.isEmpty) {
    text = "Le code postal est requis";
  } else if (!RegExp(r'^\d{5}$').hasMatch(zipCode)) {
    text = "Le code postal doit contenir 5 chiffres";
  } else if (cityName.isEmpty) {
    text = "La ville est requise";
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
  final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z]+\.[a-zA-Z]+$');
  return emailRegex.hasMatch(email);
}



void displayIfValidPassword(String password, String confirmPassword, Function onPasswordChange) {
  if (password != confirmPassword) {
    onPasswordChange("Les mots de passe ne sont pas les mêmes");
  } else {
    onPasswordChange("");
  }
}