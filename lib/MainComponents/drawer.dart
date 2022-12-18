import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosterinsight/MainComponents/constant.dart';
import 'package:rosterinsight/MainComponents/sharePreferences.dart';
import 'package:rosterinsight/screens/LoginScreen/LoginScreen.dart';
import 'package:rosterinsight/screens/RegistrationScreen/RegisterationScreen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        DrawerHeader(
            child: Center(
          child: Text(
            'RosterInsight',
            style: TextStyle(fontSize: 28, color: textColor),
          ),
        )),
        // MaterialButton(
        //   onPressed: () {
        //     Get.to(LoginScreen());
        //   },
        //   child: Row(
        //     children: const [Icon(CupertinoIcons.person), Text(" login")],
        //   ),
        // ),
        MaterialButton(
          onPressed: () async {
            await UserSharePreferences.logoutEmployee();
            Get.to(RegisterationScreen());
          },
          child: Row(
            children: const [Icon(Icons.exit_to_app_sharp), Text(" Logout")],
          ),
        ),
      ],
    ));
  }
}
