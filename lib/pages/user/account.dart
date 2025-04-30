import 'package:flutter/material.dart';

import 'package:benefeat/pages/user/login.dart';
import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.white,
      body: body(context),
    );
  }
}


Container body(BuildContext context) {
  return Container(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: constants.APPBAR_HEIGHT + 100,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15,
            children: [
              Image.asset('assets/appbar/userprofile_black.png', width: 30,),
              Text(
                "Ton Compte",
                style: TextStyle(
                    color: colors.black,
                    fontSize:30,
                    fontWeight: FontWeight.w600
                ),
              ),
            ],
          ),
          // TODO en backend : faire en sorte de detecter si logged in ou pas
          isNotLoggedIn(context)
        ],
      ),
    ),
  );
}

void logout(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
      title: const Text('Confirmation'),
      content: const Text('Es tu sûr de vouloir te déconnecter ?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Annuler'),
        ),
        TextButton(
        onPressed: () {
          // TODO en backend : logout le pelo
          Navigator.of(context).pop(); 
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Tu as bien été déconnecté',),
                actions: [
                  TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        },
        child: const Text('Se déconnecter'),
        ),
      ],
      );
    },
  );
}

SizedBox isNotLoggedIn(BuildContext context) {
  return SizedBox(
    height: MediaQuery.of(context).size.height - constants.APPBAR_HEIGHT - 250,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.max, 
        mainAxisAlignment: MainAxisAlignment.center, 
        crossAxisAlignment: CrossAxisAlignment.center, 
        spacing: 50,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, 
                spacing: 10,
                children: [
                  Icon(Icons.warning_amber_rounded, color: colors.red,),
                  Text(
                    "Tu n'es pas connecté(e)", 
                    style: TextStyle(
                      color: colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.warning_amber_rounded, color: colors.red,),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(colors.red),
              foregroundColor: WidgetStatePropertyAll(colors.white),
              padding: WidgetStatePropertyAll(
                const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Row(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.login,),
                Text(
                  "Connexion",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    )
  );
}