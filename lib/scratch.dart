import 'package:flash_chat/modules/services/utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

void notificationApi(String? title, String? body) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  //set the settings
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const IOSInitializationSettings initializationSettingsIOS =
  IOSInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  //set it up for android
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_channel', 'High Importance Notification',
      description: 'this channel is for high importance notification',
      importance: Importance.max);

  //send a notification
  flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              channelDescription: channel.description)));
}

class NotificationAPIS {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    final largeIconPath = await Utils.downloadFile(
        'https://firebasestorage.googleapis.com/v0/b/flash-chat-6ccea.appspot.com/o/profile_pictures%2Fijees77shrestha%40gmailcom.jpg?alt=media&token=9f73ebd5-309f-4d8c-bea4-eab295d4172a',
        'largeIcon');
    final bigPicturePath = await Utils.downloadFile(
        'https://firebasestorage.googleapis.com/v0/b/flash-chat-6ccea.appspot.com/o/profile_pictures%2Fijees77shrestha%40gmailcom.jpg?alt=media&token=9f73ebd5-309f-4d8c-bea4-eab295d4172a',
        'bigPicture');

    final styleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      largeIcon: FilePathAndroidBitmap(largeIconPath),);
    return  NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        // channelDescription: 'channel description',
        importance: Importance.max,
        styleInformation: styleInformation,

      ),
      iOS: const IOSNotificationDetails(),
    );
  }

  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = IOSInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);
    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(id, title, body, await _notificationDetails(),
          payload: payload);
}

