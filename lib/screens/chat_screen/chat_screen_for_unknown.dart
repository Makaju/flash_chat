import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../constants/global_variables.dart';
import '../../modules/services/message_database.dart';
import '../landing_screen/profile_page/profile_page.dart';
import 'add_unknown_contact.dart';
import 'message_bubble.dart';
import 'modules/text_input_field.dart';

final _auth = FirebaseAuth.instance;
String messageText ='';
final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

// ignore: must_be_immutable
class ChatScreenForTheUnknown extends StatefulWidget {
  ChatScreenForTheUnknown({Key? key, required this.chatRoomId, required this.users}) : super(key: key);

  static const String id = 'chatScreen';
  String chatRoomId;
  List users;

  @override
  _ChatScreenForTheUnknownState createState() => _ChatScreenForTheUnknownState();
}

class _ChatScreenForTheUnknownState extends State<ChatScreenForTheUnknown> {
  bool get isDarkMode => Theme.of(context).primaryColor == Colors.black;
  final DatabaseMethods _databaseMethods = DatabaseMethods();
  String nameToDisplay = '';
  late String otherUser;

//   Future<void> getMessages() async {
//     QuerySnapshot querySnapshot = await _firestore.collection("messages").getDocuments();
//     for (int i = 0; i < querySnapshot.messages.length; i++) {
//       var a = querySnapshot.messages[i];
//       print(a.documentID);
//     }
// }

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
  findUserPosition(List user) {
    for (int t = 0; t < user.length; t++) {
      if (user[t] != loggedInUser.email.toString()) {
        return t;
      }
    }
  }

  var dataList;

  // nickNameGetter() async {
  //   QuerySnapshot querySnapshot = await _fireStore
  //       .collection('contact_details')
  //       .where('whose_contact', isEqualTo: loggedInUser.email.toString())
  //       .where('email', isEqualTo: otherUser.toString())
  //       .get();
  //   final allData = querySnapshot.docs.map((doc) {
  //     return doc.get('nickname');
  //   }).toList();
  //   if (allData != null || allData.isNotEmpty) {
  //     setState(() {
  //       dataList = allData.toList();
  //     });
  //   }
  //   nameToDisplay = dataList[0];
  //   print(dataList);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    theOtherUserFinder(widget.users);
    nameToDisplay=otherUser.toString();
  }

  theOtherUserFinder(List users) {
    for (var user in users) {
      if (user != loggedInUser.email.toString()) {
        otherUser = user;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: <Widget>[
          profilePictureWidget(otherUser, 20.0),
          IconButton(
              icon: const Icon(Icons.person_add_rounded),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddNewUnknownContact(otherUser.toString(), widget.chatRoomId)));
              }),
        ],
        title: nameToDisplay != ''
            ? Text(nameToDisplay)
            : const Text('not logged in user'),
        backgroundColor: const Color(0xFF4a148c),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: MyNewMessagesStream(
                toWhom: otherUser.toString(),
                chatroomId: widget.chatRoomId, theirPosition: findUserPosition(widget.users),
              ),
            ),
            Container(
              height: 50,
              color: Colors.grey,
              child: const Center(child: Text('Add contact to exchange images')),),
            MessageInputBox(
              isDarkMode: isDarkMode,
              isFriend:false,
              // widget: ,
              chatRoomId: widget.chatRoomId,
              blockStatus: false,
              otherUser: otherUser,
              theirPosition: findUserPosition(widget.users), isFriendNumbers: 1,
            ),
          ],
        ),
      ),
    );
  }
}




