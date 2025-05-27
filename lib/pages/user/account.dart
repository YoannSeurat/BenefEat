import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:benefeat/pages/user/login_or_signup/login_or_create.dart';
import 'package:benefeat/pages/user/personal_information.dart';
import 'package:benefeat/pages/user/help_contact.dart';
import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;
import 'package:benefeat/constants/user_info.dart' as userinfo;

class AccountPage extends StatefulWidget {
  final VoidCallback? onUserChanged;
  const AccountPage({super.key, this.onUserChanged});

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
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
    if (image != null) {
      final savedPath = await saveProfilePicture(image, userName);
      setState(() {
        userProfilePicture = XFile(savedPath); // Update UI immediately
      });
      await _loadUserInfo();
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

    // Directly check for the PFP file
    final directory = await getApplicationDocumentsDirectory();
    final pfpPath = '${directory.path}/user_profile_picture_$name.png';

    setState(() {
      _isLoggedIn = isLoggedIn;
      userName = name;
      userEmail = email;
      userPassword = password;
      userAdress = adress;
      userProfilePicture = File(pfpPath).existsSync() ? XFile(pfpPath) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.white,
      body: body(context, userName),
    );
  }


  Future<String> saveProfilePicture(XFile image, String userId) async {
    final directory = await getApplicationDocumentsDirectory();
    final String fileName = 'user_profile_picture_$userId.png'; // Consistent extension
    final String fullPath = '${directory.path}/$fileName';
    final File newImage = await File(image.path).copy(fullPath);
    return newImage.path;
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
                : loggedOutPage(context, _setLoggedIn, _loadUserInfo),
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
                        border: Border.all(color: colors.darkred, width: 4.0),
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
          buttonGoToPage(context, "Informations personnelles", PersonalInformationPage(), loadUserInfo, widget.onUserChanged),

          // Help and Contact
          buttonGoToPage(context, "Aide et contact", HelpAndContactPage(), loadUserInfo, widget.onUserChanged),

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
              printAllProfilePictures();
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
      content: const Text('Êtes vous sûr(e) de vouloir vous déconnecter ?'),
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
        title: const Text('Vous avez bien été déconnecté(e)'),
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


Widget buttonGoToPage(
  context,
  String nomPage,
  Widget page,
  Function loadUserInfo,
  [VoidCallback? onUserChanged]
) {
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
      ).then((_) async {
        loadUserInfo();
        if (onUserChanged != null) {
          onUserChanged();
        }
      });
    },
  );
}


SizedBox loggedOutPage(BuildContext context, Function setLoggedIn, Function loadUserInfo) {
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
                    "Vous n'êtes pas connecté(e)", 
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
              padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
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
                Icon(Icons.login, color: colors.white,),
                Text(
                  "Page de connexion",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: colors.white,
                  ),
                ),
              ],
            ),
            onPressed: () async {
              await Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const LoginOrCreatePage()),
              ).then( (_) async {
                final connectedIndex = await userinfo.getConnectedUser();
                if (connectedIndex != -1) {
                  await setLoggedIn(true);
                }
                await loadUserInfo();
              });
            }
          ),
        ],
      ),
    )
  );
}

void printAllProfilePictures() async {
  final directory = await getApplicationDocumentsDirectory();
  final files = directory.listSync();
  for (var file in files) {
    print('File in app directory: ${file.path}');
  }
}