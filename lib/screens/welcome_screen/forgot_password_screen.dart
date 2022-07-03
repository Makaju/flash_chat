import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants/constants.dart';
import 'package:flash_chat/modules/buttons/welcome_screen_buttons.dart';
import 'package:flash_chat/screens/registration_screen/registration_screen.dart';
import 'package:flash_chat/screens/welcome_screen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    super.dispose();
  }



  onRefresh(User userCred){

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image(
            image: const AssetImage(
              "images/welcome.jpg",
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //back button
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 30.sp,
                          ),
                          Text(
                            'Back',
                            style: TextStyle(color: Colors.white, fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //forgot password container
                  Padding(
                    padding: EdgeInsets.only(top: 13.h),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.h),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(16)),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1.5.h, vertical: 2.h),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 1.h),
                                    child: Image(
                                      image: const AssetImage('images/lock.png'),
                                      height: 20.h,
                                      width: 20.h,
                                    ),
                                  ),
                                  Text(
                                    'Trouble Logging in?',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  const Text(
                                    'Enter your email and we will send you a link to get back into your account.',
                                    textAlign: TextAlign.center,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1.0.h, horizontal: 1.h),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.4),
                                          borderRadius: BorderRadius.circular(15.0)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 2.h),
                                        child: TextField(
                                          controller: emailController,
                                          textAlign: TextAlign.center,
                                          onChanged: (value) {
                                            //Do something with the user input.
                                          },
                                          decoration: kLightTextField.copyWith(
                                              hintText: 'Enter your Email',
                                              hintStyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .headline1
                                                      ?.color
                                                      ?.withOpacity(0.5))),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 1.5.h),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Material(
                                          color: const Color(0xFF4a148c),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15.0)),
                                          elevation: 5.0,
                                          child: MaterialButton(
                                            child: Text(
                                              'Reset Password',
                                              style:
                                              TextStyle(color: Colors.white,fontSize: 12.sp),
                                            ),
                                            onPressed: () {
                                              restPassword();
                                            },
                                          ),
                                        ),
                                        Column(
                                          children:[
                                            SizedBox(
                                                height: 1.9.h,
                                                child: const VerticalDivider(
                                                  thickness: 2,
                                                  color: Colors.grey,
                                                )),
                                            Text('OR',style: TextStyle(color: Theme.of(context).primaryColor), ),
                                            const SizedBox(
                                                height: 16,
                                                child: VerticalDivider(
                                                  thickness: 2,
                                                  color: Colors.grey,
                                                )),
                                          ],
                                        ),
                                        TextButtonForSignIn(
                                            option: 'Create New Account',
                                            screen: const RegistrationScreen()),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2.5.h),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.15,
                                        ),
                                        const Text('Know your password?'),
                                        TextButtonForSignIn(
                                            option: 'Login',
                                            screen: WelcomeScreen(onSignin: (userCred) => onRefresh(userCred))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future restPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      const SnackBar(content: Text('Password Reset Email Sent'));
      const snackBar =
      SnackBar(content: Text('The reset link has been sent to your email'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.message.toString();
      final snackBar = SnackBar(content: Text(errorMessage));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
