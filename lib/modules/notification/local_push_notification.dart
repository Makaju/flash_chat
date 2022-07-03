import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../constants/global_variables.dart';
import '../services/utils.dart';
class LocalNotificationService {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  User? user;
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static void initialize() {
    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  onRefresh(userCred) {
    user = userCred;
  }

  static void display(RemoteMessage message) async{
    print('this is the image link from notification ' + message.data['imageLink'].toString());

    if(FirebaseAuth.instance.currentUser!=null){
      try {
        // int id = DateTime.now().microsecondsSinceEpoch ~/1000000;
        Random random = Random();
        int id = random.nextInt(1000);
        String name = await nickNameGetter(message);
        String formtedName = name.replaceAll('.', '') + '.jpg';
        print('this is the notification message' + message.toString());
        //todo k garne yesma
        // String downloadURL= await Storage.downloadURL(formtedName);
        final largeIconPath = await Utils.downloadFile(
            'https://firebasestorage.googleapis.com/v0/b/flash-chat-6ccea.appspot.com/o/profile_pictures%2Fijees77shrestha%40gmailcom.jpg?alt=media&token=9f73ebd5-309f-4d8c-bea4-eab295d4172a',
            'largeIcon');
        final bigPicturePath = await Utils.downloadFile(
            'https://firebasestorage.googleapis.com/v0/b/flash-chat-6ccea.appspot.com/o/profile_pictures%2Fijees77shrestha%40gmailcom.jpg?alt=media&token=9f73ebd5-309f-4d8c-bea4-eab295d4172a',
            'bigPicture');


        final styleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicturePath),
          largeIcon: FilePathAndroidBitmap(largeIconPath),);
        NotificationDetails notificationDetails = NotificationDetails(
            android: AndroidNotificationDetails(
              "mychanel",
              "my chanel",
              importance: Importance.max,
              priority: Priority.high,
              styleInformation: styleInformation,
            )
        );
        await _flutterLocalNotificationsPlugin.show(
          id,
          message.notification!.title,
          message.notification!.body,

          notificationDetails,);
      } on Exception catch (e) {

      }
    }

  }


}
nickNameGetter(RemoteMessage message) async {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  List dataList = [];
  QuerySnapshot querySnapshot = await _fireStore
      .collection('contactDetails')
      .where('whoseContact', isEqualTo: loggedInUser.email.toString())
      .where('email', isEqualTo: message.notification!.title)
      .get();
  final allData = querySnapshot.docs.map((doc) {
    return doc.get('nickname');
  });
  if (allData != null || allData.isNotEmpty) {
    dataList = [allData];
  }
  return allData;
}