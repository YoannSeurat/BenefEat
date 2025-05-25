import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

const String _assetPath = 'assets/data/userInfo.json';
const String _fileName = 'userInfo.json';

Future<File> _getLocalFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/$_fileName');
}

Future<List<dynamic>> getUserInfo() async {
  final file = await _getLocalFile();
  if (!(await file.exists())) {
    final assetData = await rootBundle.loadString(_assetPath);
    await file.writeAsString(assetData);
  }
  final contents = await file.readAsString();
  final decoded = jsonDecode(contents);
  if (decoded is List) {
    return decoded;
  } else {
    final assetData = await rootBundle.loadString(_assetPath);
    await file.writeAsString(assetData);
    return jsonDecode(assetData) as List<dynamic>;
  }
}

Future<int> getConnectedUser() async {
  final userInfo = await getUserInfo();
  for (int i = 0; i < userInfo.length; i++) {
    if (userInfo[i]['connected'] == true) {
      return i;
    }
  }
  return -1;
}

Future<String> getSpecificUserInfo(String label) async {
  final userInfo = await getUserInfo();
  final connectedIndex = await getConnectedUser();
  if (connectedIndex == -1) {
    return 'Utilisateur déconnecté';
  }
  return userInfo[connectedIndex][label];
}

Future<int> writeUserInfo(List<dynamic> data) async {
  try {
    final file = await _getLocalFile();
    await file.writeAsString(jsonEncode(data));
    return 1;
  } catch (e) {
    return 0;
  }
}

Future<int> addUser(String username, String email, String password, String adress) async {
  /* 
  Returns:
    O: write error
    1: success
    2: username already exists
    3: email already exists
  */
  final newUserInfo = await getUserInfo();
  // checks if user doesnt already exist
  for (var user in newUserInfo) {
    if (user['username'] == username) return 2;
    if (user['email'] == email) return 3;
    user['connected'] = false; // disconnect users
  }
  newUserInfo.add(
    {
      "connected" : true,
      "username" : username,
      "email" : email,
      "password" : password,
      "adress" : adress
    }
  );
  return await writeUserInfo(newUserInfo);
}

Future<int> removeUser(String username) async {
  final newUserInfo = await getUserInfo();
  final initialLength = newUserInfo.length;
  newUserInfo.removeWhere((user) => user['username'] == username);
  if (newUserInfo.length == initialLength) {
    return 0;
  }
  return await writeUserInfo(newUserInfo);
}

Future<int> modifySpecificUserInfo(String label, String value) async {
  /* 
  Returns:
    O: write error
    1: success
    2: username or email already exists
  */
  final newUserInfo = await getUserInfo();
  final connectedIndex = await getConnectedUser();
  if (connectedIndex == -1) {
    return 0;
  }
  
  // checks if user info doesnt already exist
  if (label == "username" || label == "email") {
    for (var user in newUserInfo) {
      if (user[label] == value) return 2;
    }
  }

  // change pfp path name if username is being changed
  if (label == "username") {
    final oldUsername = newUserInfo[connectedIndex]['username'];
    final directory = await getApplicationDocumentsDirectory();
    final oldPath = '${directory.path}/user_profile_picture_$oldUsername.png';
    final oldFile = File(oldPath);
    
    if (await oldFile.exists()) {
      try {
        final newPath = '${directory.path}/user_profile_picture_$value.png';
        await oldFile.rename(newPath);
      } catch (e) {
        print('Error renaming profile picture: $e');
      }
    }
  }
  
  newUserInfo[connectedIndex][label] = value;
  return await writeUserInfo(newUserInfo);
}

Future<int> connectUser(String email, String password) async {
  /*
  Returns :
    0 : write error
    1 : everything is good
    2 : email does not exist
    3 : password is incorrect
  */
  final newUserInfo = await getUserInfo();

  int foundIndex = -1;
  int i = 0;
  while (i < newUserInfo.length && foundIndex == -1) {
    if (newUserInfo[i]['email'] == email) {
      foundIndex = i;
    }
    i ++;
  }
  
  if (foundIndex == -1) {
    return 2;
  } if (newUserInfo[foundIndex]['password'] != password) {
    return 3;
  }
  newUserInfo[foundIndex]['connected'] = true;
  return await writeUserInfo(newUserInfo);
}

Future<int> disconnectUser() async {
  final newUserInfo = await getUserInfo();
  final connectedIndex = await getConnectedUser();
  if (connectedIndex == -1) {
    return 0;
  }
  newUserInfo[connectedIndex]['connected'] = false;
  return await writeUserInfo(newUserInfo);
}