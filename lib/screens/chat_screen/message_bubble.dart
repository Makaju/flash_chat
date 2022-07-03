import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/constants/global_variables.dart';
import 'package:flash_chat/modules/services/database.dart';
import 'package:flash_chat/modules/services/storage_services.dart';
import 'package:flutter/material.dart';

import 'view_image.dart';


final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
List nameList = [];

class MyNewMessagesStream extends StatefulWidget {
  const MyNewMessagesStream(
      {Key? key, required this.toWhom, required this.chatroomId, required this.theirPosition})
      : super(key: key);
  final String toWhom;
  final String chatroomId;
  final int theirPosition;

  @override
  State<MyNewMessagesStream> createState() => _MyNewMessagesStreamState();
}

class _MyNewMessagesStreamState extends State<MyNewMessagesStream> {
  bool isDarkModeDemo = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    setState(() {
      getListOfContactDetails();
    });
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    themeGetter(context);
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection('chatRoom')
          .doc(widget.chatroomId)
          .collection('chats')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final messages = snapshot.data!.docs.toList();
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.get("message");
          final messageSender = message.get('sender');
          final seenList = message.get('seen');
          final chatId = message.get('id');
          final type = message.get('type');
          final seenStatus=seenList[widget.theirPosition];

          final currentUser = loggedInUser.email;
//todo this is to check and send messages related to current sender and reciever
          if (messageSender == loggedInUser.email.toString() ||
              messageSender == widget.toWhom) {
            if(messageText!=null||messageText!=''){
              final messageBubble = MessageBubble(
                sender: messageSender,
                texts: messageText,
                isMe: currentUser == messageSender,
                seen: seenStatus,
                id: chatId,
                chatroomID: widget.chatroomId,
                type: type,
              );
              messageBubbles.add(messageBubble);
            }
          }
        }
        return ListView(
          reverse: true,
          children: messageBubbles,
        );

      },
    );
  }

  Future<void> getListOfContactDetails() async {
    // await getUser();
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
    await _fireStore.collection('contactDetails').get();
    // Get data from docs and convert map to List
    setState(() {
      final allData = querySnapshot.docs.map((doc) {
        // if (doc["email"] == 'bananaman@apple.com') {
        // var key;
        // print("this is name: " + doc['nickname']);
        return doc.data();

        //}
      }).toList();
      if (allData != null || allData.isNotEmpty || allData != []) {
        setState(() {
          nameList = allData.toList();
        });

        // print('this is namelist: $nameList');
      }
    });

    //var filteredData = filter(allData);

    // print("hello i am get con list "+ filteredData.toString());
    //  print(nameList);
  }

  String messageReceivedFrom(messageSender) {
    String nickname = messageSender;

    // senderName=_fireStore.collection('contact_details').snapshots(),

    StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('contactDetails').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          nickname = messageSender;
        } else if (snapshot.hasData) {
          // log("hello i am else fn");
          final contacts = snapshot.data!.docs.toList();
          for (var contact in contacts) {
            final senderEmail = contact.get("email");
            final senderName = contact.get("nickname");
            if (senderEmail == messageSender) {
              nickname = senderName;
              // log("hello i am sender" + senderName);
            } else {
              nickname = messageSender;
            }
          }
        }

        return Container();
      },
    );

    return nickname;
  }
}

getNickname(String senderEmail, String myEmail) {
  String nicknametoreturn = senderEmail;
  // print("name list aako cha ki chaina $nameList");
  log(nameList.length.toString());
  if (nameList.isNotEmpty) {
    for (int i = 0; i < nameList.length; i++) {
      // print('this is inside getNickname ' + nameList[i]["email"]);
      //todo k milena milena

      log(nameList[i]['whoseContact'].toString());

      if (nameList[i]['whoseContact'] == myEmail &&
          nameList[i]['email'] == senderEmail) {
        nicknametoreturn = nameList[i]["nickname"];
        return nicknametoreturn;
        // return  nameList[i]["nickname"];
      }
    }
  }
  // print('nickname to return is: $nicknametoreturn');
  return nicknametoreturn;
}

class MessageBubble extends StatefulWidget {
  MessageBubble(
      {Key? key,
        required this.sender,
        required this.texts,
        required this.isMe,
        required this.seen,
        required this.id,
        required this.type,
        required this.chatroomID})
      : super(key: key);

