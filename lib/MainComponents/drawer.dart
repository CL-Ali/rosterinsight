import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:rosterinsight/screens/FaceDetection/FaceDetection.dart';
import 'package:rosterinsight/MainComponents/SignatureScreen.dart';
import 'package:rosterinsight/MainComponents/constant.dart';
import 'package:rosterinsight/MainComponents/sharePreferences.dart';
import 'package:rosterinsight/screens/LoginScreen/LoginScreen.dart';
import 'package:rosterinsight/screens/RegistrationScreen/RegisterationScreen.dart';
import 'package:rosterinsight/screens/voicecall/VideoCallScreen.dart';

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
            child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.topEnd,
              children: const [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey,
                ),
                Badge(
                  smallSize: 20,
                  backgroundColor: Colors.green,
                ),
                // CircleAvatar(
                //   radius: 10,
                //   backgroundColor: Colors.green,
                // ),
              ],
            ),
            Center(
              child: Text(
                UserSharePreferences.getName(),
                style: TextStyle(fontSize: 28, color: textColor),
              ),
            ),
            Center(
              child: Text(
                UserSharePreferences.getEmail(),
                style: TextStyle(fontSize: 15, color: textColor),
              ),
            ),
          ],
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
          onPressed: () {
            // Get.to(VoiceCallScreen());
          },
          child: Row(
            children: const [Icon(Icons.call), Text(" Voice Call")],
          ),
        ),
        MaterialButton(
          onPressed: () {
            // Get.to(FaceDetectionScreen());
          },
          child: Row(
            children: const [Icon(Icons.face), Text(" Face Detection")],
          ),
        ),
        MaterialButton(
          onPressed: () {
            Get.to(SignatureScreen());
          },
          child: Row(
            children: const [
              Icon(Icons.design_services_outlined),
              Text(" Signature ")
            ],
          ),
        ),
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
