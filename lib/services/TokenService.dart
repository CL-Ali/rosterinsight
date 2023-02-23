import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosterinsight/MainComponents/constant.dart';

class TokenApi {
  static requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted Permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional Permission');
    } else {
      print('User is Not granted ');
    }
  }

  static Future<String> getTokenMethode() async {
    try {
      var auth = AuthorizationStatus.authorized;
      print(auth);
      var messaging = FirebaseMessaging.instance;

      var token =
          // "ali";
          await messaging.getToken() ?? '';

      // Get.rawSnackbar(
      //   snackPosition: SnackPosition.TOP,
      //   isDismissible: true,
      //   snackStyle: SnackStyle.GROUNDED,
      //   message: token,
      //   // borderRadius: 10,
      //   // colorText: Colors.white,
      //   backgroundColor: successColor,
      //   icon: const Icon(Icons.add_alert),
      // );
      print(token);
      return token;
    } on FirebaseException catch (e) {
      print(e);

      Get.rawSnackbar(
        snackPosition: SnackPosition.TOP,
        isDismissible: true,
        snackStyle: SnackStyle.GROUNDED,
        message: e.toString(),
        // borderRadius: 10,
        // colorText: Colors.white,
        backgroundColor: failColor,
        icon: const Icon(Icons.add_alert),
      );
      return '';
    }
  }
}
