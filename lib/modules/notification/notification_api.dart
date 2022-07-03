import 'package:awesome_notifications/awesome_notifications.dart';
// import 'dart:math';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class LocalNotificationService {
//   static final FlutterLocalNotificationsPlugin
//   _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   static void initialize() {
//     const InitializationSettings initializationSettings =
//     InitializationSettings(
//         android: AndroidInitializationSettings("@mipmap/ic_launcher"));
//     _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   static void display(RemoteMessage message) async {
//     try {
//       print("In Notification method");
//       // int id = DateTime.now().microsecondsSinceEpoch ~/1000000;
//       Random random = Random();
//       int id = random.nextInt(1000);
//       const NotificationDetails notificationDetails = NotificationDetails(
//           android: AndroidNotificationDetails(
//             "mychanel",
//             "my chanel",
//             importance: Importance.max,
//             priority: Priority.high,
//           ));
//       print("my id is ${id.toString()}");
//       await _flutterLocalNotificationsPlugin.show(
//         id,
//         message.notification!.title,
//         message.notification!.title,
//         notificationDetails,
//       );
//     } on Exception catch (e) {
//       print('Error>>>$e');
//     }
//   }
// }
//
//
// ignore: non_constant_identifier_names
void Notify() {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'key1',
        title: 'This is the title',
        body: 'This is the body',
        largeIcon: 'https://media.istockphoto.com/photos/patan-picture-id637696304?k=20&m=637696304&s=612x612&w=0&h=GqmMtggU2LgHWcXPFNxMrZg9dtPzyrnl9ek5oARcI7Y=',
        bigPicture:
        'https://media.istockphoto.com/photos/patan-picture-id637696304?k=20&m=637696304&s=612x612&w=0&h=GqmMtggU2LgHWcXPFNxMrZg9dtPzyrnl9ek5oARcI7Y=',
        notificationLayout: NotificationLayout.BigPicture,
      ));
}
