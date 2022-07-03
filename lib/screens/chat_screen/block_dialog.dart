import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/constants/global_variables.dart';
import 'package:flash_chat/screens/landing_screen/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class BlockDialog extends StatefulWidget {
  BlockDialog(
      {Key? key, required this.chatRoomId, required this.blockStatus, required this.blockedBy})
      : super(key: key);
  String chatRoomId;
  bool blockStatus;
  String blockedBy;

  @override
  State<BlockDialog> createState() => _BlockDialogState();
}

class _BlockDialogState extends State<BlockDialog> {
  bool isDarkModeDemo = false;



  blockModule() {
    final docUser = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatRoomId.toString());
    docUser.update({
      'blocked': true,
      'blockedBy': loggedInUser.email.toString()
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LandingPage(screen: 1),
        ));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor:
        isDarkModeDemo ? Colors.grey.shade700 : Colors.grey.shade500,
        content: Text(
          'Succesfully blocked this user',
          style: GoogleFonts.lato(
              textStyle: TextStyle(
                  color: Theme.of(context).textTheme.headline1?.color)),
        )));
  }

  unBlockModule() {
    final docUser = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatRoomId.toString());
    docUser.update({
      'blocked': false
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LandingPage(screen: 1),
        ));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor:
        isDarkModeDemo ? Colors.grey.shade700 : Colors.grey.shade500,
        content: Text(
          'Succesfully unblocked this user',
          style: GoogleFonts.lato(
              textStyle: TextStyle(
                  color: Theme.of(context).textTheme.headline1?.color)),
        )));
  }

  @override
  Widget build(BuildContext context) {
    themeGetter(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40, top: 400),
          child: dialogBoxReturner(),
        ),
      ),
    );
  }

  dialogBoxReturner() {
    if (widget.blockStatus == false) {
      return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).dialogBackgroundColor,
            borderRadius: BorderRadius.circular(30.0)),
        child: SizedBox(
          height: 20.h,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Text('Are you sure to block this user?',
                    style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 15.sp,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold))),
                SizedBox(height: 4.h,),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.w, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                        color: Colors.green.shade500,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(15.0)),
                        elevation: 5.0,
                        child: MaterialButton(onPressed: () async {
                          blockModule();
                        },
                          child: Text('Yes', style: GoogleFonts.lato(
                              textStyle: const TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold)),),),
                      ),
                      Material(
                          color: Colors.red.shade500,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(15.0)),
                          elevation: 5.0,
                          child: MaterialButton(onPressed: () {
                            Navigator.pop(context, false);
                          }, child: Text('No', style: GoogleFonts.lato(
                              textStyle: const TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold))),)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      if (widget.blockedBy == loggedInUser.email.toString()) {
        return Container(
          decoration: BoxDecoration(
              color: isDarkModeDemo
                  ? Colors.grey.shade800
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(30.0)),
          child: SizedBox(
            height: 168,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Text('Unblock this user?', style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 24,
                          color: isDarkModeDemo ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold))),
                  const SizedBox(height: 26,),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 64, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Material(
                          color: Colors.green.shade500,
                          borderRadius: const BorderRadius.all(Radius.circular(
                              15.0)),
                          elevation: 5.0,
                          child: MaterialButton(onPressed: () async {
                            unBlockModule();
                          },
                            child: Text('Yes', style: GoogleFonts.lato(
                                textStyle: const TextStyle(color: Colors.white,
                                    fontWeight: FontWeight.bold)),),),
                        ),
                        Material(
                            color: Colors.red.shade500,
                            borderRadius: const BorderRadius.all(Radius
                                .circular(15.0)),
                            elevation: 5.0,
                            child: MaterialButton(onPressed: () {
                              Navigator.pop(context, false);
                            }, child: Text('No', style: GoogleFonts.lato(
                                textStyle: const TextStyle(color: Colors.white,
                                    fontWeight: FontWeight.bold))),)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      } else if (widget.blockedBy != loggedInUser.email.toString()) {
        return Container(
          decoration: BoxDecoration(
              color: isDarkModeDemo
                  ? Colors.grey.shade800
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(30.0)),
          child: SizedBox(
            height: 168,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Text('Please be paitient. You have been blocked.',
                      style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 24,
                          color: isDarkModeDemo ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold))),
                  const SizedBox(height: 26,),
                ],
              ),
            ),
          ),
        );
      }
    }
  }
}
