import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class TextButtonForSignIn extends StatelessWidget {
  TextButtonForSignIn({Key? key,required this.option, required this.screen}) : super(key: key);
  String option;
  // ignore: prefer_typing_uninitialized_variables
  final screen;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          if(screen!=null){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => screen));
          }
        },
        child: Text(
          option,
          style: TextStyle(fontSize: 11.sp,
              color: Theme.of(context).colorScheme.primary),
        ));
  }
}

