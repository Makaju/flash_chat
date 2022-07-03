import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/constants/global_variables.dart';
import 'package:flash_chat/modules/services/message_database.dart';
import 'package:flash_chat/screens/chat_screen/chat_screen.dart';
import 'package:flash_chat/screens/landing_screen/landing_page.dart';
import 'package:flash_chat/screens/landing_screen/profile_page/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_contact_popup.dart';

class ContactListWidgets extends StatefulWidget {
  final DocumentSnapshot document;

  const ContactListWidgets(this.document, {Key? key}) : super(key: key);

  @override
  State<ContactListWidgets> createState() => _ContactListWidgetsState();
}

class _ContactListWidgetsState extends State<ContactListWidgets> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeVariable();
    log("nick name " + widget.document['nickname']);
  }

  initializeVariable() {
    reciever = widget.document['email'];
    user = loggedInUser.email.toString();
    name = widget.document['nickname'];
    contact = widget.document['contact'];
    id = widget.document['id'];
  }

  getChatRoomDocId(List users) async {
    users.sort((a, b) => a.compareTo(b));
    QuerySnapshot querySnapshot = await _fireStore
        .collection('chatRoom')
        .where('users', isEqualTo: users)
        .orderBy('latestTime', descending: true)
        .get();
    final allData = querySnapshot.docs.map((doc) {
      return doc.get('id');
    }).toList();
    return allData.first;
  }

  deleteModuleOld() {
    getChatRoomDocId([loggedInUser.email.toString(), reciever])
        .then((value) async {
      DocumentSnapshot docSnapshot =
      await _fireStore.collection('chatRoom').doc(value).get();
      final List allisFriendData = docSnapshot.get('isFriend').toList();
      final List allisNotFriendData = docSnapshot.get('isNotFriend').toList();
      if (allisFriendData.length == 1 &&
          allisFriendData.contains(loggedInUser.email.toString())) {
        FirebaseFirestore.instance
            .collection('chatRoom')
            .doc(idList.first.toString())
            .update({
          "isFriend": FieldValue.arrayRemove([loggedInUser.email])
        });
      } else if (allisFriendData.isEmpty || allisFriendData == []) {
      } else if (allisFriendData.length > 1 &&
          allisFriendData.contains(loggedInUser.email.toString())) {
        //first get the isFriendField data
        allisFriendData.remove(loggedInUser.email.toString());
        FirebaseFirestore.instance
            .collection('chatRoom')
            .doc(idList.first.toString())
            .update({
          "isFriend": FieldValue.arrayRemove([loggedInUser.email])
        });
        //only modify the chatroom containts
        await FirebaseFirestore.instance
            .collection('chatRoom')
            .doc(value)
            .update({
          "isNotFriend": FieldValue.arrayUnion([loggedInUser.email.toString()])
        });
      }
    });
  }

  deleteModule() {
    getChatRoomDocId([loggedInUser.email.toString(), reciever])
        .then((value) async {
      if (value != null || value != [] || value.isNotEmpty || value != '') {
        DocumentSnapshot docSnapshot =
        await _fireStore.collection('chatRoom').doc(value).get();
        final List allisFriendData = docSnapshot.get('isFriend').toList();
        if (allisFriendData.contains(loggedInUser.email)) {
          //remove from isFriend
          await FirebaseFirestore.instance
              .collection('chatRoom')
              .doc(value)
              .update({
            "isFriend": FieldValue.arrayRemove([loggedInUser.email])
          });
          //add in isNotFriend
          await FirebaseFirestore.instance
              .collection('chatRoom')
              .doc(value)
              .update({
            "isNotFriend":
            FieldValue.arrayUnion([loggedInUser.email.toString()])
          });
        }
      }
    });
  }

  late String name;
  late String reciever;
  late String contact;
  late String id;
  late String user;
  bool isDarkModeDemo = false;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  List idList = [];
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  getDocId() async {
    List users = [user, reciever];
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
    if (idList.isEmpty || idList == []) {
      String newId = await _databaseMethods.createChatroom(
        user,
        reciever,
      );
      log(newId.toString());
      return newId.toString();
    } else {
      return idList[0];
    }
  }

  dialogBox(List users) {
    navigatorFunction(users);
    return Container(
      height: 50,
      width: 50,
      color: Colors.red,
      child: const Text('Loading'),
    );
  }

  navigatorFunction(List users) {
    getDocId().then((value) {
      log('check value ' + users.toString());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ChatScreen(chatRoomId: value.toString(), users: users)));
    });
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

