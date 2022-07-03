import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/constants/constants.dart';
import 'package:flash_chat/constants/global_variables.dart';
import 'package:flash_chat/screens/landing_screen/landing_page.dart';
import 'package:flash_chat/screens/landing_screen/profile_page/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class EditContact extends StatefulWidget {
  EditContact(
      {Key? key,
        required this.nickname,
        required this.email,
        required this.contactNo,
        required this.id})
      : super(key: key);
  String nickname;
  String email;
  String contactNo;
  String id;

  @override
  State<EditContact> createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  final emailEdit = TextEditingController();
  final nicknameEdit = TextEditingController();
  final contactNoEdit = TextEditingController();
  bool isDarkModeDemo=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nicknameEdit.text=widget.nickname.toString();
    emailEdit.text =widget.email.toString();
    contactNoEdit.text=widget.contactNo.toString();
  }
  themeGetter() {
    if (Theme.of(context).primaryColor==Colors.black) {
      isDarkModeDemo = true;
      return true;
    } else if (Theme.of(context).primaryColor!=Colors.black) {
      isDarkModeDemo = false;
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    themeGetter();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Container(
            padding: const EdgeInsets.only(top: 100),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Center(
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.5,
                    decoration: BoxDecoration(
                        color: Theme
                            .of(context).dialogBackgroundColor,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(28),
                          bottom: Radius.circular(16),
                        )),
                    // height: 325,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 140, 10, 10),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(1.h),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8)),
                              child: TextFormField(
                                enabled: false,
                                controller: emailEdit,
                                style: const TextStyle(color: Colors.black),
                                decoration: kTextfieldReImagined.copyWith(
                                    prefixIcon: const Icon(Icons.email,color:Colors.black),
                                    hintText: 'Email'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(1.h),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8)),
                              child: TextFormField(
                                style: const TextStyle(color:Colors.black),
                                controller: nicknameEdit,
                                decoration: kTextfieldReImagined.copyWith(
                                    prefixIcon: const Icon(Icons.person,color:Colors.black),
                                    hintText: 'Nickname'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(1.h),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8)),
                              child: TextFormField(
                                controller: contactNoEdit,
                                style: const TextStyle(color:Colors.black),
                                decoration: kTextfieldReImagined.copyWith(
                                    prefixIcon: const Icon(Icons.phone,color:Colors.black),
                                    hintText: 'Contact Number'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 1.h),
                            child: Material(
                              color: const Color(0xFF4a148c),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                              elevation: 5.0,
                              child: MaterialButton(
                                onPressed: () {
                                  final docUser = FirebaseFirestore.instance
                                      .collection('contactDetails')
                                      .doc(widget.id.toString());
                                  docUser.update({
                                    'email': emailEdit.text,
                                    'nickname': nicknameEdit.text,
                                    'conact': contactNoEdit.text,
                                  });

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LandingPage(
                                            screen: 0,
                                          )));
                                },
                                child:  Text(
                                  'Save',
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                //profile picture container
                Positioned(
                  top: -96,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 5),
                            color: const Color(0xCA4a148c),
                            shape: BoxShape.circle),
                        child:
                        profilePictureWidget(widget.email.toString(), 96.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
