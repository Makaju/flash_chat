import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants/constants.dart';
import 'package:flash_chat/modules/buttons/welcome_screen_buttons.dart';
import 'package:flash_chat/modules/theme/theme_change_button.dart';
import 'package:flash_chat/screens/landing_screen/landing_page.dart';
import 'package:flash_chat/screens/registration_screen/registration_screen.dart';
import 'package:flash_chat/screens/welcome_screen/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sizer/sizer.dart';


// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  Function(User) onSignin;
  LoginScreen({Key? key, required this.onSignin}) : super(key: key);
  static const String id = 'welcome_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late String email;
  late String password;
  bool isDarkModeDemo = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool passwordVisibility = true;
  late AnimationController controller;
  late Animation anFirebaseAuthimation;
  late Animation animation;



  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: const Duration(seconds: 1),
          vsync: this,
        );
    controller.forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    controller.addListener(() {
      setState(() {});
    });
    animation.addListener(() {
      setState(() {});
    });
  }



  @override
  Widget build(BuildContext context) {
    themeGetter();
    return Stack(
      children: [
        Scaffold(
          backgroundColor: isDarkModeDemo ? Colors.black : Colors.purple.withOpacity(controller.value),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                height: 100.h,
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(top: 2.h, right: 1.6.h),
                          child: const ChangeThemeButtonWidget(),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Container(
                        height: 76.6.h,
                        decoration: BoxDecoration(
                            color: isDarkModeDemo
                                ? Colors.grey.shade900
                                : Colors.white,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(40),
                                topLeft: Radius.circular(40))),
                        child: ModalProgressHUD(
                          inAsyncCall: spinnerLogin,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.5.h),
                            child: SingleChildScrollView(
                                child: KeyboardVisibilityBuilder(builder:(context, isKeyboardVisible){
                                  return SizedBox(
                                    height:  isKeyboardVisible?95.h:70.h,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(right: 2.5.h),
                                              child: Image(
                                                image: const AssetImage('images/chat.png'),
                                                height: animation.value*100,
                                                width: 7.h,
                                              ),
                                            ),
                                            AnimatedTextKit(
                                              animatedTexts: [
                                                TypewriterAnimatedText(
                                                  'Flash Chat',
                                                  textStyle: TextStyle(
                                                    fontSize: 28.0.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  speed: const Duration(milliseconds: 20),
                                                ),
                                              ],

                                              totalRepeatCount: 4,
                                              pause: const Duration(milliseconds: 1000),
                                              displayFullTextOnTap: true,
                                              stopPauseOnTap: true,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 3.h,
                                        ),
                                        //Enter your email
                                        Container(
                                          decoration: BoxDecoration(
                                              color: isDarkModeDemo
                                                  ? Colors.grey.shade900
                                                  : const Color(0x22424242),
                                              borderRadius: BorderRadius.circular(15.0)),
                                          child: Padding(
                                            padding: EdgeInsets.all(1.5.h),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Email',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .headline1
                                                          ?.color,fontSize: 10.sp),
                                                ),
                                                TextField(
                                                  controller: emailController,
                                                  keyboardType:
                                                  TextInputType.emailAddress,
                                                  textAlign: TextAlign.left,
                                                  onChanged: (value) {
                                                    email = value;
                                                    //Do something with the user input.
                                                  },
                                                  decoration: kLightTextField.copyWith(
                                                      contentPadding:
                                                      EdgeInsets.only(top: 1.8.h),
                                                      prefixIcon: const Icon(Icons.email),
                                                      hintText: 'Enter your Email',
                                                      hintStyle: TextStyle(fontSize: 10.sp,
                                                          color: Theme.of(context)
                                                              .textTheme
                                                              .headline1
                                                              ?.color
                                                              ?.withOpacity(0.5))),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2.5.h,
                                        ),
                                        //Enter your password
                                        Container(
                                          decoration: BoxDecoration(
                                              color: isDarkModeDemo
                                                  ? Colors.grey.shade900
                                                  : const Color(0x22424242),
                                              borderRadius: BorderRadius.circular(15.0)),
                                          child: Padding(
                                            padding: EdgeInsets.all(1.5.h),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Password',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .headline1
                                                          ?.color,fontSize: 10.sp
                                                  ),
                                                ),
                                                TextFormField(
                                                  obscureText: passwordVisibility,
                                                  controller: passwordController,
                                                  textAlign: TextAlign.left,
                                                  onChanged: (value) {
                                                    password = value;
                                                    //Do something with the user input.
                                                  },
                                                  decoration: kLightTextField.copyWith(
                                                      contentPadding:
                                                      EdgeInsets.only(top: 1.6.h),
                                                      prefixIcon: const Icon(Icons.lock),
                                                      suffixIcon: IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              passwordVisibility =
                                                              !passwordVisibility;
                                                            });
                                                          },
                                                          icon: Icon(passwordVisibility
                                                              ? Icons.visibility
                                                              : Icons.visibility_off)),
                                                      hintText: 'Enter your Password',
                                                      hintStyle: TextStyle(fontSize: 10.sp,
                                                          color: Theme.of(context)
                                                              .textTheme
                                                              .headline1
                                                              ?.color
                                                              ?.withOpacity(0.5))),
                                                  autovalidateMode:
                                                  AutovalidateMode.onUserInteraction,
                                                  validator: (value) {
                                                    if (passwordController.text.length >
                                                        6) {
                                                      if (value == null ||
                                                          value.isEmpty ||
                                                          value.length < 6) {
                                                        return 'please provide a password with more than 6 characters';
                                                      } else {
                                                        return null;
                                                      }
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text('Login',style: TextStyle(fontSize: 12.sp),),
                                            loginButton(context),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        TextButtonForSignIn(
                                          option: 'Forgot Password',
                                          screen: const ForgotPasswordScreen(),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Not a registered user?',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .headline1
                                                      ?.color,fontSize: 10.sp),
                                            ),
                                            TextButtonForSignIn(
                                                option: 'Sign Up',
                                                screen: const RegistrationScreen())
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                })
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
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

  Future<void> signIn() async {
    try {
      UserCredential userCredential =  await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LandingPage(
                screen: 1,
              )));
      setState((){
        spinnerLogin=false;
      });



    } on FirebaseAuthException catch (error) {
      String errorMessage = error.message.toString();
      Fluttertoast.showToast(msg: errorMessage, gravity: ToastGravity.TOP);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: isDarkModeDemo
                  ? Colors.red.shade400
                  : Colors.red.shade900,
              content: Text(
                errorMessage,
                style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.white)),
              )));
      setState(() {
        spinnerLogin = false;
      });
    }
  }



  Padding loginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        width: 100,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Material(
          color: Theme
              .of(context)
              .primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          elevation: 5.0,
          child: MaterialButton(
            onPressed: () async {
              if (emailController.text == '' || passwordController.text == '') {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: isDarkModeDemo
                        ? Colors.grey.shade700
                        : Colors.grey.shade500,
                    content: Text(
                      'Please provide email and password',
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              color: Theme
                                  .of(context)
                                  .textTheme
                                  .headline1
                                  ?.color)),
                    )));
              } else {
                setState(() {
                  spinnerLogin = true;
                });
                signIn().then((value) async {
                  await FirebaseAuth.instance.currentUser?.sendEmailVerification();
                });

              }
            },
            // minWidth: 200.0,
            height: 36.0,
            child: const Icon(Icons.east, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
