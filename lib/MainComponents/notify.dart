import 'dart:async';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rosterinsight/main.dart';
import 'package:rxdart/rxdart.dart';

class Notify {
  static final onNotification = BehaviorSubject<String?>();
  static final String navigationActionId = 'id_3';
  static final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      {bool isScheduled = false}) async {
    var linuxInitialize =
        LinuxInitializationSettings(defaultActionName: 'test');
    var androidInitialize =
        new AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationsSettings = InitializationSettings(
      android: androidInitialize,
      linux: linuxInitialize,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        onNotification.add(notificationResponse.payload);
      },
    );
  }

  static Future showBigTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      playSound: true,
      // sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await fln.show(
      0,
      title,
      body,
      not,
    ); // var time = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));
    // await fln.periodicallyShow(
    //   0,
    //   title,
    //   body,
    //   RepeatInterval.everyMinute,
    //   not,
    //   androidAllowWhileIdle: true,
    // );
  }
}
