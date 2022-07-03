import 'package:flutter/material.dart';



bool spinnerLogin = false;
// ThemeProvider themeProvider =ThemeProvider();
// bool get isDarkMode => themeProvider.themeMode == ThemeMode.dark;

InputDecoration kLightTextField = const InputDecoration(
  contentPadding: EdgeInsets.all(8),
);

const kTextfield = InputDecoration(
  hintText: 'Enter your password',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),

  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF4a148c), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
);
const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

Color kContainerColorLight = const Color(0xFFf5f5ff);
Color kContainerColorDark = Colors.black;

BoxDecoration kMessageContainerDecorationlight = const BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(15.0)),
  color: Color(0x334a148c),
  // border: Border(
  //   top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  // ),
);
BoxDecoration kMessageContainerDecorationDark = const BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(15.0)),
  color: Color(0x99424242),
  // border: Border(
  //   top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  // ),
);

const kTextfieldReImagined = InputDecoration(
  hintText: 'Enter your password',
  border: InputBorder.none,
  // OutlineInputBorder(borderSide:BorderSide(color: Colors.lightBlueAccent, width: 0.0) ),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
  // border: OutlineInputBorder(
  //   borderRadius: BorderRadius.all(Radius.circular(15.0)),
  // ),
  // enabledBorder: OutlineInputBorder(
  //   borderSide : BorderSide(color: Color(0xFF4a148c), width: 0.0),
  //   borderRadius: BorderRadius.all(Radius.circular(15.0)),
  // ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF4a148c), width: 0.0),
    // borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
);