//chatroom finder and creater
  var allData=null;

  findChatroom() async {
    //first search for existing chatroom
    List users = [loggedInUser.email.toString(), reciever];
    users.sort((a, b) => a.compareTo(b));
    log(users.toString());
    QuerySnapshot querySnapshot = await _fireStore
        .collection('chatRoom')
        .where('users', isEqualTo: users)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      allData = querySnapshot.docs.map((doc) {
        return doc.get('id');
      });
      return allData.first;
    } else {
      return null;
    }

    //if not found create a new one
  }

  List userList = [];

  createChatRoomOrNot(String? chatroomId) async {
    if (chatroomId == '' || chatroomId == null || chatroomId.isEmpty) {
      var newlist = await _databaseMethods.createChatroom(
          loggedInUser.email.toString(), reciever);
      return newlist;
      // return chatroomId;
    } else {
      DocumentSnapshot docSnapshot =
      await _fireStore.collection('chatRoom').doc(chatroomId).get();
      final allData = docSnapshot.get('users').toList();
      if (allData != null || allData.isNotEmpty) {
        setState(() {
          userList = allData.toList();
        });
      }
      List newList = userList;
      return newList;
    }
  }

  onpressFunction() {
    findChatroom().then((value) {
      createChatRoomOrNot(value).then((value) {
        navigatorFunction(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    themeGetter();
    initializeVariable();
    return GestureDetector(
      onTap: () {
        // _databaseMethods.updatedGetFriendList(loggedInUser.email.toString(), reciever);
        onpressFunction();
        // List users = [loggedInUser.email.toString(), email];
        // users.sort((a, b) => a.compareTo(b));
        // log([user, email].toString());
        // navigatorFunction(users);
        // dialogBox(users);
      },
      child: Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return EditContact(
                        contactNo: contact,
                        email: reciever,
                        nickname: name,
                        id: id,
                      );
                    });
              },
              icon: Icons.edit,
              backgroundColor: Colors.orange,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (context) async {
                log(id.toString());
                // deleteModule();
                // getChatRoomDocId([loggedInUser.email.toString(), reciever]);
               findChatroom().then((value) async {
                await FirebaseFirestore.instance
                     .collection('chatRoom')
                     .doc(value)
                     .update({
                   "isFriend": FieldValue.arrayRemove([loggedInUser.email])
                 });
                await FirebaseFirestore.instance
                     .collection('chatRoom')
                     .doc(value)
                     .update({
                   "isNotFriend": FieldValue.arrayUnion([loggedInUser.email])
                 });
               });
                final docUser = FirebaseFirestore.instance
                    .collection('contactDetails')
                    .doc(id);
                await docUser.delete();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LandingPage(screen: 0)));
              },
              icon: Icons.delete,
              backgroundColor: Colors.red,
              label: 'Delete',
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Material(
                borderRadius: BorderRadius.circular(10.0),
                color:Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return EditContact(
                                          contactNo: contact,
                                          email: reciever,
                                          nickname: name,
                                          id: id,
                                        );
                                      });
                                },
                                child: profilePictureWidget(
                                    reciever.toString(), 20.0)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,color: Theme.of(context).textTheme.headline1!.color)),
                                ),
                                Text(
                                  reciever,
                                  style: GoogleFonts.lato(

                                      textStyle: TextStyle(
                                          fontSize: 12, color: Theme.of(context).textTheme.headline1!.color)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // IconButton(
                      //     icon: Icon(Icons.edit),
                      //     onPressed: () {
                      //     }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget ContactListWidget(BuildContext context, DocumentSnapshot document) {
//   final name = document['nickname'];
//   final email = document['email'];
//
//   return
// }
