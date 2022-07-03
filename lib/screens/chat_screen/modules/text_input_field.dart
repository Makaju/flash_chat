import 'dart:developer';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flash_chat/constants/constants.dart';
import 'package:flash_chat/modules/services/database.dart';
import '../../../constants/constants.dart';
import '../../../constants/global_variables.dart';
import '../../../modules/services/database.dart';
import '../chat_screen.dart';

class MessageInputBox extends StatefulWidget {
  final bool isDarkMode;
  // final ChatScreen widget;
  final String chatRoomId;
  bool isFriend;
  bool blockStatus;
  String otherUser;
  int theirPosition;
  int isFriendNumbers;

  MessageInputBox(
      {Key? key,

      required this.isDarkMode,
      // required this.widget,
        required this.isFriend,
      required this.chatRoomId,
      required this.blockStatus,
      required this.otherUser,
      required this.theirPosition, required this.isFriendNumbers})
      : super(key: key);

  @override
  State<MessageInputBox> createState() => _MessageInputBoxState();
}

class _MessageInputBoxState extends State<MessageInputBox> {
  TextEditingController messageTextController = TextEditingController();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  int recieverIndex = 0;
  var imagePicker;
  var _image;
  bool verified = false;
  List tokenList=[];


  @override
  void initState() {
    super.initState();
    findSenderindex();
    getUser();
    imagePicker = ImagePicker();
    findReceiverIndex();
    verified = loggedInUser.emailVerified;
  }

