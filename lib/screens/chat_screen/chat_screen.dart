import 'dart:developer';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants/global_variables.dart';
import 'package:flash_chat/screens/landing_screen/landing_page.dart';
import 'package:flash_chat/screens/landing_screen/profile_page/profile_page.dart';
import 'package:flutter/material.dart';
import 'chat_screen_profile_viewer.dart';
import 'message_bubble.dart';
import 'modules/text_input_field.dart';

final _auth = FirebaseAuth.instance;
String messageText = '';
final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key, required this.chatRoomId, required this.users})
      : super(key: key);

  static const String id = 'chat_screen';
  String chatRoomId;
  List users;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  bool get isDarkMode =>
      Theme.of(context).primaryColor==Colors.black;
  String nameToDisplay = '';
  late String otherUser;
  List dataList = [];
  bool blocked = false;
  String blockedBy = '';
  int receiverIndex = 0;
  int theirPosition=0;
  int userListForimageSendingFeature=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findReceiverIndex();
    getUser();
    theOtherUserFinder(widget.users);
    nickNameGetter();
    theirPosition=findUserPosition(widget.users);
  }

  @override
  Widget build(BuildContext context) {
    isFriendNumberCalculator();
    editReadStatusOnTheBeginning();
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await backToInbox(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          // leading: null,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return ChatScreenProfileViewer(
                            user: otherUser,
                            name: nameToDisplay,
                            chatRoomID: widget.chatRoomId,
                            blockedBy: blockedBy,
                            blocked: blocked,
                            otherUser: otherUser,
                          );
                          //const ChangePasswordPopUp();
                        });
                  },
                  child: profilePictureWidget(otherUser, 20.0)),
            ),
          ],
          title: nameToDisplay != ''
              ? Text(nameToDisplay)
              : const Text('not logged in user'),
          backgroundColor: themeGetter(context)
              ? Colors.grey.shade900
              : const Color(0xFF4a148c),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FutureBuilder(
                future: getBlockStatus(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (blocked == true) {
                    if (blockedBy.toString() == loggedInUser.email.toString()) {
                      return Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width * 1,
                        color: Colors.redAccent,
                        child:
                            const Center(child: Text('Please unblock to chat', style: TextStyle(color: Colors.white),)),
                      );
                    } else {
                      return Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width * 1,
                        color: Colors.redAccent,
                        child: const Center(
                            child:
                                Text('You have been blocked by the receiver.', style: TextStyle(color: Colors.white),)),
                      );
                    }
                  } else {
                    return Container();
                  }
                },
              ),
              Expanded(
                child: MyNewMessagesStream(
                  toWhom: otherUser.toString(),
                  chatroomId: widget.chatRoomId, theirPosition: theirPosition,
                ),
              ),
              typingStatusStream(),
              MessageInputBox(
                isDarkMode: isDarkMode,
                // widget: widget,
                isFriend: true,
                chatRoomId: widget.chatRoomId,
                blockStatus: blocked,
                otherUser: otherUser, theirPosition: theirPosition, isFriendNumbers: userListForimageSendingFeature,
              ),
            ],
          ),
        ),
      ),
    );
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

  nickNameGetter() async {
    QuerySnapshot querySnapshot = await _fireStore
        .collection('contactDetails')
        .where('whoseContact', isEqualTo: loggedInUser.email.toString())
        .where('email', isEqualTo: otherUser.toString())
        .get();
    final allData = querySnapshot.docs.map((doc) {
      return doc.get('nickname');
    }).toList();
    if (allData != null || allData.isNotEmpty) {
      setState(() {
        dataList = allData.toList();
      });
    }
    nameToDisplay = dataList[0];
  }

  findUserPosition(List user) {
    for (int t = 0; t < user.length; t++) {
      if (user[t] != loggedInUser.email.toString()) {
        return t;
      }
    }
  }
  isFriendNumberCalculator() async {
    int num = 0;
    DocumentSnapshot docSnapshot =
        await _fireStore.collection('chatRoom').doc(widget.chatRoomId).get();
    final List allNameData = docSnapshot.get('isFriend').toList();
    userListForimageSendingFeature=allNameData.length.toInt();
    // return allNameData.length.toInt();
  }

  findReceiverIndex() async {
    int num = 0;
    DocumentSnapshot docSnapshot =
        await _fireStore.collection('chatRoom').doc(widget.chatRoomId).get();
    final allSeenData = await docSnapshot.get('isSeen');
    final allNameData = docSnapshot.get('users').toList();
    if (allSeenData != null || allSeenData.isNotEmpty) {

       num = theOtherUserFinder(allNameData);
       receiverIndex = num;
      return num;
    }
  }

  editReadStatusOnTheBeginning() async {

    int numb = await findReceiverIndex();
    final docUser = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatRoomId);
    if (numb == 0) {
      docUser.update({
        'isSeen': [true, true],
      });
    } else if (numb == 1) {
      docUser.update({
        'isSeen': [true, true],
      });
    }
  }

  theOtherUserFinder(List users) {
    for (int i=0;i<users.length;i++) {
      if (users[i] != loggedInUser.email.toString()) {
        otherUser = users[i];
        return i;
      }
    }
  }



  Future<bool?> backToInbox(BuildContext context) async {
    showDialog<bool>(
        context: context,
        builder: (context) {
          return LandingPage(screen: 1);
          //const ChangePasswordPopUp();
        });
    return true;
  }

  Future<bool> getBlockStatus() async {
    DocumentSnapshot docSnapshot =
        await _fireStore.collection('chatRoom').doc(widget.chatRoomId).get();
    if (docSnapshot.get('blocked') != null) {
      blocked = docSnapshot.get('blocked');
    } else {
      blocked = false;
    }

    blockedBy = docSnapshot.get('blockedBy');
    return blocked;
  }

  typingStatusStream() {
    bool status = false;
    return StreamBuilder<QuerySnapshot>(
        stream: _fireStore
            .collection('chatRoom')
            .where('id', isEqualTo: widget.chatRoomId)
            .snapshots(),
        builder: (context, snapshot) {
          final typingStatusFrom = snapshot.data?.docs;
          status = typingStatusFrom?[0]["typingStatus"][theirPosition] ?? false;
          if (status) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Material(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0)),
                    elevation: 5.0,
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0)),
                        color: (themeGetter(context)
                            ? Colors.transparent
                            : Colors.white),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 10, right: 10.0, left: 10),
                          child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minHeight: 16, maxWidth: 300),
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    'Typing...',
                                    speed: const Duration(milliseconds: 50),
                                  ),
                                ],
                                totalRepeatCount: 10,
                                pause: const Duration(milliseconds: 1000),
                                displayFullTextOnTap: true,
                                stopPauseOnTap: true,
                              ))),
                    ),
                  )
                ],
              ),
            );
          }
          return Container();
        });
  }

  getWhoBlocked() async {
    DocumentSnapshot docSnapshot =
        await _fireStore.collection('chatRoom').doc(widget.chatRoomId).get();
    final blockedBy = docSnapshot.get('blockedBy').toList();
  }

  Future<Widget> promptShower() async {
    bool blockStatus = await getBlockStatus();
    if (blockStatus) {
      return Container(
        color: Colors.grey,
        height: 30.0,
        width: MediaQuery.of(context).size.width * 1,
        child: const Center(child: Text('please unblock to send mesage')),
      );
    } else {
      return Container();
    }
  }
}
