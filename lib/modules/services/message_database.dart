import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List emailList = [];
  bool isFriend = false;
  List isFriendList = [];
  bool newaa = false;
  List isNotFriendList = [];

  findUserPosition(List users) {
    for (int t = 0; t < users.length; t++) {
      if (users[t] != users.toString()) {
        return t;
      }
    }
  }

  createChatroom(String user, String receiver) async {
    isFriendList = [user];
    isNotFriendList = [];
    List users = [user, receiver];
    users.sort((a, b) => a.compareTo(b));
    // int userNumber=findUserPosition(users);
    await updatedGetFriendList(user, receiver).then((value) async {
      if (value == true) {
        isFriendList.add(receiver);
        isFriendList.sort((a, b) => a.compareTo(b));
      } else {
        isNotFriendList.add(receiver);
        isNotFriendList.sort((a, b) => a.compareTo(b));
      }
      final docChatroom =
      FirebaseFirestore.instance.collection('chatRoom').doc();
      final json = {
        'id': docChatroom.id,
        'users': users,
        'isFriend': isFriendList,
        'isNotFriend': isNotFriendList,
        'isSeen': [false, false],
        'blocked': false,
        'blockedBy': '',
        'typingStatus':[false,false],
      };
      await docChatroom.set(json);
    });
    return users;
  }



  getFriendsListOfReceiver(String receiver) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('contactDetails')
        .where('whoseContact', isEqualTo: receiver)
        .get();
    final allData = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    if (allData != null || allData.isNotEmpty) {
      // setState(() {
      var friendList = allData.toList();
      return friendList;
      // });
    }
  }

  checkFriendshipStatus(String user, String receiver) {
    getFriendsListOfReceiver(receiver).then((value) {
      for (int i = 0; i < value.length; i++) {
        final email = value[i]['email'];
        emailList.add(email);
      }
      if (emailList.contains(user)) {
        isFriend = true;
        newaa = true;
      } else {
        isFriend = false;
        newaa = false;
      }
    });
    return isFriend;
  }

  updatedGetFriendList(String user, String receiver) async {
    List emailList = [];
    QuerySnapshot querySnapshot = await _firestore
        .collection('contactDetails')
        .where('whoseContact', isEqualTo: receiver)
        .get();
    final allData = querySnapshot.docs.map((doc) {
      return doc;
    }).toList();

    for (int i = 0; i < allData.length; i++) {
      emailList.add(allData[i]['email']);
    }
    if (emailList.contains(user)) {
      isFriend = true;
      return true;
    } else {
      isFriend = false;
      return false;
    }
  }

  retrieveDocId(List users) async {
    // users.sort((a, b) => a.compareTo(b));
    var data = await _firestore
        .collection('chatRoom')
        .where('users', isEqualTo: users)
        .get();

    var id = data.docs;
    if (id == [] || id == null || id.isEmpty) {
      log('null returned');
      return null;
    } else if (id != [] || id != null || id.isNotEmpty) {
      log('helots$id');
      var docId = id.first['id'];
      return docId;
    }
  }
}