  verificationBox() {
    if (verified == false) {
      return Container(
        width: 100.h,
        height: 3.h,
        color: Colors.red,
        child: const Center(
            child: Text(
          'please verify your email to send message',
          style: TextStyle(color: Colors.white),
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0, left: 10.0, right: 10.0),
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.4),borderRadius: const BorderRadius.all(Radius.circular(15.0))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (widget.isFriendNumbers>1 && widget.blockStatus==false) TextButton(
                  onPressed: () async {
                    final String fileName = const Uuid().v1();
                    XFile image = await imagePicker.pickImage(
                        source: ImageSource.gallery);
                    //
                    final uploadLink = image.path;
                    // print('$_image');
                    storage
                        .uploadMessageFile(uploadLink.toString(), fileName)
                        .then((value) async {
                      setState(() {});
                      log('uploaded');
                      setState(() {
                        _image = File(image.path);
                      });
                      if (_image == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('No File Selected')));
                      } else if (_image != null) {
                        final docMessage = FirebaseFirestore.instance
                            .collection('chatRoom')
                            .doc(widget.chatRoomId)
                            .collection('chats')
                            .doc();
                        final json = {
                          'id': docMessage.id,
                          'message': fileName,
                          'sender': loggedInUser.email,
                          'time': DateTime.now(),
                          'whoseContact': loggedInUser.email.toString(),
                          'seen': seenStatusVariable(widget.theirPosition),
                          'type': 'image'
                        };
                        await Future.delayed(const Duration(milliseconds: 1600));
                        await docMessage.set(json);
                      }
                    });

                    // await Future.delayed(const Duration(milliseconds: 1600));
                    setState(() {

                    });
                  },
                  child: Icon(Icons.image,color: Theme.of(context).colorScheme.primary,),
                ) else TextButton(
                  onPressed: (){
                    Fluttertoast.showToast(msg: 'You need to be friends with each other to send images', gravity: ToastGravity.TOP);
                  },
                  child: const Icon(Icons.image,color: Colors.grey,),
                ),
                Expanded(
                  child: TextField(
                    style: TextStyle(color: Theme.of(context).primaryColor),
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
                    String name = 'dsa';
                    if (messageTextController.text != '' ||
                        messageTextController.text.isNotEmpty) {
                      nickNameGetter().then((value) {
                        if (value != null || value != '') {
                          name = value
                              .toString()
                              .substring(1, value.toString().length - 1);
                        }
                        tokenGetter(widget.otherUser).then((value) {
                          sendNotification(name,
                              messageTextController.text.toString(), value, 'gs://flash-chat-6ccea.appspot.com/profile_pictures/diwasx17@gmailcom.jpg');
                        });
                      });
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
                        'seen': seenStatusVariable(widget.theirPosition),
                        'type': 'text'
                      };
                      await docMessage.set(json);
                      messageTextController.clear();
                    }
                  },
                  child: Icon(
                    Icons.send,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  findUserPosition(List user) {
    for (int t = 0; t < user.length; t++) {
      if (user[t] == loggedInUser.email.toString()) {
        return t;
      }
    }
  }

  List seenStatusVariable(int position) {
    if (position == 0) {
      return [false, true];
    } else {
      return [true, false];
    }
  }

  findReceiverIndex() async {
    int num = 0;
    DocumentSnapshot docSnapshot =
        await _fireStore.collection('chatRoom').doc(widget.chatRoomId).get();
    final allSeenData = await docSnapshot.get('isSeen').toList();
    final allNameData = docSnapshot.get('users').toList();
    if (allNameData != null || allNameData.isNotEmpty) {
      num = findUserPosition(allNameData);
      recieverIndex = num;
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
    if (widget.blockStatus == true || verified == false) {
      return false;
    } else {
      return true;
    }
  }

  editReadStatus() async {
    int numb = await findReceiverIndex();
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
    findReceiverIndex().then((value) async {
      if (value == 0) {
        FirebaseFirestore.instance
            .collection('chatRoom')
            .doc(widget.chatRoomId)
            .update({
          "typingStatus": [true, false]
        });
        await Future.delayed(const Duration(milliseconds: 1600));
        FirebaseFirestore.instance
            .collection('chatRoom')
            .doc(widget.chatRoomId)
            .update({
          "typingStatus": [false, false]
        });
      } else {
        FirebaseFirestore.instance
            .collection('chatRoom')
            .doc(widget.chatRoomId)
            .update({
          "typingStatus": [false, true]
        });
        await Future.delayed(const Duration(milliseconds: 1600));
        FirebaseFirestore.instance
            .collection('chatRoom')
            .doc(widget.chatRoomId)
            .update({
          "typingStatus": [false, false]
        });
      }
    });
  }

  onEmojiClicked() async {
    await SystemChannels.textInput.invokeListMethod('TextInput.hide');
    await Future.delayed(const Duration(milliseconds: 100));
  }

  nickNameGetter() async {
    List dataList = [];
    QuerySnapshot querySnapshot = await _fireStore
        .collection('contactDetails')
        .where('whoseContact', isEqualTo: loggedInUser.email.toString())
        .where('email', isEqualTo: widget.otherUser.toString())
        .get();
    final allData = querySnapshot.docs.map((doc) {
      return doc.get('nickname');
    });
    if (allData != null || allData.isNotEmpty) {
      setState(() {
        dataList = [allData];
      });
    }
    return allData;
  }
  getSendersImageLink(){

  }

  sendNotification(String title, String message, List tokens, String linkOfPhoto) async {
    for(int i= 0; i<tokens.length;i++){
      String token=tokens[i].toString();
      final data = {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        'message': title,
        'imageLink': 'gs://flash-chat-6ccea.appspot.com/profile_pictures/diwasx17@gmailcom.jpg',
      };

      try {
        http.Response response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
              'key=AAAAL7Dka8s:APA91bHzD8zf-Yi2YJbf4b2JXVVLSkef2-GTezITsC-e4pfjH-AKzztztjPypqRwZPmiWtC37yi-2jW2SUJ_aoUpI-DdFIKJqQnTCfTEFNqf6UD61o0MaLalBCYYA_wOzR5tRG8Qfxle'
            },
            body: jsonEncode(<String, dynamic>{
              'notification': <String, dynamic>{
                'title': title,
                'body': message,

              },
              'priority': 'high',
              'data': data,
              'to': token
              // 'fP5U6zm7QgeEGDDLj8VMbD:APA91bGeAuiTdiPk4f44wXgbnUIy0Wu7Lcanl562EZWODBoeWN0zGE0eUZ8LeymAlPmdl3_8EgwrVB0-L7sY7nuBAEmeHcptfh2SHaAioqbWDyORZVvWXYE9Nv_0tD2UDYOO_a7l4WhZ'
            }));

        if (response.statusCode == 200) {
        } else {}
      } catch (e) {log(e.toString());}
    }
  }

  tokenGetter(String emailOfTheReceiver) async {
    List tokens = [];
    QuerySnapshot querySnapshotNickname = await FirebaseFirestore.instance
        .collection('userDetails')
        .where('email', isEqualTo: emailOfTheReceiver)
        .get();
    final allToken = querySnapshotNickname.docs.map((doc) {
      return doc;
    }).toList();
    if (allToken.isNotEmpty || allToken != []) {
      for (int i = 0; i < allToken.length; i++) {

        String temp =allToken[i]['token'].toString().replaceAll('[', '');
        String temp2 = temp.replaceAll(']', '');
        tokens.add(temp2);
      }
    }
    return tokens;
  }
}
