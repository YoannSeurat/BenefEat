import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:benefeat/pages/user/login_or_signup/login_or_create.dart';
import 'package:benefeat/pages/user/personal_information.dart';
import 'package:benefeat/pages/user/help_contact.dart';
import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;
import 'package:benefeat/constants/user_info.dart' as userinfo;

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _isLoggedIn = false;
  String userName = '';
  String userEmail = '';
  String userPassword = '';
  String userAdress = '';

  Future<void> _setLoggedIn(bool value) async {
    setState(() {
      _isLoggedIn = value;
    });
  }
  
  final ImagePicker _picker = ImagePicker();
  XFile? userProfilePicture;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    if (image != null) {
      setState(() {
        userProfilePicture = image;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final isLoggedIn = await userinfo.getConnectedUser() != -1;
    final name = await userinfo.getSpecificUserInfo("username");
    final email = await userinfo.getSpecificUserInfo("email");
    final password = await userinfo.getSpecificUserInfo("password");
    final adress = await userinfo.getSpecificUserInfo("adress");

    setState(() {
      _isLoggedIn = isLoggedIn;
      userName = name;
      userEmail = email;
      userPassword = password;
      userAdress = adress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.white,
      body: body(context, userName),
    );
  }

  Widget body(BuildContext context, String userName) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: constants.APPBAR_HEIGHT + 50),
            _isLoggedIn
                ? loggedInPage(context, userName, _setLoggedIn, _loadUserInfo)
                : loggedOutPage(context, _setLoggedIn),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView loggedInPage(BuildContext context, String userName, Function setLoggedIn, Function loadUserInfo) {
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

          SizedBox(height: 10),

          // Personal Info Navigator
          buttonGoToPage(context, "Informations personnelles", PersonalInformationPage(), loadUserInfo),

          // Help and Contact
          buttonGoToPage(context, "Aide et contact", HelpAndContactPage(), loadUserInfo),

          SizedBox(),
          
          // Log out
          ElevatedButton(
            style: ButtonStyle(
              fixedSize: WidgetStatePropertyAll(
                Size(MediaQuery.of(context).size.width * 0.5, 40)
              ),
              backgroundColor: WidgetStatePropertyAll(colors.white),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: colors.darkred,
                    width: 3
                  )
                ),
              ),
              padding: WidgetStatePropertyAll(
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Icon(Icons.logout, color: colors.darkred,),
                Text(
                  "Se déconnecter",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            onPressed: () async {
              await logout(context, setLoggedIn);
            }, 
          ),
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


Future<void> logout(BuildContext context, setLoggedIn) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirmation'),
      content: const Text('Es tu sûr(e) de vouloir te déconnecter ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Se déconnecter'),
        ),
      ],
    ),
  );
  if (confirm == true) {
    await userinfo.disconnectUser();
    await setLoggedIn(false);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tu as bien été déconnecté(e)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}


Widget buttonGoToPage(context, String nomPage, Widget page, Function loadUserInfo){
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
    onPressed: () async {
      await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return slidetransition(context, animation, secondaryAnimation, child);
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      ).then( (_) async {
        final userInfo = await userinfo.getUserInfo();
        print(userInfo);
        loadUserInfo();
      });
    },
  );
}


SizedBox loggedOutPage(BuildContext context, Function setLoggedIn) {
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
            ),
            onPressed: () async {
              await Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const LoginOrCreatePage()),
              ).then( (_) async {
                final userInfo = await userinfo.getUserInfo();
                print(userInfo);
                final connectedIndex = await userinfo.getConnectedUser();
                if (connectedIndex != -1) {
                  await setLoggedIn(true);
                }
              });
            },
          ),
        ],
      ),
    )
  );
}