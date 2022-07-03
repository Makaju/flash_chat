import 'dart:convert';
import 'dart:developer';
import 'package:flash_chat/modules/notification/local_push_notification.dart';
import 'package:flash_chat/modules/services/database.dart';
import 'package:flash_chat/screens/landing_screen/profile_page/profile_page.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../constants/global_variables.dart';
import 'add_new_contact_page/add_new_contact_page.dart';
import 'contacts_page/contact_list.dart';
import 'inbox_page/inbox_shell.dart';
import 'logout_dialog/logout_dialog.dart';

// ignore: must_be_immutable
class LandingPage extends StatefulWidget {
  LandingPage({Key? key, required this.screen}) : super(key: key);
  int screen;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late int index;
  bool spinner = true;

  final screens = [
    const ContactList(),
    const InboxShell(),
    const AddNewContact(),
    const Center(child: ProfilePage()),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storeNotificationToken();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
    index = widget.screen;
    getUser();
    getInfo();
    setState(() {});
    getUsersName;
  }

  sendNotification(String title, String token) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'message': title,
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
              'body': 'Someone sent a message'
            },
            'priority': 'high',
            'data': data,
            'to': token
          }));

      if (response.statusCode == 200) {
      } else {
      }
    } catch (e) {log(e.toString());}
  }

  storeNotificationToken() async {
    await FirebaseMessaging.instance.getToken().then((value) async {
      log(value.toString() + '  what are you doing');
      String docId = await getUsersIdFromUserDetails();
      bool addToken = await containsIdOrNotInUserDetails(value.toString());
      if (addToken) {
        log('doc ID' + docId + '   ' + addToken.toString());
        final docUser = FirebaseFirestore.instance
            .collection('userDetails')
            .doc(docId)
            .update({
          "token": FieldValue.arrayUnion([value])
        });
      }
    });
  }

  getInfo() async {
    await getUser();
    setState(() {
      spinner = false;
    });
  }

  String titleReturner() {
    if (index == 0) {
      return 'Contacts';
    } else if (index == 1) {
      return 'Inbox';
    } else if (index == 3) {
      return '';
    } else {
      return 'Add new contact';
    }
  }

  Widget titleReturnerCheck() {
    if (titleReturner() != '' && titleReturner() != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 16, bottom: 24, top: 16),
        child: Text(
          titleReturner().toString(),
          style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
              textStyle: TextStyle(
                  color: Theme.of(context).textTheme.headline1?.color)),
        ),
      );
    } else {
      return Container();
    }
  }

  Future<bool?> logoutPopup(BuildContext context) async {
    showDialog<bool>(
        context: context,
        builder: (context) {
          return const LogoutDialog();
          //const ChangePasswordPopUp();
        });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await logoutPopup(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        endDrawerEnableOpenDragGesture: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleReturnerCheck(),
              Expanded(
                  child: Container(
                    child: screens[index],
                  )),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              indicatorColor: Colors.purple.shade300.withOpacity(0.4),
              labelTextStyle: MaterialStateProperty.all(
                  TextStyle(fontSize: 14, fontWeight: FontWeight.w500,color: Theme.of(context).primaryColor))),
          child: NavigationBar(
            // labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            selectedIndex: index,
            height: 60,
            onDestinationSelected: (index) => setState(() {
              this.index = index;
            }),
            destinations: [
              NavigationDestination(
                  icon: Icon(
                    Icons.group_outlined,
                    size: index == 0 ? 32 : 24,
                  ),
                  label: 'Contacts'),
              NavigationDestination(
                  icon: Icon(
                    Icons.email_outlined,
                    size: index == 1 ? 32 : 24,
                  ),
                  label: 'Inbox'),
              NavigationDestination(
                  icon: Icon(
                    Icons.person_add_outlined,
                    size: index == 2 ? 32 : 24,
                  ),
                  label: 'Add New'),
              NavigationDestination(
                  icon: index == 3
                      ? Icon(
                    Icons.account_circle,
                    size: index == 2 ? 32 : 24,
                  )
                      : CircleAvatar(
                      radius: index == 3 ? 20 : 16,
                      child: newProfilePictureWidget(
                          index == 3 ? 28 : 16)),
                  label: 'Me')
            ],
          ),
        ),
      ),
    );
  }
}
