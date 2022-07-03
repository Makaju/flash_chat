import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants/constants.dart';
import 'package:flash_chat/constants/global_variables.dart';
import 'package:flash_chat/screens/landing_screen/profile_page/profile_page.dart';
import 'package:flash_chat/screens/welcome_screen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ChangePasswordPopUp extends StatefulWidget {
  const ChangePasswordPopUp({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPopUp> createState() => _ChangePasswordPopUpState();
}

class _ChangePasswordPopUpState extends State<ChangePasswordPopUp> {
  late String oldPassword;
  late String newPassword;
  late String newPasswordTry;
  final verifyPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool spinner = false;
  bool isDarkModeDemo = false;
  bool pass1 = true;
  bool pass2 = true;
  bool pass3 = true;
  bool isDarkMode = false;

  @override
  void dispose() {
    // TODO: implement dispose
    verifyPasswordController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    isDarkMode=themeGetter(context);
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        color: isDarkMode ? Colors.white : Colors.black,
                        size: 32,
                      ),
                      Text(
                        'Back',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                color:
                                isDarkMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 160),
                child: Center(
                  child: SizedBox(
                    // color: const Color(0x51e1bee1),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 550,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                            height: 550,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.grey.shade900
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 128),
                              child: Form(
                                key: _formKey,
                                child: SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: Column(
                                    children: [
                                      //old password
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                              Theme.of(context).primaryColor == Colors.white
                                                  ? Colors.transparent
                                                  : const Color(0x22424242),
                                              borderRadius:
                                              BorderRadius.circular(15.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Old Password',
                                                  style: GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 20,
                                                          color: Theme.of(context)
                                                              .textTheme
                                                              .headline1
                                                              ?.color)),
                                                ),
                                                TextField(
                                                  obscureText: pass1,
                                                  keyboardType:
                                                  TextInputType.text,
                                                  textAlign: TextAlign.left,
                                                  onChanged: (value) {
                                                    oldPassword = value;
                                                    //Do something with the user input.
                                                  },
                                                  decoration:

                                                  kLightTextField.copyWith(
                                                    contentPadding:
                                                    const EdgeInsets.only(
                                                        top: 16),
                                                    suffixIcon: IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            pass1=
                                                            !pass1;
                                                          });
                                                        },
                                                        icon: Icon(pass1
                                                            ? Icons.visibility
                                                            : Icons.visibility_off)),
                                                    prefixIcon: const Icon(
                                                        Icons.lock),
                                                    hintText:
                                                    'Enter Old Password',
                                                    hintStyle: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .headline1
                                                                ?.color
                                                                ?.withOpacity(
                                                                0.5))),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      //new password
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                              Theme.of(context).primaryColor == Colors.white
                                                  ? Colors.transparent
                                                  : const Color(0x22424242),
                                              borderRadius:
                                              BorderRadius.circular(15.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'New Password',
                                                  style: GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 20,
                                                          color: Theme.of(context)
                                                              .textTheme
                                                              .headline1
                                                              ?.color)),
                                                ),
                                                TextField(
                                                  obscureText: pass2,
                                                  keyboardType:
                                                  TextInputType.text,
                                                  textAlign: TextAlign.left,
                                                  controller:
                                                  newPasswordController,
                                                  onChanged: (value) {
                                                    newPassword = value;
                                                    //Do something with the user input.
                                                  },
                                                  decoration:
                                                  kLightTextField.copyWith(
                                                    contentPadding:
                                                    const EdgeInsets.only(
                                                        top: 16),
                                                    suffixIcon: IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            pass2=
                                                            !pass2;
                                                          });
                                                        },
                                                        icon: Icon(pass2
                                                            ? Icons.visibility
                                                            : Icons.visibility_off)),
                                                    prefixIcon: const Icon(
                                                        Icons.password),
                                                    hintText:
                                                    'Enter New Password',
                                                    hintStyle: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .headline1
                                                                ?.color
                                                                ?.withOpacity(
                                                                0.5))),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      //new password confirm
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                              Theme.of(context).primaryColor == Colors.white
                                                  ? Colors.transparent
                                                  : const Color(0x22424242),
                                              borderRadius:
                                              BorderRadius.circular(15.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Confirm New Password',
                                                  style: GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 20,
                                                          color: Theme.of(context)
                                                              .textTheme
                                                              .headline1
                                                              ?.color)),
                                                ),
                                                TextFormField(
                                                  obscureText: pass3,
                                                  textAlign: TextAlign.left,
                                                  autovalidateMode:
                                                  AutovalidateMode
                                                      .onUserInteraction,
                                                  controller:
                                                  verifyPasswordController,
                                                  validator: (value) {
                                                    if (verifyPasswordController
                                                        .text ==
                                                        newPasswordController
                                                            .text) {
                                                      if (value == null ||
                                                          value.isEmpty ||
                                                          value.length < 6) {
                                                        return 'please provide a password with more than 6 characters';
                                                      } else {
                                                        return null;
                                                      }
                                                    } else {
                                                      return 'Password Does not match';
                                                    }
                                                  },
                                                  decoration:
                                                  kLightTextField.copyWith(
                                                    contentPadding:
                                                    const EdgeInsets.only(top: 16),
                                                    suffixIcon: IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            pass3=
                                                            !pass3;
                                                          });
                                                        },
                                                        icon: Icon(pass3
                                                            ? Icons.visibility
                                                            : Icons.visibility_off)),
                                                    prefixIcon:
                                                    const Icon(Icons.password),
                                                    hintText:
                                                    'Confirm New Password',
                                                    hintStyle: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .headline1
                                                                ?.color
                                                                ?.withOpacity(
                                                                0.5))),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      //change button
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: Material(
                                          color: const Color(0xFF4a148c),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8.0)),
                                          elevation: 5.0,
                                          child: MaterialButton(
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  newPasswordTry =
                                                      verifyPasswordController
                                                          .text;
                                                  spinner = true;
                                                });
                                                checkPassword();
                                              }
                                            },
                                            child: const Text(
                                              'Change',
                                              style:
                                              TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )),
                        Positioned(
                          top: -96,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor == Colors.white
                                            ? Colors.black
                                            : Colors.white,
                                        width: 5),
                                    color: const Color(0xCA4a148c),
                                    shape: BoxShape.circle),
                                child: profilePictureWidget(
                                    loggedInUser.email.toString(), 96.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//function
  Future<void> checkPassword() async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: loggedInUser.email.toString(), password: oldPassword);
      if (user != null) {
        changePassword();
      }
    } on FirebaseAuthException catch (error) {
      spinner = false;
      String errorMessage = error.message.toString();
      Fluttertoast.showToast(msg: errorMessage, gravity: ToastGravity.TOP);
    }
  }

  changePassword() async {
    if (verifyPasswordController.text == newPasswordController.text) {
      try {
        await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
        FirebaseAuth.instance.signOut();
        spinner = false;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => WelcomeScreen(onSignin: (user)=>null,)));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor:
            isDarkModeDemo ? Colors.grey.shade700 : Colors.grey.shade500,
            content: Text(
              'Please log in with your new password',
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: Theme.of(context).textTheme.headline1?.color)),
            )));
      } catch (e) {
        log(e.toString());
      }
    } else {}
  }
}
