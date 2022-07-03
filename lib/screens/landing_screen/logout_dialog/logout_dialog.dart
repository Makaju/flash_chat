import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flash_chat/screens/welcome_screen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../modules/services/database.dart';

class LogoutDialog extends StatefulWidget {
  const LogoutDialog({Key? key}) : super(key: key);

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40, top: 300),
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).dialogBackgroundColor,
                borderRadius: BorderRadius.circular(30.0)),
            child: SizedBox(
              height: 168,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Text('Are you sure to logout?',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 24,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold))),
                    const SizedBox(
                      height: 26,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Material(
                            color: Colors.green.shade500,
                            borderRadius:
                            const BorderRadius.all(Radius.circular(15.0)),
                            elevation: 5.0,
                            child: MaterialButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                //todo here add remove token module
                                await removeNotificationToken();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => WelcomeScreen(
                                          onSignin: (user) => null,
                                        )),
                                        (route) => false);

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor:Theme.of(context).colorScheme.onSecondary,
                                        content: Text(
                                          'Logged out succesfully',
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .headline1
                                                      ?.color)),
                                        )));
                              },
                              child: Text(
                                'Yes',
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          Material(
                              color: Colors.red.shade500,
                              borderRadius:
                              const BorderRadius.all(Radius.circular(15.0)),
                              elevation: 5.0,
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: Text('No',
                                    style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  removeNotificationToken() async {
    await FirebaseMessaging.instance.getToken().then((value) async {
      log(value.toString() + '  what are you doing');
      String docId = await getUsersIdFromUserDetails();
      bool removeToken = await containsIdOrNotInUserDetails(value.toString());
      if (removeToken) {
        log('doc ID' + docId + '   ' + removeToken.toString());
        final docUser = FirebaseFirestore.instance
            .collection('userDetails')
            .doc(docId)
            .update({
          "token": FieldValue.arrayRemove([value])
        });
      }
    });
  }
}
