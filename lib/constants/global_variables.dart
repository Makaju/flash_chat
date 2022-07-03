import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/modules/services/storage_services.dart';
import 'package:flutter/material.dart';

late User loggedInUser;
late String userEmail;
late String userName;
String? nameofuser;
final Storage storage = Storage();
String? profileOfUserLink;



themeGetter(BuildContext context) {
  if (Theme.of(context).primaryColor == Colors.white) {
    // isDarkModeDemo = true;
    return true;
  } else if (Theme.of(context).primaryColor != Colors.white) {
    // isDarkModeDemo = false;
    return false;
  }
}