import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;
import 'package:benefeat/constants/user_info.dart' as userinfo;

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key});

  @override
  State<PersonalInformationPage> createState() => _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  String userName = '';
  String userEmail = '';
  String userPassword = '';
  String userAdress = '';
  
  Map<String, bool> isEditing = {
    "Nom d'utilisateur": false,
    "Email": false,
    "Mot de passe": false,
    "Adresse": false,
  };

  final Map<String, TextEditingController> controllers = {
    "Nom d'utilisateur": TextEditingController(),
    "Email": TextEditingController(),
    "Mot de passe": TextEditingController(),
    "Adresse": TextEditingController(),
  };

  void startEditing(String label) {
    setState(() {
      isEditing[label] = true;
    });
  }

  Future<void> stopEditing(String label, String newValue) async {
    setState(() {
      isEditing[label] = false;
    });

    // if user didnt edit anything
    final oldValue = await userinfo.getSpecificUserInfo(label);
    if (oldValue == newValue) {
      return;
    }

    final successfulModif = await userinfo.modifySpecificUserInfo(label, newValue);
    if (successfulModif == 2) { // username or email already exists
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Un autre utilisateur possède déja cela"),
          backgroundColor: colors.darkred,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      );
    }
    await _loadUserInfo();
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final name = await userinfo.getSpecificUserInfo("username");
    final email = await userinfo.getSpecificUserInfo("email");
    final password = await userinfo.getSpecificUserInfo("password");
    final adress = await userinfo.getSpecificUserInfo("adress");

    setState(() {
      userName = name;
      userEmail = email;
      userPassword = password;
      userAdress = adress;
      controllers["Nom d'utilisateur"]!.text = name;
      controllers["Email"]!.text = email;
      controllers["Mot de passe"]!.text = password;
      controllers["Adresse"]!.text = adress;
    });
  }

  @override
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: colors.white,
      appBar: appBar(context, userName, userEmail, userPassword, userAdress),
      body: body(context, userName, userEmail, userPassword, userAdress, isEditing, startEditing, stopEditing, controllers),
    );
  }
}

AppBar appBar(BuildContext context, String userName, String userEmail, String userPassword, String userAdress) {
  return AppBar(
    backgroundColor: colors.white.withAlpha(50),
    toolbarHeight: constants.APPBAR_HEIGHT,
    flexibleSpace: ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(color: Colors.transparent),
      ),
    ),
    elevation: 0,
    title: Image.asset('assets/logos/logo_transparent_redblack.png', width: 70),
    centerTitle: true,
  );
}

Container body(
  BuildContext context,
  String userName,
  String userEmail,
  String userPassword,
  String userAdress,
  Map isEditing,
  Function startEditing,
  Function stopEditing,
  Map controllers
) {
  return Container(
    child: SingleChildScrollView(
      child: Center(
        child: Column(
          spacing: MediaQuery.of(context).size.height / 23,
          children: [
            SizedBox(height: 20,),

            Text(
              "Informations personnelles",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 20),

            containerToModifyInfo(context, "Nom d'utilisateur", userName, isEditing, startEditing, stopEditing, controllers),

            containerToModifyInfo(context, "Email", userEmail, isEditing, startEditing, stopEditing, controllers),

            containerToModifyInfo(context, "Mot de passe", userPassword, isEditing, startEditing, stopEditing, controllers),

            containerToModifyInfo(context, "Adresse", userAdress, isEditing, startEditing, stopEditing, controllers),

            SizedBox(),

            // delete my data
            ElevatedButton(
            style: ButtonStyle(
              fixedSize: WidgetStatePropertyAll(
                Size(MediaQuery.of(context).size.width * 0.7, 40)
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
                Icon(Icons.delete_outlined, color: colors.darkred,),
                Text(
                  "Supprimer mes données",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            onPressed: () async {
              deleteData(context, userName);
            }, 
          ),
          ],
        ),
      ),
    ),
  );
}

Future<void> deleteData(BuildContext context, String userName) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirmation'),
      content: const Text('Êtes vous sûr(e) de vouloir supprimer vos données ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Supprimer'),
        ),
      ],
    ),
  );
  if (confirm == true) {
    await userinfo.removeUser(userName);
    if (!context.mounted) return;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vos donées ont bien été supprimées'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (!context.mounted) return;
    Navigator.pop(context);
  }
}

Widget containerToModifyInfo(BuildContext context, String label, String labelinfo, Map isEditing, Function startEditing, Function stopEditing, Map controllers) {
  return GestureDetector(
    child: Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: colors.lightgrey,
        borderRadius: BorderRadius.all(Radius.circular(30))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              spacing: 20,
              children: [
                Text(
                  "$label :",
                  style: TextStyle(
                    fontWeight: FontWeight.w600
                  ),
                ),
                isEditing[label]
                  ? Expanded(
                    child: TextField(
                      autofocus: true,
                      controller: controllers[label],
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      onSubmitted: (newValue) async {
                        final newlabel = convertLabel(label);
                        await stopEditing(newlabel, newValue);
                      },
                      onTapOutside: (event) async {
                        final newValue = controllers[label]?.text ?? '';
                        final newlabel = convertLabel(label);
                        await stopEditing(newlabel, newValue);
                        FocusScope.of(context).unfocus();
                      }
                    ),
                  )
                  : label == "Mot de passe" 
                    ? Row(
                      children: List.generate(7, (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Icon(
                          Icons.circle,
                          size: 8,
                          color: colors.black.withAlpha(90),
                        ),
                      ),),
                    )
                    : Expanded(
                        child: Text(
                          labelinfo,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
              ],
            ),
          ),
          Image.asset("assets/account/icon_edit_black.png", width: 20,)
        ],
      ),
    ),
    onTap: () {
      startEditing(label);
    },
  );
}


String convertLabel(String label) {
  switch (label) {
    case "Nom d'utilisateur":
      return "username";
    case "Email":
      return "email";
    case "Mot de passe":
      return "password";
    case "Adresse":
      return "adress";
    default:
      return "ERROR";
  }
}