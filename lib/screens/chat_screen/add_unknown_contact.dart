import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../landing_screen/landing_page.dart';
import '../landing_screen/profile_page/profile_page.dart';



// ignore: must_be_immutable
class AddNewUnknownContact extends StatefulWidget {
  AddNewUnknownContact(this.addEmail,this.id, {Key? key}) : super(key: key);

  String addEmail;
  String id;

  @override
  State<AddNewUnknownContact> createState() => _AddNewUnknownContactState();
}

class _AddNewUnknownContactState extends State<AddNewUnknownContact> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  late User loggedInUser;
  late String newContactEmail;
  late String newContactNickname;
  late String newContactNumber;
  String cacheURL='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    // cacheURL=getImageUrlCache();

  }

  Future<void> getUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      log(e.toString());
    }
  }
  isFriendStatusUpdater(String email) async {
    List idList = [];
    List users = [loggedInUser.email.toString(), email];
    users.sort((a, b) => a.compareTo(b));
    log(users.toString());
    QuerySnapshot querySnapshot = await _fireStore
        .collection('chatRoom')
        .where('users', isEqualTo: users)
        .get();
    final allData = querySnapshot.docs.map((doc) {
      return doc.get('id');
    }).toList();
    if (allData != null || allData.isNotEmpty) {
      setState(() {
        idList = allData.toList();
      });
    }
    if(idList!=[]||idList.isNotEmpty){
      List newDataToAdd=[loggedInUser.email.toString()];
      FirebaseFirestore.instance.collection('chatRoom').doc(
          idList.first.toString()).update(
          {"isFriend": FieldValue.arrayUnion(newDataToAdd)});
      FirebaseFirestore.instance.collection('chatRoom').doc(
          idList.first.toString()).update(
          {"isNotFriend": FieldValue.arrayRemove([loggedInUser.email])});



    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(
          image: const AssetImage(
            "images/welcome.jpg",
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children:[
                            const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 32,
                            ),
                            Text(
                              'Back',
                              style: GoogleFonts.lato(
                                  textStyle: const TextStyle(color:Colors.white,fontWeight: FontWeight.bold, fontSize: 20)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 100),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.7,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(28),
                                    bottom: Radius.circular(16),
                                  )),
                              // height: 325,
                              child: Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(10, 100, 10, 10),
                                  child: SingleChildScrollView(
                                    // physics: const NeverScrollableScrollPhysics(),
                                    child: Column(
                                      children: [
                                        //email
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 16),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor ==
                                                    Colors.black
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
                                                    'Email',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .headline1
                                                            ?.color,
                                                        fontSize: 10.sp),
                                                  ),
                                                  TextFormField(
                                                    enabled: false,
                                                    initialValue: widget.addEmail,
                                                    // controller: messageTextController,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(color: Theme.of(context).primaryColor),
                                                    onChanged: (value) {
                                                      newContactEmail = widget
                                                          .addEmail
                                                          .toString();
                                                    },
                                                    decoration:
                                                    kLightTextField.copyWith(
                                                        hintText:
                                                        'Enter Email',
                                                        hintStyle: TextStyle(
                                                            color: Theme.of(
                                                                context)
                                                                .textTheme
                                                                .headline1
                                                                ?.color
                                                                ?.withOpacity(
                                                                0.5))),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        //Nickname
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 16),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: themeGetter(context) ==
                                                    true
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
                                                    'Nickname',
                                                    style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                            color:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .headline1
                                                                ?.color,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 16)),
                                                  ),
                                                  TextField(
                                                    style: TextStyle(color: Theme.of(context).primaryColor),
                                                    // controller: messageTextController,
                                                    textAlign: TextAlign.center,
                                                    onChanged: (value) {
                                                      newContactNickname = value;
                                                    },
                                                    decoration:
                                                    kLightTextField.copyWith(
                                                        hintText:
                                                        'Enter Nickname',
                                                        hintStyle: TextStyle(
                                                            color: Theme.of(
                                                                context)
                                                                .textTheme
                                                                .headline1
                                                                ?.color
                                                                ?.withOpacity(
                                                                0.5))),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        //Contact Number
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 16),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: themeGetter(context) ==
                                                    true
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
                                                    'Contact Number',
                                                    style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                            color:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .headline1
                                                                ?.color,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 16)),
                                                  ),
                                                  TextField(
                                                    style: TextStyle(color: Theme.of(context).primaryColor),
                                                    keyboardType:
                                                    TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    onChanged: (value) {
                                                      newContactNumber = value;
                                                    },
                                                    decoration:
                                                    kLightTextField.copyWith(
                                                        hintText:
                                                        'Enter Contact Number',
                                                        hintStyle: TextStyle(
                                                            color: Theme.of(
                                                                context)
                                                                .textTheme
                                                                .headline1
                                                                ?.color
                                                                ?.withOpacity(
                                                                0.5))),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        //Creat new account button
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: Material(
                                            color: const Color(0xFF4a148c),
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(30.0)),
                                            elevation: 5.0,
                                            child: MaterialButton(
                                              onPressed: () async {
                                                //for editing the isFriend
                                                isFriendStatusUpdater(widget.addEmail);

                                                //todo continue from here
                                                final docUser = FirebaseFirestore
                                                    .instance
                                                    .collection('contactDetails')
                                                    .doc();
                                                messageTextController.clear();
                                                final json = {
                                                  'id': docUser.id,
                                                  'email':
                                                  widget.addEmail.toString(),
                                                  'nickname': newContactNickname,
                                                  'contact': newContactNumber,
                                                  'whoseContact': loggedInUser
                                                      .email
                                                      .toString(),
                                                };
                                                await docUser.set(json);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LandingPage(
                                                              screen: 1,
                                                            )));
                                              },
                                              minWidth: 200.0,
                                              height: 42.0,
                                              child: Text(
                                                'Create New Contact',
                                                style: GoogleFonts.lato(
                                                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          Positioned(
                            top: -96,
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                  Border.all(color: Colors.white, width: 5),
                                  color: const Color(0xCA4a148c),
                                  shape: BoxShape.circle),
                              child: profilePictureWidget(
                                  widget.addEmail.toString(), 96.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
