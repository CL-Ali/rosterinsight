import 'dart:convert';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

const primaryColor = Color(0xff594AE2);
const successColor = Color.fromARGB(255, 106, 194, 110);
const failColor = Color.fromARGB(255, 230, 98, 75);
final textColor = Colors.grey.shade600;
DateFormat dateFormat = DateFormat('dd/MM/yyyy');
void customNavigate(Widget widget, context) {
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => widget), (route) => false);
}

Future<bool> exceptionSnackBar(msg) async {
  var response = {};
  bool isSuccess = false;
  response = jsonDecode(msg);
  if (response.isNotEmpty) {
    if (response['success']) {
      Get.rawSnackbar(
        snackPosition: SnackPosition.TOP,
        isDismissible: true,
        snackStyle: SnackStyle.GROUNDED,
        message: response['message'],
        // borderRadius: 10,
        // colorText: Colors.white,
        backgroundColor: successColor,
        icon: const Icon(Icons.add_alert),
      );
      isSuccess = true;
    } else {
      Get.rawSnackbar(
        snackPosition: SnackPosition.TOP,
        isDismissible: true,
        snackStyle: SnackStyle.GROUNDED,
        message: response['error'] == null
            ? response['message']
            : response['error'][0].toString(),
        // borderRadius: 10,
        // colorText: Colors.white,
        backgroundColor: failColor,
        icon: const Icon(Icons.add_alert),
      );
    }
  }
  return isSuccess;
}

int checkDateAndTimeRange(String from, String to) {
  DateTime now = DateTime.now();
  if (from != 'Select Date' && to != 'Select Date') {
    DateTime fromDate = DateFormat('dd-MM-yyyy hh:mm').parse(
        DateFormat('dd-MM-yyyy hh:mm')
            .format(DateFormat('dd/MM/yyyy').parse(from)));
    // DateTime toDate = DateTime.parse(to);
    DateTime toDate = DateFormat('dd-MM-yyyy hh:mm').parse(
        DateFormat('dd-MM-yyyy hh:mm')
            .format(DateFormat('dd/MM/yyyy').parse(to)));

    int fDate = fromDate.millisecondsSinceEpoch;
    fDate = (fDate / 1000).round();
    int tDate = toDate.millisecondsSinceEpoch;
    tDate = (tDate / 1000).round();
    return tDate - fDate;
  }
  // DateTime fromDate = DateTime.parse(DateFormat('dd-MM-yyyy').parse(from));
  return -1;
}

int checkDateRange(String from, String to, {bool? isCreateHoliday}) {
  DateTime fromDate = dateFormat.parse(from);
  DateTime toDate = dateFormat.parse(to);
  int fDate = fromDate.millisecondsSinceEpoch;
  fDate = (fDate / 1000).round();
  int tDate = toDate.millisecondsSinceEpoch;
  tDate = (tDate / 1000).round();
  return tDate - fDate;
}
