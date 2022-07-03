import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants/constants.dart';
import 'package:flash_chat/constants/global_variables.dart';
import 'package:flash_chat/screens/landing_screen/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
late String usernameForPopup;

class Signin {
  Future<void> signIn(
      String email, String password, BuildContext context) async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        spinnerLogin = false;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LandingPage(
                  screen: 1,
                )));
      }
    } on FirebaseAuthException catch (error) {
      String errorMessage = error.message.toString();
      Fluttertoast.showToast(msg: errorMessage, gravity: ToastGravity.TOP);
    }
  }
}

Future<void> getUser() async {
  try {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
      userEmail = loggedInUser.email.toString();
      userName = loggedInUser.displayName.toString();
    }
  } catch (e) {
    log(e.toString());
  }
}

Future<void> getUsersNameForPopup(String checkUsersEmail) async {
  await getUser();
  QuerySnapshot querySnapshot = await _fireStore
      .collection('userDetails')
      .where('email', isEqualTo: checkUsersEmail)
      .get();
  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) {
    if (doc["email"] == checkUsersEmail) {
      // var key;
      return doc['userName'];
    }
  }).toList();
  var filteredData = filter(allData);
  usernameForPopup = filteredData;
  log('here it gets name of user $filteredData');
  return filteredData;
}

Future<void> getUsersName() async {
  await getUser();
  QuerySnapshot querySnapshot = await _fireStore
      .collection('userDetails')
      .where('email', isEqualTo: userEmail)
      .get();
  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) {
    if (doc["email"] == userEmail) {
      // var key;
      return doc['userName'];
    }
  }).toList();
  var filteredData = filter(allData);
  nameofuser = filteredData;
  log('here it gets name of user $filteredData');
  return filteredData;
}

Future getUsersIdFromUserDetails() async {
  await getUser();
  QuerySnapshot querySnapshot =
  await _fireStore.collection('userDetails').get();
  final allData = querySnapshot.docs.map((doc) {
    if (doc["email"] == userEmail) {
      // var key;
      return doc.id;
    }
  }).toList();
  var filteredData = filter(allData);
  return filteredData.toString();
}

Future<bool> containsIdOrNotInUserDetails(String token) async {
  bool boolValue=false;
  await getUser();
  log('this is id$token');
  QuerySnapshot querySnapshot = await _fireStore
      .collection('userDetails')
      .where('email', isEqualTo: loggedInUser.email)
      .get();
  final allData = querySnapshot.docs.map((doc) {
    return doc;
  }).toList();
  log(allData.length.toString());
  for (int i = 0; i < allData.length; i++) {
    log('this is bool value${allData[i]['token']}');
    //check if it contains the token else add the token
    if (token == allData[i]['token']) {
      boolValue=false;
    } else {
      boolValue=true;
    }
  }
  log("this is the bool value$boolValue");
  return boolValue;
}



Future getEmailData() async {
  await getUser();
  // Get docs from collection reference
  QuerySnapshot querySnapshot = await _fireStore.collection('contacts').get();
  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) {
    if (doc["whoseContact"] == userEmail) {
      // var key;
      return doc.id;
    }
  }).toList();
  var filteredData = filter(allData);
  // log(filteredData);
  return filteredData;
}

filter(List allData) {
  for (int i = 0; i < allData.length; i++) {
    if (allData[i] != null) {
      return allData[i];
    }
  }
}
