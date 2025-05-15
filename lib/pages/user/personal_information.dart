import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;
import 'package:benefeat/constants/user_info.dart' as userinfo;

class PersonalInformationPage extends StatefulWidget {
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

  void startEditing(String label) {
    setState(() {
      isEditing[label] = true;
    });
  }

  Future<void> stopEditing(String label, String newValue) async {
    setState(() {
      isEditing[label] = false;
    });
    final successfulMofication = await userinfo.modifySpecificUserInfo(label, newValue);
    print(successfulMofication);
    final userInfo = await userinfo.getUserInfo();
    print(userInfo);
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: colors.white,
      appBar: appBar(context, userName, userEmail, userPassword, userAdress),
      body: body(context, userName, userEmail, userPassword, userAdress, isEditing, startEditing, stopEditing),
    );
  }
}

AppBar appBar(BuildContext context, String? userName, String? userEmail, String? userPassword, String? userAdress) {
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
  String? userName,
  String? userEmail,
  String? userPassword,
  String? userAdress,
  Map isEditing,
  Function startEditing,
  Function stopEditing,
) {
  return Container(
    child: SingleChildScrollView(
      child: Center(
        child: Column(
          spacing: MediaQuery.of(context).size.height / 20,
          children: [
            SizedBox(height: 20,),

            Text(
              "Informations personnelles",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 50),

            containerToModifyInfo(context, "Nom d'utilisateur", userName, isEditing, startEditing, stopEditing),

            containerToModifyInfo(context, "Email", userEmail, isEditing, startEditing, stopEditing),

            containerToModifyInfo(context, "Mot de passe", userPassword, isEditing, startEditing, stopEditing),

            containerToModifyInfo(context, "Adresse", userAdress, isEditing, startEditing, stopEditing),
          ],
        ),
      ),
    ),
  );
}

Widget containerToModifyInfo(BuildContext context, String label, String? labelinfo, Map isEditing, Function startEditing, Function stopEditing) {
  return GestureDetector(
    child: Container(
      width: MediaQuery.of(context).size.width * 0.8,
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
                      controller: TextEditingController(text: labelinfo),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      onSubmitted: (newValue) async {
                        String newlabel;
                        switch (label) {
                          case "Nom d'utilisateur":
                            newlabel = "username";
                            break;
                          case "Email":
                            newlabel = "email";
                            break;
                          case "Mot de passe":
                            newlabel = "password";
                            break;
                          case "Adresse":
                            newlabel = "adress";
                            break;
                          default:
                            newlabel = "ERROR";
                        }
                        await stopEditing(newlabel, newValue);
                      },
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
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
                          labelinfo ?? "",
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