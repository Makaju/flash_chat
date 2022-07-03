
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flash_chat/constants/global_variables.dart';
import 'package:flash_chat/modules/services/database.dart';
import 'package:flash_chat/screens/welcome_screen/decision_tree.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'modules/notification/local_push_notification.dart';
import 'modules/services/storage_services.dart';
import 'modules/theme/theme_provider.dart';
import 'screens/landing_screen/profile_page/profile_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessageBackgroundHandler);
  SharedPreferences.getInstance().then((prefs) {
    var isDarkTheme = prefs.getBool("darkTheme") ?? false;
    return runApp(
      ChangeNotifierProvider<ThemeProvider>(
        child: const MyApp(),
        create: (BuildContext context) {
          return ThemeProvider(isDarkTheme);
        },
      ),
    );
  });
}
final Storage storage = Storage();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();

  }
assignlink()async{
  profileOfUserLink = await getImageUrl(loggedInUser.email.toString());
}
  @override
  Widget build(BuildContext context) {
    assignlink();
    return Consumer<ThemeProvider>(
      builder: (context, value, child) {
        return Sizer(builder: (context, orientation, deviceType) {
          return MaterialApp(
            title: 'Flash Chat',
            theme: value.getTheme(),
            home: const DecisionTree(),
          );
        });
      },
    );
  }
}

// Future<void> _firebasePushHandler (RemoteMessage message)async{
// print('this is the message'+ message.toString());
// // AwesomeNotifications().createNotificationFromJsonData(message.data);
// }
// Future<void> _firebaseHandleBackgroundMessanging (RemoteMessage message)async{
//   print('this is the message'+ message.toString());
//   // AwesomeNotifications().createNotificationFromJsonData(message.data);
// }


Future<void> _firebaseMessageBackgroundHandler(RemoteMessage message) async {
  //on click listner
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => LandingPage(screen: 1)
  //             // LandingPage(
  //             //   screen: 1,
  //             // )
  //             ));
}