class _MessageInputBoxState extends State<MessageInputBox> {
  TextEditingController messageTextController = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var userIndex;
  @override
  void initState(){
    super.initState();
    findSenderindex();

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
    final allSeenData = await docSnapshot.get('isSeen');
    final List allNameData = docSnapshot.get('users').toList();
    return allNameData.length;
  }
  findRecieverindex() async {
    int num = 0;
    DocumentSnapshot docSnapshot =
    await _fireStore.collection('chatRoom').doc(widget.chatRoomId).get();
    final allSeenData = await docSnapshot.get('isSeen').toList();
    final allNameData = docSnapshot.get('users').toList();
    if (allSeenData != null || allSeenData.isNotEmpty) {
      num = findUserPosition(allNameData);
      return num;
    }
  }
  findSenderPosition(List user) {
    for (int t = 0; t < user.length; t++) {
      if (user[t] != loggedInUser.email.toString()) {
        return t;
      }
    }
  }
  findSenderindex() async {
    int num = 0;
    DocumentSnapshot docSnapshot =
    await _fireStore.collection('chatRoom').doc(widget.chatRoomId).get();
    final allSeenData = await docSnapshot.get('isSeen').toList();
    final allNameData = docSnapshot.get('users').toList();
    if (allSeenData != null || allSeenData.isNotEmpty) {
      num = findUserPosition(allNameData);
      return num;
    }
  }
  inputDisabler() {
    if (widget.blockStatus == true) {
      return false;
    } else {
      return true;
    }
  }
  editReadStatus() async {
    int numb = await findRecieverindex();
    final docUser = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatRoomId);
    if (numb == 0) {
      docUser.update({
        'isSeen': [false, true],
      });
    } else if (numb == 1) {
      docUser.update({
        'isSeen': [true, false],
      });
    }
  }
  typingStatusUpdater() async {
    if(userIndex==0){
      FirebaseFirestore.instance.collection('chatRoom').doc(
          widget.chatRoomId).update(
          {"typingStatus": [true,false]});
      await Future.delayed(const Duration(milliseconds: 800));
      FirebaseFirestore.instance.collection('chatRoom').doc(
          widget.chatRoomId).update(
          {"typingStatus": [false,false]});
    }else{
      FirebaseFirestore.instance.collection('chatRoom').doc(
          widget.chatRoomId).update(
          {"typingStatus": [false,true]});
      await Future.delayed(const Duration(milliseconds: 800));
      FirebaseFirestore.instance.collection('chatRoom').doc(
          widget.chatRoomId).update(
          {"typingStatus": [false,false]});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, left: 10.0, right: 10.0),
      child: Container(
        decoration: widget.isDarkMode
            ? kMessageContainerDecorationDark
            : kMessageContainerDecorationlight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextButton(onPressed: (){}, child: const Icon(Icons.emoji_emotions)),
            Expanded(
              child: TextField(
                enabled: inputDisabler(),
                controller: messageTextController,
                onChanged: (value) {
                  typingStatusUpdater();
                  messageText = value;
                },
                decoration: kMessageTextFieldDecoration,
              ),
            ),
            TextButton(
              onPressed: () async {
                if (messageTextController.text != '' ||
                    messageTextController.text.isNotEmpty) {
                  await editReadStatus();
                  //for editing the isFriend to true
                  final timeUpdater = FirebaseFirestore.instance
                      .collection('chatRoom')
                      .doc(widget.chatRoomId.toString());
                  timeUpdater.update({'latestTime': DateTime.now()});


                  //new style with updated database style
                  final docMessage = FirebaseFirestore.instance
                      .collection('chatRoom')
                      .doc(widget.chatRoomId)
                      .collection('chats')
                      .doc();
                  final json = {
                    'id': docMessage.id,
                    'message': messageTextController.text,
                    'sender': loggedInUser.email,
                    'time': DateTime.now(),
                    'whoseContact': loggedInUser.email.toString(),
                    'seen': false
                  };
                  await docMessage.set(json);
                  messageTextController.clear();
                }
              },
              child: Icon(
                Icons.send,
                color: widget.isDarkMode
                    ? const Color(0xFF4a148c)
                    : const Color(0xFF4a148c),
              ),
            )
          ],
        ),
      ),
    );
  }

}
