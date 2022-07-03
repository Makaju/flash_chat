import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/constants/global_variables.dart';
import 'package:flash_chat/screens/chat_screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../chat_screen/chat_screen_for_unknown.dart';
import '../profile_page/profile_page.dart';


class InboxContents extends StatefulWidget {
  InboxContents({
    Key? key,
    required this.name,
    required this.message,
    required this.id,
    required this.userList,
    required this.sender,
    required this.known,
    required this.time,
    required this.index,
    required this.readStatus,
    required this.type,
  }) : super(key: key);
  String name;
  String message;
  String id;
  List userList;
  String sender;
  bool known;
  Timestamp time;
  int index;
  bool readStatus;
  String type;

  @override
  State<InboxContents> createState() => _InboxContentsState();
}

class _InboxContentsState extends State<InboxContents> {
  bool isDarkModeDemo = false;
  bool demo = false;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    themeGetter();
    return GestureDetector(
      onTap: () async {
        editReadStatus();
        navigationFunction(widget.id.toString(), widget.userList);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    profilePictureWidget(
                        profileImageNameGetter().toString(), 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.known?widget.name:profileImageNameGetter(),
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontWeight: widget.readStatus ? FontWeight
                                        .normal : FontWeight.w900,
                                    fontSize: 20,color: Theme.of(context).primaryColor)),
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.sender ==
                                        loggedInUser.email.toString()
                                        ? 'You: '
                                        : '',
                                    style: GoogleFonts.lato(
                                        textStyle:
                                        TextStyle(
                                            fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                                  ),
                                  ConstrainedBox(
                                      constraints: BoxConstraints(
                                        // minWidth: ,
                                          maxWidth: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.57),
                                      child:widget.type=='image'?Text('Sent an image',style: TextStyle(color: Theme.of(context).primaryColor),):Text(widget.message,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              fontSize: 16,color: Theme.of(context).primaryColor),
                                          fontWeight: widget.readStatus
                                              ? FontWeight.normal
                                              : FontWeight.w900))),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Text(convertToAgo(timeCalculator(widget.time))),

              ],
            ),
          ),
        ),
      ),
    );
  }

  timeCalculator(Timestamp time) {
    var convertedToDate = time.toDate();
    return convertedToDate;
  }


  profileImageNameGetter() {
    for (var i in widget.userList) {
      if (i != loggedInUser.email.toString()) {
        return i;
      }
    }
  }

  navigationFunction(String id, List userList) {
    if (widget.known == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ChatScreen(
                    chatRoomId: id.toString(),
                    users: userList,
                  )));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ChatScreenForTheUnknown(
                    chatRoomId: id.toString(),
                    users: userList,
                  )));
    }
  }



  String convertToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays >= 1) {
      return '${diff.inDays}d';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours}h';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes}min';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds}sec';
    } else {
      return 'just now';
    }
  }

  themeGetter() {
    if (Theme.of(context).primaryColor==Colors.white) {
      isDarkModeDemo = true;
      return true;
    } else if (Theme.of(context).primaryColor!=Colors.white) {
      isDarkModeDemo = false;
      return false;
    }
  }

  findUserPosition(List user) {
    for (int t = 0; t < user.length; t++) {
      if (user[t] == loggedInUser.email.toString()) {
        return t;
      }
    }
  }

  findReceiverIndex() async {
    int num = 0;
    DocumentSnapshot docSnapshot =
    await _fireStore.collection('chatRoom').doc(widget.id).get();
    final allSeenData = await docSnapshot.get('isSeen').toList();
    final allNameData = docSnapshot.get('users').toList();
    if (allSeenData != null || allSeenData.isNotEmpty) {
      num = findUserPosition(allNameData);
      return num;
    }
  }

  editReadStatus() async {
    final docUser = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.id);
    docUser.update({
      'isSeen': [true, true],
    });
    // if(numb==1){
    //   docUser.set({
    //     'isSeen': {
    //       '1':true
    //
    //     },
    //   });
    // }else if(numb==0){
    //   docUser.update({
    //     'isSeen': {
    //       '0':true,
    //       '1':true
    //
    //     },
    //   });
    // }
  }


}
