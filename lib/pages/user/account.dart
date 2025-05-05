import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:benefeat/pages/user/login_or_signup/login_or_create.dart';
import 'package:benefeat/pages/user/personal_information.dart';
import 'package:benefeat/pages/user/help_contact.dart';
import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _isLoggedIn = true;

  Future<void> _switchLoggedIn() async {
    setState(() {
      _isLoggedIn = !_isLoggedIn;
    });
  }
  
  final ImagePicker _picker = ImagePicker();
  XFile? userProfilePicture;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        userProfilePicture = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.white,
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    String userName = "Jean Dupont";
    String userEmail = "exemple@mail.com";
    String userPassword = "motdepasse";

    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: constants.APPBAR_HEIGHT + 50),
            ElevatedButton(
              onPressed: _switchLoggedIn,
              child: Icon(Icons.change_circle, color: colors.black, size: 35,)
            ),
            _isLoggedIn
                ? loggedInPage(context, userName, userEmail, userPassword)
                : loggedOutPage(context),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView loggedInPage(BuildContext context, String userName, String userEmail, String userPassword) {
    return SingleChildScrollView(
      child: Column(
        spacing: MediaQuery.of(context).size.height / 25,
        children: [
          SizedBox(height: 10),

          // Profile Picture
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: userProfilePicture != null
                      ? FileImage(File(userProfilePicture!.path))
                      : AssetImage("assets/account/user_defaultpfp.png") as ImageProvider,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colors.darkred,
                          width: 4.0,
                        ),
                      ),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: colors.darkred,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colors.white,
                            width: 2.0,
                          ),
                        ),
                      ),
                      Image.asset(
                        "assets/account/icon_edit_white.png",
                        width: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Username
          Text(
            userName,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 30),

          // Personal Info Navigator
          buttonGoToPage(context, "Informations personnelles", PersonalInformationPage(userName, userEmail, userPassword)),

          // Help and Contact
          buttonGoToPage(context, "Aide et contact", HelpAndContactPage(userName, userEmail, userPassword)),
        ],
      ),
    );
  }
}

Widget slidetransition(context, animation, secondaryAnimation, child){
  return SlideTransition(
    position: animation.drive(Tween(
      begin: Offset(1.0, 0.0), 
      end: Offset.zero
    ).chain(CurveTween(curve: Curves.easeOutQuad))),
    child: child,
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


Widget buttonGoToPage(context, String nomPage, Widget page){
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(colors.lightgrey),
      fixedSize: WidgetStatePropertyAll(
        Size(MediaQuery.of(context).size.width * 0.8, 50),
      ),
      alignment: Alignment.centerLeft,
      shadowColor: WidgetStatePropertyAll(Colors.transparent),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          nomPage,
          style: TextStyle(
            color: colors.black,
            fontWeight: FontWeight.w600
          ),
        ),
        Icon(Icons.arrow_forward_ios_rounded, size: 20, color: colors.black,)
      ],
    ),
    onPressed: () {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return slidetransition(context, animation, secondaryAnimation, child);
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    },
  );
}


SizedBox loggedOutPage(BuildContext context) {
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
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const LoginOrCreatePage()),
              );
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