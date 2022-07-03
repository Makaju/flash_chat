import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/modules/services/storage_services.dart';
import 'package:flash_chat/screens/landing_screen/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'inboc_container_for_both.dart';
import 'inbox_user_model.dart';

class Inbox extends StatefulWidget {
  const Inbox({Key? key}) : super(key: key);

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  late User loggedInUser;
  List friendList = [];
  List idList = [];
  List emailList = [];
  List<Widget> listOfWidgets = [];
  List chatroomUserList = [];
  final List<List<List>> _listOfSortedWidgets = [];
  List<List> listWithIndex = [];
  List<InboxUserModel> inboxUsersList = [];

  //map list is to stare massage
  final Storage storage = Storage();
  bool spinner = true;
  String? name;
  String? sender;
  String? type;
  String? message;
  List seenList = [];
  bool dataLoaded = false;
  String otherUser = '';
  late String variableID;
  List userList = [];
  bool isDarkModeDemo = false;
  var dateDate;
  int userPosition = 0;

  @override
  void initState() {
    super.initState();
    // NotificationAPIS.init();
    // listenNotification();
    getUser();
    showSpinner();
    getAllDocId().then((value) async {
      log('get all docs run--' + idList.toString());
      if (idList != [] || idList.isNotEmpty) {
        log('stimulis check');
        await loopTheDocId();
        //unawaited(toLoop());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int i = listOfWidgets.length;
    return SafeArea(
      child: Scaffold(
          body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: (emailList != [] && dataLoaded == true)
            ? SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 1,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: RefreshIndicator(
                          onRefresh: () {
                            return refresh();
                          },
                          child: ListView.builder(
                            reverse: false,
                            itemCount: inboxUsersList.length,
                            itemBuilder: (context, index) {
                              i--;
                              return InboxContents(
                                name: inboxUsersList[index].name,
                                message: inboxUsersList[index].message,
                                id: inboxUsersList[index].id,
                                userList: inboxUsersList[index].userList,
                                sender: inboxUsersList[index].sender,
                                known: inboxUsersList[index].known,
                                time: inboxUsersList[index].time,
                                index: index,
                                readStatus: inboxUsersList[index].readStatus,
                                type: inboxUsersList[index].type,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
      )),
    );
  }

  // void listenNotification() => NotificationAPIS.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => LandingPage(screen: 0)));

  Future getUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  getFriendsList() async {
    QuerySnapshot querySnapshot = await _fireStore
        .collection('contactDetails')
        .where('whoseContact', isEqualTo: loggedInUser.email)
        .get();
    final allData = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    if (allData != null || allData.isNotEmpty) {
      setState(() {
        friendList = allData.toList();
      });
    }
  }

  getEmailList() {
    for (int i = 0; i < friendList.length; i++) {
      final email = friendList[i]['email'];
      emailList.add(email);
      setState(() {});
    }
  }

  showSpinner() async {
    await getUser();
    setState(() {
      if (loggedInUser != null) {
        spinner = false;
      }
    });
  }

  getAllDocId() async {
    List comparelist = friendList;
    comparelist.add(loggedInUser.email.toString());
    QuerySnapshot querySnapshot = await _fireStore
        .collection('chatRoom')
        .where('isFriend', arrayContains: loggedInUser.email.toString())
        .orderBy('latestTime', descending: true)
        .get();
    final allData = querySnapshot.docs.map((doc) {
      return doc.get('id');
    }).toList();
    if (allData != null || allData.isNotEmpty) {
      setState(() {
        idList = allData.toList();
      });
    }
  }

  loopTheDocId() {
    log('vibe check');
    for (int i = 0; i < idList.length; i++) {
      FutureBuilder(
        future: newAddDataToInboxContainer(idList[i], i),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Container();
        },
      );
    }
    // for(j;j<idList.length;){
    //
    // }
    setState(() {
      dataLoaded = true;
    });
  }

  getUserList(String id) async {
    DocumentSnapshot docSnapshot =
        await _fireStore.collection('chatRoom').doc(id).get();
    final allData = docSnapshot.get('users').toList();
    if (allData != null || allData.isNotEmpty) {
      setState(() {
        userList = allData.toList();
      });
    }
    return userList;
  }

  findUserPositionForSeenStatus(List user) {
    for (int t = 0; t < user.length; t++) {
      if (user[t] != loggedInUser.email.toString()) {
        userPosition = t;
        return t;
      }
    }
  }

  findUserPosition(List user) {
    for (int t = 0; t < user.length; t++) {
      if (user[t] == loggedInUser.email.toString()) {
        userPosition = t;
        return t;
      }
    }
  }

  newAddDataToInboxContainer(String id, int i) async {
    getUserList(id).then((value) {
      findUserPosition(value);
    });
    log(id);
    log('id aayo??');
    int num = 0;
    setState(() {
      dataLoaded = false;
    });
    //chat leraucha
    QuerySnapshot querySnapshot = await _fireStore
        .collection('chatRoom')
        .doc(id)
        .collection('chats')
        .orderBy('time', descending: true)
        .get();
    final allData = querySnapshot.docs.map((doc) {
      return doc;
    }).toList();

//user leraucha
    DocumentSnapshot docSnapshot =
        await _fireStore.collection('chatRoom').doc(id).get();
    final allNameData = docSnapshot.get('users').toList();
    final allDateDate = docSnapshot.get('latestTime');
    final allSeenData = await docSnapshot.get('isSeen').toList();
    if ((allNameData != null || allNameData.isNotEmpty) &&
        (allDateDate != null || allDateDate.isNotEmpty) &&
        (allSeenData != null || allSeenData.isNotEmpty)) {
      num = findUserPositionForSeenStatus(allNameData);

      setState(() {
        chatroomUserList = allNameData.toList();
        dateDate = allDateDate;
        chatroomUserList.remove(loggedInUser.email.toString());
      });
    }

//mathi ko user bata email euta baki huncha tesko chai contact_details bata nickname leraucha
    QuerySnapshot querySnapshotNickname = await _fireStore
        .collection('contactDetails')
        .where('email', isEqualTo: chatroomUserList[0])
        .get();
    final allDataNickname = querySnapshotNickname.docs.map((doc) {
      return doc;
    }).toList();
    if ((allDataNickname != [] || allDataNickname.isNotEmpty) &&
        (allData != [] || allData.isNotEmpty) &&
        (dateDate != null)) {
      var nameToReturn = allDataNickname[0]['nickname'];
      name = nameToReturn.toString();
      sender = allData.first['sender'];
      type = allData.first['type'];
      message = allData.first['message'];
      seenList = allData.first['seen'];

      inboxUsersList.add(
        InboxUserModel(
            name: name.toString(),
            message: message.toString(),
            time: allDateDate,
            sender: sender.toString(),
            known: true,
            userList: allNameData,
            id: id,
            index: i,
            readStatus: allSeenData[num],
            type: type.toString()),
      );
      //List widgetList = ;
      setState(() {});
      // listWithIndex.add([i, listOfWidget]);
      _listOfSortedWidgets.add(listWithIndex);
      inboxUsersList.sort((a, b) => b.time.compareTo(a.time));
    }
  }

  Future<void> refresh() async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LandingPage(screen: 1),
        ));
  }
}
