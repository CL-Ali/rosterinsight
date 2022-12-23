import 'dart:async';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rosterinsight/MainComponents/constant.dart';
import 'package:rosterinsight/MainComponents/notify.dart';
import 'package:rosterinsight/MainComponents/sharePreferences.dart';
import 'package:rosterinsight/Models/booking.dart';
import 'package:rosterinsight/screens/LoginScreen/ChangePasswordScreen.dart';
import 'package:rosterinsight/screens/LoginScreen/LoginScreen.dart';
import 'package:rosterinsight/screens/NavigationScreens/MyNavigationScreen.dart';
import 'package:rosterinsight/screens/RegistrationScreen/RegisterationScreen.dart';
import 'package:rosterinsight/services/Api_Call_Service.dart';
// import 'package:workmanager/workmanager.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) {
//     print("Native called background task");
//     return Future.value(true);
//   });
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseOptions options = FirebaseOptions(
      apiKey: 'AIzaSyD3d6KrjBRcne-dUiwcMyDU7HPe1wbXvDE',
      appId: 'com.example.rosterinsight',
      messagingSenderId:
          '297702473904-gseobg5bgr9ndf40i5cfe3htdubg1fvv.apps.googleusercontent.com',
      projectId: 'rosterinsight');
  var firebase = await Firebase.initializeApp(
    options: options,
  );
  await UserSharePreferences.init();
  // Workmanager().initialize(
  //   callbackDispatcher,
  //   isInDebugMode: true,
  // );
  // Workmanager().registerPeriodicTask(
  //   "periodic-task-identifier",
  //   "simplePeriodicTask",
  //   frequency: Duration(minutes: 15),
  // );
  // Workmanager().registerOneOffTask("task-identifier", "simpleTask");
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    darkTheme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: primaryColor),
        primarySwatch: MyApp.generateMaterialColorFromColor(primaryColor)),
    theme: ThemeData(
        // appBarTheme: AppBarTheme(color: primaryColor),
        primarySwatch: MyApp.generateMaterialColorFromColor(primaryColor)),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static MaterialColor generateMaterialColorFromColor(Color color) {
    return MaterialColor(color.value, {
      50: Color.fromRGBO(color.red, color.green, color.blue, 0.1),
      100: Color.fromRGBO(color.red, color.green, color.blue, 0.2),
      200: Color.fromRGBO(color.red, color.green, color.blue, 0.3),
      300: Color.fromRGBO(color.red, color.green, color.blue, 0.4),
      400: Color.fromRGBO(color.red, color.green, color.blue, 0.5),
      500: Color.fromRGBO(color.red, color.green, color.blue, 0.6),
      600: Color.fromRGBO(color.red, color.green, color.blue, 0.7),
      700: Color.fromRGBO(color.red, color.green, color.blue, 0.8),
      800: Color.fromRGBO(color.red, color.green, color.blue, 0.9),
      900: Color.fromRGBO(color.red, color.green, color.blue, 1.0),
    });
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> preload() async {
    MyNavigationScreen.listOfHolidays = await ApiCall.apiForGetHolidayType();
  }

  @override
  void initState() {
    super.initState();
    // Notify.initialize(flutterLocalNotificationsPlugin);
    preload();
  }

  // void notificationTapBackground() =>
  //     Notify.onNotification.stream.listen(onClickNotification);
  // void onClickNotification(String? payload) => Navigator.push(
  //     context, MaterialPageRoute(builder: (context) => LoginScreen()));
  bool isLogin = UserSharePreferences.getLoginStts();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      darkTheme: ThemeData(
          appBarTheme: AppBarTheme(backgroundColor: primaryColor),
          primarySwatch: MyApp.generateMaterialColorFromColor(primaryColor)),
      theme: ThemeData(
          // appBarTheme: AppBarTheme(color: primaryColor),
          primarySwatch: MyApp.generateMaterialColorFromColor(primaryColor)),
      home: isLogin ? MyNavigationScreen() : LoginScreen(),
      // initialRoute: '/', onGenerateRoute: (settings) {
      //   switch (settings.name){
      //     case '/':
      //       return MaterialPageRoute(
      //           builder: (context) =>RegisterationScreen());

      //     case '/notification-page':
      //       return MaterialPageRoute(builder: (context) {
      //         return LoginScreen();
      //       });

      //     default:
      //       assert(false, 'Page ${settings.name} not found');
      //       return null;
      //   }
      // },
    );
  }
}

class Controller extends GetxController {
  var count = 0.obs;
  increment() => count++;
}
