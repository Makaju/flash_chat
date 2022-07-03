
import 'package:flash_chat/screens/landing_screen/landing_page.dart';
import 'package:flutter/material.dart';

class PleaseVerifyYourEmailPlease extends StatefulWidget {
  const PleaseVerifyYourEmailPlease({Key? key}) : super(key: key);

  @override
  State<PleaseVerifyYourEmailPlease> createState() => _PleaseVerifyYourEmailPleaseState();
}

class _PleaseVerifyYourEmailPleaseState extends State<PleaseVerifyYourEmailPlease> {
  @override
  void initState(){
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    delayAndNavigate(context);
    return const Scaffold(body: SafeArea(child: Text('please verify your email please'),),);
  }
}

delayAndNavigate(var context) async {
  await Future.delayed(const Duration(milliseconds: 1600));
  Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) =>LandingPage(screen: 1)));
}
