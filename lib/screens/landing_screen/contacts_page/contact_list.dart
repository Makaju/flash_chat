import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/constants/constants.dart';
import 'package:flash_chat/constants/global_variables.dart';
import 'package:flash_chat/modules/services/database.dart';
import 'package:flash_chat/screens/chat_screen/chat_screen.dart';
import 'package:flash_chat/screens/landing_screen/contacts_page/contact_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final TextEditingController _seaarchController = TextEditingController();
  bool spinner = true;
  List filteredContacts = [];
  Future? resultLoaded;
  List allContacts = [];
  bool isDarkModeDemo=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllData();
    _seaarchController.addListener(_onSearchChanged);
  }

  getAllData() async {
    await getUser();
    await getContacts();
    setState(() {
      spinner = false;
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

  _onSearchChanged() {
    // print(_seaarchController.text);
    setState(() {
      filteredContacts.clear();
    });
    setState(() {
      searchResultList();
    });
  }

  getContacts() async {
    var data = await _firestore
        .collection('contactDetails')
        .where('whoseContact', isEqualTo: loggedInUser.email.toString())
        .orderBy('nickname', descending: false)
        .get();
    setState(() {
      allContacts = data.docs;
    });
    searchResultList();
    // print('Hello there' + allContacts.toList().toString());
    return 'Complete';
  }

  searchResultList() {
    var showResults = [];
    setState(() {
      if (_seaarchController.text != '' || _seaarchController.text.isEmpty) {
        for (var contact in allContacts) {
          var nameCheck = contact['nickname'].toString().toLowerCase();
          // print(nameCheck);
          if (nameCheck.contains(_seaarchController.text.toLowerCase())) {
            // print('name check: '+contact[0]['nickname']);

            setState(() {
              showResults.add(contact);
            });
            // print('identify: ' + showResults[0].toString());
          }
        }
        // setState(() {
        //   contactList=[];
        //   contactList = showResults;
        // });
        // log(contactList.length.toString());
        // showResults=[];
      } else {
        setState(() {
          filteredContacts.clear();

          showResults = List.from(allContacts);
        });
      }
    });
    setState(() {
      filteredContacts = showResults;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    resultLoaded = getContacts();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _seaarchController.removeListener(_onSearchChanged);
    _seaarchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log(filteredContacts.length.toString());
    themeGetter();
    return SafeArea(
        child: Scaffold(
            body: ModalProgressHUD(
              inAsyncCall: spinner,
              child: (spinner == false)
                  ? Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 15.0, left: 10.0, right: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                            color:Theme.of(context).colorScheme.onSecondary.withOpacity(0.4),),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  controller: _seaarchController,
                                  onChanged: (value) {
                                    messageText = value;
                                    //Do something with the user input.
                                  },
                                  decoration: kMessageTextFieldDecoration
                                      .copyWith(hintText: 'Search Contact'),
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Icon(Icons.search),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: filteredContacts.length,
                            itemBuilder: (_, int index) {
                              log(index.toString());
                              return ContactListWidgets(
                                  filteredContacts[index]);
                            }),
                      ),

                    ],
                  ),
                ],
              )
                  : Container(),
            )));
  }
}


