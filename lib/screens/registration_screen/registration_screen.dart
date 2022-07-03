import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sizer/sizer.dart';
import '../../constants/constants.dart';
import 'login_screen.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  static const String id = 'registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool spinner = false;
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  //new
  final newPasswordController = TextEditingController();
  late String newPassword;
  final verrifyPasswordController = TextEditingController();
  bool passwordVisibility = true;
  bool passwordVisibilitys = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(
          image: const AssetImage(
            "images/welcome.jpg",
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(child: Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: const [
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 32,
                        ),
                        Text(
                          'Back',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.858,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(80))),
                    child: ModalProgressHUD(
                      inAsyncCall: spinner,
                      child: SingleChildScrollView(
                        // physics: NeverScrollableScrollPhysics(),
                          child: KeyboardVisibilityBuilder(builder:(context, isKeyboardVisible){
                            return SizedBox(
                              height:  isKeyboardVisible?125.h:98.h,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32,vertical: 60),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Register',style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.sp,
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline1
                                                ?.color)),),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 42),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.4),
                                            borderRadius:
                                            BorderRadius.circular(15.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Name',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .headline1
                                                        ?.color),
                                              ),
                                              TextField(
                                                controller: nameController,
                                                keyboardType:
                                                TextInputType.emailAddress,
                                                textAlign: TextAlign.left,
                                                decoration:
                                                kLightTextField.copyWith(
                                                    hintText: 'Enter your Name',
                                                    hintStyle: TextStyle(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .headline1
                                                            ?.color
                                                            ?.withOpacity(
                                                            0.5))),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.4),
                                            borderRadius:
                                            BorderRadius.circular(15.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Phone Number',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .headline1
                                                        ?.color),
                                              ),
                                              TextField(
                                                controller: phoneController,
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.left,
                                                decoration: kLightTextField.copyWith(
                                                    hintText:
                                                    'Enter your Phone Number',
                                                    hintStyle: TextStyle(
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
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.4),
                                            borderRadius:
                                            BorderRadius.circular(15.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
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
                                                        ?.color),
                                              ),
                                              TextField(
                                                controller: emailController,
                                                keyboardType:
                                                TextInputType.emailAddress,
                                                textAlign: TextAlign.left,
                                                decoration:
                                                kLightTextField.copyWith(
                                                    hintText:
                                                    'Enter your Email',
                                                    hintStyle: TextStyle(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .headline1
                                                            ?.color
                                                            ?.withOpacity(
                                                            0.5))),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.4),
                                            borderRadius:
                                            BorderRadius.circular(15.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Create A Password',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .headline1
                                                        ?.color),
                                              ),
                                              TextField(
                                                obscureText: passwordVisibilitys,
                                                controller: newPasswordController,
                                                onChanged: (value) {
                                                  newPassword = value;
                                                  //Do something with the user input.
                                                },
                                                decoration: kLightTextField
                                                    .copyWith(
                                                    hintText:
                                                    'Create A Password',
                                                    suffixIcon: IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            passwordVisibilitys =
                                                            !passwordVisibilitys;
                                                          });
                                                        },
                                                        icon: Icon(
                                                            passwordVisibilitys
                                                                ? Icons
                                                                .visibility
                                                                : Icons
                                                                .visibility_off)),
                                                    hintStyle: TextStyle(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .headline1
                                                            ?.color
                                                            ?.withOpacity(
                                                            0.5))),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.4),
                                            borderRadius:
                                            BorderRadius.circular(15.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Confirm Password',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .headline1
                                                        ?.color),
                                              ),
                                              TextFormField(
                                                obscureText: passwordVisibility,
                                                textAlign: TextAlign.left,
                                                autovalidateMode: AutovalidateMode
                                                    .onUserInteraction,
                                                controller:
                                                verrifyPasswordController,
                                                validator: (value) {
                                                  validateAction(value);
                                                  return null;
                                                },
                                                decoration:
                                                kLightTextField.copyWith(
                                                    hintText:
                                                    'Confirm Password',
                                                    errorMaxLines: 2,
                                                    suffixIcon: IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            passwordVisibility =
                                                            !passwordVisibility;
                                                          });
                                                        },
                                                        icon: Icon(
                                                            passwordVisibility
                                                                ? Icons
                                                                .visibility
                                                                : Icons
                                                                .visibility_off)),
                                                    errorStyle: const TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12,
                                                    ),
                                                    hintStyle: TextStyle(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .headline1
                                                            ?.color
                                                            ?.withOpacity(
                                                            0.5))),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [

                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: Container(
                                            width: 20.h,
                                            height: 6.h,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Material(
                                              color: const Color(0xFF1a0c89),
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(15.0)),
                                              elevation: 5.0,
                                              child: MaterialButton(
                                                onPressed: () async {
                                                  await onPressAction();
                                                  gotoLoginScreen();
                                                },
                                                // minWidth: 200.0,
                                                height: 36.0,
                                                child:  const Text('Register',style: TextStyle(color:Colors.white),),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                      ),
                    ),
                  ),
                ),
              ],
            ),),
          ),
        )
      ],
    );
  }

  onPressAction() async {
    setState(() {
      spinner = true;
    });
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: verrifyPasswordController.text);


      _firestore.collection('userDetails').add({
        'userName': nameController.text,
        'email': emailController.text,
        'phoneNo': phoneController.text,
        'token': null,
      });
      if (newUser != null) {
        // Navigator.pushNamed(context, LoginScreen.id);
      }
      setState(() {
        spinner = false;
      });
    } on FirebaseAuthException catch (error) {
      String errorMessage = error.message.toString();
      setState(() {
        spinner = false;
      });
      Fluttertoast.showToast(msg: errorMessage, gravity: ToastGravity.TOP);
    }
  }

  validateAction(value) {
    if (verrifyPasswordController.text == newPasswordController.text) {
      if (value == null || value.isEmpty || value.length < 6) {
        return 'please provide a password with more than 6 characters';
      } else {
        return null;
      }
    } else {
      return 'Password Does not match';
    }
  }



  gotoLoginScreen() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor:
        Theme.of(context).colorScheme.onSecondary,
        content: Text(
          'Please log in with your new account',
          style: GoogleFonts.lato(
              textStyle: TextStyle(
                  color: Theme.of(context).textTheme.headline1?.color)),
        )));
    onRefresh(FirebaseAuth.instance.currentUser);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginScreen(
              onSignin: (userCred) => onRefresh(userCred),
            )));
  }

  User? user;

  onRefresh(userCred) {
    setState(() {
      user = userCred;
    });
  }
}
