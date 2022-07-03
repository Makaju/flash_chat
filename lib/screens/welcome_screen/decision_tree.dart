import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants/global_variables.dart';
import 'package:flash_chat/modules/services/database.dart';
import 'package:flash_chat/screens/landing_screen/landing_page.dart';
import 'package:flash_chat/screens/welcome_screen/welcome_screen.dart';
import 'package:flutter/material.dart';

import 'please_verify_your_email_please_page.dart';

class DecisionTree extends StatefulWidget {
  const DecisionTree({Key? key}) : super(key: key);

  @override
  State<DecisionTree> createState() => _DecisionTreeState();
}

class _DecisionTreeState extends State<DecisionTree> {
  User? user;

  @override
  void initState() {
    super.initState();
    getUser();
    onRefresh(FirebaseAuth.instance.currentUser);
  }

  onRefresh(userCred) {
    setState(() {
      user = userCred;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return WelcomeScreen(
        onSignin: (userCred) => onRefresh(userCred),
      );
    } else {
      if (loggedInUser.emailVerified) {
        return LandingPage(screen: 1);
      } else {
        return const PleaseVerifyYourEmailPlease();
      }
    }
  }
}
