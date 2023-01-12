import 'dart:async';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) {
//     print("Native called background task");
//     return Future.value(true);
//   });
// }
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseOptions options = new FirebaseOptions(
  // apiKey: "AIzaSyA3kr-vML6MJFPHeVU4PMHdSIvOlMo2gEo",
  // appId: 'com.example.rosterinsight',
  // messagingSenderId: '382194111928',
  // projectId: 'rosterinsight-368605'
  // );
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  Notify.initialize(flutterLocalNotificationsPlugin);
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

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          // LocalNotificationService.display(message);
        }
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
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
