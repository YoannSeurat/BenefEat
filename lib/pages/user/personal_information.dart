import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;

class PersonalInformationPage extends StatefulWidget {
  final String? userName;
  final String? userEmail;
  final String? userPassword;

  const PersonalInformationPage(
    this.userName,
    this.userEmail,
    this.userPassword, {
    super.key,
  });

  @override
  State<PersonalInformationPage> createState() => _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.white,
      appBar: appBar(),
      body: body(context, widget.userName, widget.userEmail, widget.userPassword),
    );
  }
}

AppBar appBar() {
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
  String? email,
  String? password,
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

            containerToModifyInfo(context, "Username", userName),

            containerToModifyInfo(context, "Email", email),

            containerToModifyInfo(context, "Password", password),
          ],
        ),
      ),
    ),
  );
}

Widget containerToModifyInfo(BuildContext context, String label, String? labelinfo) {
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
                label == "Password" 
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
      // TODO
    },
  );
}