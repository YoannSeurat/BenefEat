import 'package:flutter/material.dart';
import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;
import 'package:benefeat/constants/user_info.dart' as userinfo;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.white,
      body: body(),
    );
  }
}

Container body() {
  //// ignore: avoid_unnecessary_containers
  return Container(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 20,
        children: [
          SizedBox(height: constants.APPBAR_HEIGHT + 100,),
          ElevatedButton(
          onPressed: () async {
              print(await userinfo.getUserInfo());
              print(await userinfo.getConnectedUser());
              print(await userinfo.getSpecificUserInfo("username"));
            }, 
            child: Text("")
          ),
        ],
      ),
    ),
  );
}