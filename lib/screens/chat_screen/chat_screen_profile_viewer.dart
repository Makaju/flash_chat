import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/constants/global_variables.dart';
import 'package:flash_chat/screens/landing_screen/profile_page/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../landing_screen/contacts_page/edit_contact_popup.dart';
import 'block_dialog.dart';

// ignore: must_be_immutable
class ChatScreenProfileViewer extends StatefulWidget {
  ChatScreenProfileViewer({Key? key,
    required this.user,
    required this.name,
    required this.chatRoomID,
    required this.blocked,
    required this.blockedBy,
    required this.otherUser})
      : super(key: key);
  String user;
  String name;
  String chatRoomID;
  bool blocked;
  String blockedBy;
  String otherUser;

  @override
  State<ChatScreenProfileViewer> createState() =>
      _ChatScreenProfileViewerState();
}

final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

class _ChatScreenProfileViewerState extends State<ChatScreenProfileViewer> {
  String contact='';
  String receiversEmail='';
  String name='';
  String id='';


  @override
  initState() {
    super.initState();
    infoGetter();
  }

  @override
  Widget build(BuildContext context) {
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
                            .of(context)
                            .dialogBackgroundColor,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(28),
                          bottom: Radius.circular(16),
                        )),
                    // height: 325,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 140, 10, 10),
                      child: Column(
                        children: [
                          Text(
                            widget.name,
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32,
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .headline1
                                        ?.color)),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.user,
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .headline1
                                        ?.color)),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return EditContact(
                                      contactNo: contact,
                                      email: receiversEmail,
                                      nickname: name,
                                      id: id,
                                    );
                                  });
                            },
                            child: Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.8,
                              color: Colors.transparent,
                              height: 64,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.edit),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Text(
                                        'Edit Contact',
                                        style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                                fontSize: 20,
                                                color: Theme
                                                    .of(context)
                                                    .textTheme
                                                    .headline1
                                                    ?.color)),
                                      ),
                                    ],
                                  ),
                                  const RotatedBox(
                                      quarterTurns: 2,
                                      child:
                                      Icon(Icons.arrow_back_ios_outlined))
                                ],
                              ),
                            ),
                          ),
                          //block button
                          GestureDetector(
                            onTap: () async {
                              showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return BlockDialog(
                                      chatRoomId: widget.chatRoomID,
                                      blockedBy: widget.blockedBy,
                                      blockStatus: widget.blocked,
                                    );
                                  });
                            },
                            child: Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.80,
                              color: Colors.transparent,
                              height: 64,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  blockButtonReturner(
                                      widget.blocked, widget.blockedBy),
                                  const RotatedBox(
                                      quarterTurns: 2,
                                      child:
                                      Icon(Icons.arrow_back_ios_outlined))
                                ],
                              ),
                            ),
                          ),
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
                        profilePictureWidget(widget.user.toString(), 96.0),
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

  infoGetter() async {
    QuerySnapshot querySnapshot = await _fireStore
        .collection('contactDetails')
        .where('whoseContact', isEqualTo: loggedInUser.email.toString())
        .where('email', isEqualTo: widget.otherUser.toString())
        .get();
    final data1 = querySnapshot.docs.map((doc) {
      return doc.get('nickname');}).toList();
    name=data1[0];
    final data2 = querySnapshot.docs.map((doc) {
      return doc.get('email');}).toList();
    receiversEmail=data2[0];
    final data3 = querySnapshot.docs.map((doc) {
      return doc.get('id');}).toList();
    id=data3[0];
    final data4 = querySnapshot.docs.map((doc) {
      return doc.get('contact');}).toList();
    contact=data4[0];
    }

        nameGetter()
    async {
      QuerySnapshot querySnapshotNickname = await _fireStore
          .collection('contactDetails')
          .where('email', isEqualTo: widget.user)
          .where('whoseContact', isEqualTo: loggedInUser.email.toString())
          .get();
      final allDataNickname = querySnapshotNickname.docs.map((doc) {
        return doc;
      }).toList();
    }

    blockButtonReturner(bool blockStatus, String blockedBy) {
      if (blockStatus == false) {
        return Row(
          children: [
            const Icon(
              Icons.block,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              'Block',
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontSize: 20,
                      color: Theme
                          .of(context)
                          .textTheme
                          .headline1
                          ?.color)),
            ),
          ],
        );
      } else {
        if (blockedBy == loggedInUser.email.toString()) {
          return Row(
            children: [
              const Icon(
                Icons.block,
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                'Unblock',
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: 20,
                        color: Theme
                            .of(context)
                            .textTheme
                            .headline1
                            ?.color)),
              ),
            ],
          );
        } else if (blockedBy != loggedInUser.email.toString()) {
          return Row(
            children: [
              const Icon(
                Icons.block,
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                'You have been Block',
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: 20,
                        color: Theme
                            .of(context)
                            .textTheme
                            .headline1
                            ?.color)),
              ),
            ],
          );
        }
      }
    }
  }