  String sender;
  String texts;
  bool isMe;
  bool seen;
  String id;
  String chatroomID;
  String type;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  BorderRadius isSender = const BorderRadius.only(
      topLeft: Radius.circular(30.0),
      bottomLeft: Radius.circular(30.0),
      bottomRight: Radius.circular(30.0));

  BorderRadius isReceiver = const BorderRadius.only(
      topRight: Radius.circular(30.0),
      bottomLeft: Radius.circular(30.0),
      bottomRight: Radius.circular(30.0));

  bool isDarkMode=false;

  statusUpdater() {
    if (!widget.isMe) {
      final docUser = FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(widget.chatroomID)
          .collection('chats')
          .doc(widget.id);
      docUser.update({
        'seen': [true, true],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode=themeGetter(context);
    statusUpdater();
    senderCheck() {
      String senderEmail = widget.sender;
      if (widget.isMe == true) {
        return "Me";
      } else if (nameList != [] || nameList.isNotEmpty || nameList != null) {
        // print('this i return $nameList');
        return getNickname(senderEmail, loggedInUser.email.toString());
      }
    }

    if(widget.texts!=null||widget.texts!=''){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () async {
            await Storage().downloadURLForMessage(widget.texts);
          },
          child: Column(
            crossAxisAlignment:
            widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              //TODO bubble sender name or image
              if (widget.type == 'text')
                Column(
                  crossAxisAlignment:
                  widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      senderCheck(),
                      style: TextStyle(color:isDarkMode? Colors.white:Colors.black),
                    ),
                    // profilePictureWidget('sita@email.com', 10.0),
                    Row(
                      mainAxisAlignment:
                      widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        Material(
                          borderRadius: widget.isMe ? isSender : isReceiver,
                          elevation: 5.0,
                          color: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              border: !widget.isMe
                                  ? (themeGetter(context)
                                  ? Border.all(
                                  width: 1,
                                  color: Colors.grey.shade700,
                                  style: BorderStyle.solid)
                                  : null)
                                  : null,
                              borderRadius: widget.isMe ? isSender : isReceiver,
                              color: widget.isMe
                                  ? (themeGetter(context)
                                  ? Colors.grey.shade900
                                  : const Color(0xFF4a148c))
                                  : (themeGetter(context)
                                  ? Colors.transparent
                                  : Colors.white),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 10, right: 10.0, left: 10),
                                child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                        minHeight: 16, maxWidth: 300),
                                    child: Text(
                                      widget.texts,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color:
                                          widget.isMe? Colors.white : isDarkMode?Colors.white:Colors.black),
                                      maxLines: 3,
                                    ))),
                          ),
                        ),
                        SizedBox(
                            width: 12,
                            child: widget.isMe
                                ? Icon(
                              Icons.check,
                              size: 12,
                              color: (widget.seen ? Colors.green : Colors.grey),
                            )
                                : Container()),
                      ],
                    ),
                  ],
                )
              else
                SizedBox(
                  height: 250,
                    width: 250,
                    child:messagePictureWidget(widget.texts)
                )
            ],
          ),
        ),
      );
    }else {
      return Container();
    }
  }
  Widget messagePictureWidget(String messageId) {
    log('this is the message id'+messageId);
    String fileName= messageId + '.jpg';
    log('this is the file name'+fileName);

        return FutureBuilder(
          future: delayFunction(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return FutureBuilder(
              future: storage.downloadURLForMessage(fileName),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  log('is is what is is'+ snapshot.data.toString());
                  if(snapshot.hasData){
                    return  GestureDetector(
                      onTap: (){Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewImage(imageLink: snapshot.data.toString(),)
                            // LandingPage(
                            //   screen: 1,
                            // )
                          ));},
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                          fit:BoxFit.cover,
                          height: 250,
                          width: 250,
                          image:NetworkImage(snapshot.data.toString()),),
                      ),
                    );




                  }

                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Stack(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(color: Colors.grey,width: 250,height: 250)),
                      const Positioned(
                          top: 125, right: 100, child: CircularProgressIndicator()),
                    ],
                  );
                }
                if (snapshot.connectionState == ConnectionState.done &&
                    !snapshot.hasData) {
                  return Stack(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(color: Colors.grey,width: 250,height: 250)),
                      const Positioned(
                          top: 125, right: 100, child: CircularProgressIndicator()),
                    ],
                  );
                }
                return Container();
              },
            );
          },
        );



  }


 Future<String> delayFunction() async {
    await Future.delayed(const Duration(seconds: 2));
    return '00';

  }
}


