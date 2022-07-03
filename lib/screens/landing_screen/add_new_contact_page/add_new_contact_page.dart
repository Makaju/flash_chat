import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants/constants.dart';
import 'package:flash_chat/screens/landing_screen/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddNewContact extends StatefulWidget {
  const AddNewContact({Key? key}) : super(key: key);

  @override
  State<AddNewContact> createState() => _AddNewContactState();
}

class _AddNewContactState extends State<AddNewContact> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  final newContactEmail = TextEditingController();
  final newContactNickname = TextEditingController();
  final newContactNumber = TextEditingController();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  List idList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //email
              Padding(
                padding: const EdgeInsets.only(
                    top: 160, left: 16, right: 16, bottom: 8),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      !.color)),
                        ),
                        TextField(
                            controller: newContactEmail,
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.left,
                            onChanged: (value) {
                              //Do something with the user input.
                            },
                            decoration: kLightTextField.copyWith(
                              contentPadding: const EdgeInsets.only(top: 16),
                              prefixIcon: const Icon(Icons.email),
                              hintText: 'Enter your Email',
                              hintStyle: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          ?.color
                                          ?.withOpacity(0.5))),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              //Nickname
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nickname',
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      ?.color)),
                        ),
                        TextField(
                            controller: newContactNickname,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.left,
                            onChanged: (value) {
                              //Do something with the user input.
                            },
                            decoration: kLightTextField.copyWith(
                              contentPadding: const EdgeInsets.only(top: 16),
                              prefixIcon: const Icon(Icons.person),
                              hintText: 'Enter Nickname',
                              hintStyle: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          ?.color
                                          ?.withOpacity(0.5))),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              //Contact number
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact number',
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      ?.color)),
                        ),
                        TextField(
                          controller: newContactNumber,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.left,
                          onChanged: (value) {
                            //Do something with the user input.
                          },
                          decoration: kLightTextField.copyWith(
                            contentPadding: const EdgeInsets.only(top: 16),
                            prefixIcon: const Icon(Icons.phone_android_sharp),
                            hintText: 'Enter Contact number',
                            hintStyle: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        ?.color
                                        ?.withOpacity(0.5))),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              //Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  width: 95,
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Material(
                    color: const Color(0xFF1a0c89),
                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () async {
                        //chat detector
                        //if chatroom cha bhane false lai true banaune natra do nothing


                        //todo continue from here
                        final docUser = FirebaseFirestore.instance
                            .collection('contactDetails')
                            .doc();
                        final json = {
                          'id': docUser.id,
                          'email': newContactEmail.text,
                          'nickname': newContactNickname.text,
                          'contact': newContactNumber.text,
                          'whoseContact': loggedInUser.email.toString(),
                        };
                        //condition here
                        checkContactSaved(newContactEmail.text, json, docUser);



                      },
                      // minWidth: 200.0,
                      height: 36.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }



  checkContactSaved(String newEmail, Map json, var docUser) async {
    bool contains= false;
    QuerySnapshot? querySnapshot = await _fireStore
        .collection('contactDetails')
        .where('whoseContact', isEqualTo: loggedInUser.email.toString())
        .get();
    final List allEmailList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    for(int i=0;  i<allEmailList.length;i++){
      if(allEmailList[i]['email']==newEmail){
        setState((){contains= true;});
      }
    }
    if(allEmailList.isEmpty||contains==false){
      return checkContactAvailability(newEmail,json,docUser);
    }else{
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
              content: Text('This Contact already exists in your contact list',
                style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.white)),
              )));
    }
  }

  checkContactAvailability(String newEmail, Map json, var docUser) async {
    QuerySnapshot? querySnapshot = await _fireStore
        .collection('userDetails')
        .where('email', isEqualTo: newEmail)
        .get();
    final allData = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    if (allData.isNotEmpty) {

      await docUser.set(json);
      messageTextController.clear();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LandingPage(
                screen: 0,
              )));
      isFriendStatusUpdater(newContactEmail.text);
}else{
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
              content: Text('Contact does not exist',
                style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.white)),
              )));
    }
  }



  Future<void> getUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        // String userEmail = loggedInUser.email.toString();

      }
    } catch (e) {
      log(e.toString());
    }
  }

  isFriendStatusUpdater(String email) async {
    List users = [loggedInUser.email.toString(), email];
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
    if(idList!=[]||idList.isNotEmpty){
      List newDataToAdd=[loggedInUser.email.toString()];
      final addToIsFriend = FirebaseFirestore.instance.collection('chatRoom').doc(
          idList.first.toString()).update(
          {"isFriend": FieldValue.arrayUnion(newDataToAdd)});
      final removeFromIsNotFriend = FirebaseFirestore.instance.collection('chatRoom').doc(
          idList.first.toString()).update(
          {"isNotFriend": FieldValue.arrayRemove(newDataToAdd)});


    }
  }


}
