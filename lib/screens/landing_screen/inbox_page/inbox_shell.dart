
import 'package:flutter/material.dart';

import 'inbox.dart';
import 'inbox_from_unknown_senders.dart';

class InboxShell extends StatefulWidget {
  const InboxShell({Key? key}) : super(key: key);

  @override
  State<InboxShell> createState() => _InboxShellState();
}

class _InboxShellState extends State<InboxShell> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50.0),
              child:
              AppBar(
                backgroundColor: Colors.transparent,elevation: 0.0,
                automaticallyImplyLeading: false,
                centerTitle: false,
                bottom: TabBar(
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.white,
                  indicatorColor: const Color(0xFF4a148c),
                  tabs: [
                    Tab(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xCA4a148c),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 48),
                          child: Text('Inbox'),
                        ),
                      ),

                      // icon: Icon(Icons.person_add_alt_1),
                    ),
                    Tab(

                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xCA4a148c),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 48),
                          child: Text('Reqests'),
                        ),
                      ),
                      // icon: Icon(Icons.person_add_alt_1),
                    ),
                  ],
                ),
              ),
            ),
            body: const TabBarView(
              children: [
                Inbox(),
                MessageFromTheUnknown(),
              ],
            ),
          ),
        ));
  }
}
