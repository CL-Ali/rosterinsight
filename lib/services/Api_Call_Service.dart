import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rosterinsight/MainComponents/sharePreferences.dart';

import 'package:rosterinsight/Models/booking.dart';
import 'package:rosterinsight/Models/holiday.dart';
import 'package:rosterinsight/screens/NavigationScreens/Holiday/entities/HolidayType.dart';

class ApiCall {
  static const String EMAIL = 'ahsanakram99@gmail.com';
  static const String PASSWORD = 'admin';
  static final data = {"email": EMAIL, "password": PASSWORD};
  static const String URL = 'https://www.dev.rosterinsight.com';

  static Future<String> apiForRegistration(
      {String? name, String? email, String? token, bool? isOtpSend}) async {
    http.Response response = await http.post(
      Uri.parse(
          'https://dev.rosterinsight.com/api/v1/MobileApp/otpAuthentication'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, Map>{
        "otpAuthentication": {
          "isUpdate": true,
          "isWebCall": true,
          "machineId": "",
          "entryFlag": 2,
          "menuId": 0,
          "menuItemId": 0,
          "name": name,
          "emailAddress": email,
          "tokenNo": token!
        }
      }),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return response.body;
    }
  }

  static Future<String> apiForChangePassword({
    String? password,
  }) async {
    String employeeId = UserSharePreferences.getEmployeeId();
    int businessId = UserSharePreferences.getBusinessId();
    String email = UserSharePreferences.getName();
    http.Response response = await http.post(
      Uri.parse(
          'https://dev.rosterinsight.com/api/v1/MobileApp/updatePassword'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, Map>{
        "login": {
          "isUpdate": true,
          "isWebCall": true,
          "machineId": "",
          "entryFlag": 2,
          "menuId": 0,
          "menuItemId": 0,
          "businessId": businessId,
          "employeeId": employeeId,
          "emailAddress": email,
          "password": password
        }
      }),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return response.body;
    }
  }

  static Future<String> apiForLogin({
    String? employeeId,
    int? businessId,
    String? password,
  }) async {
    String email = UserSharePreferences.getName();
    http.Response response = await http.post(
      Uri.parse('https://dev.rosterinsight.com/api/v1/MobileApp/validateUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, Map>{
        "login": {
          "isUpdate": true,
          "isWebCall": true,
          "machineId": "",
          "entryFlag": 2,
          "menuId": 0,
          "menuItemId": 0,
          "businessId": businessId,
          "employeeId": employeeId,
          "emailAddress": email,
          "password": password
        }
      }),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return response.body;
    }
  }

  static Future<List<Booking>> apiForGetBooking({
    required bool isSearchDateRange,
    String? fromDate,
    String? toDate,
  }) async {
    http.Response response = await http.post(
      Uri.parse('https://dev.rosterinsight.com/api/v1/MobileApp/getBookings'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: isSearchDateRange
          ? jsonEncode(<String, dynamic>{
              "isWebCall": true,
              "fromDate": fromDate,
              "toDate": toDate,
              "businessId": UserSharePreferences.getBusinessId(),
              "employeeId":
                  // "0002",
                  UserSharePreferences.getEmployeeId(),
              "searchInDateRange": true
            })
          : jsonEncode(<String, dynamic>{
              "isWebCall": true,
              "fromDate": null,
              "toDate": null,
              "businessId": UserSharePreferences.getBusinessId(),
              "employeeId":
                  //  "0002",
                  UserSharePreferences.getEmployeeId(),
              "searchInDateRange": false
            }),
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var data = body['mobileBooking'];
      List<Booking> list = await Booking().mapToList(data ?? []);
      return list;
    } else {
      return [Booking()..site = "Error found ,${response.statusCode} code"];
    }
  }

  static Future<String> apiForMarkOnBookingOnOff({
    String? startDate,
    int? bookOnStts,
    String? bookingId,
  }) async {
    http.Response response = await http.post(
        Uri.parse(
            'https://dev.rosterinsight.com/api/v1/MobileApp/markBookingOnOff'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "ids": bookingId,
          "bookOnOffStatus": bookOnStts,
          "startDate": startDate,
          "entryFlag": 2,
          "businessId": UserSharePreferences.getBusinessId(),
        }));

    if (response.statusCode == 200) {
      var body = response.body;
      return body;
    } else {
      return response.body;
    }
  }

///////
  ///
  ///
  ///
  ///             Holiday
  ///
  ///
  ///
  ///

  static Future<List<Holiday>> apiForGetHolidays() async {
    http.Response response = await http.get(
      Uri.parse(
          """https://dev.rosterinsight.com/api/v1/MobileApp/getHolidays?BusinessId=${UserSharePreferences.getBusinessId()}&EmployeeId=${UserSharePreferences.getEmployeeId()}"""),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var data = body['holidays'];
      List<Holiday> list = await Holiday().mapToList(data ?? []);
      return list;
    } else {
      return [
        Holiday()..holidayType = "Error found ,${response.statusCode} code"
      ];
    }
  }

  static Future<List<HolidayType>> apiForGetHolidayType() async {
    http.Response response = await http.get(
      Uri.parse(
          'https://dev.rosterinsight.com/api/v1/MobileApp/getholidayTypes'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Map body = jsonDecode(response.body);
      // Map<String, dynamic> holidayType = json.decode();
      List<HolidayType> listOfHolidayType = [];
      if (body.isNotEmpty) {
        body['holidayTypes'].forEach((element) {
          HolidayType holidayType = HolidayType()
            ..holidayId = element['holidayTypeId']
            ..holidayName = element['title'];
          listOfHolidayType.add(holidayType);
        });
      }
      // print(holidayType);
      return listOfHolidayType;
    } else {
      return [HolidayType(holidayName: " ${response.statusCode} ")];
    }
  }

  static Future<String> apiForCreateHoliday(Holiday holiday) async {
    http.Response response = await http.post(
        Uri.parse(
            'https://dev.rosterinsight.com/api/v1/MobileApp/createHoliday'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "holiday": {
            "isUpdate": false,
            "entryFlag": 2,
            "holidayId": 0,
            "fromDate": "${holiday.sdate}T00:00",
            "toDate": "${holiday.edate}T00:00",
            "businessId": UserSharePreferences.getBusinessId(),
            "narration": holiday.narration,
            "rVersion": null,
            "refHolidayType": {"holidayTypeId": holiday.holidayTypeId},
            "refEmployee": {
              "employeeId": UserSharePreferences.getEmployeeId(),
              "businessId": UserSharePreferences.getBusinessId()
            }
          }
        }));

    if (response.statusCode == 200) {
      var body = response.body;
      return body;
    } else {
      return response.body;
    }
  }

  static Future<String> apiForEditHoliday(Holiday holiday) async {
    http.Response response = await http.post(
        Uri.parse(
            'https://dev.rosterinsight.com/api/v1/MobileApp/updateHoliday'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "holiday": {
            "isUpdate": true,
            "entryFlag": 2,
            "holidayId": holiday.holidayId,
            "businessId": UserSharePreferences.getBusinessId(),
            "fromDate": "${holiday.sdate}T00:00",
            "toDate": "${holiday.edate}T00:00",
            "narration": holiday.narration,
            "rVersion": holiday.rVersion,
            "refHolidayType": {"holidayTypeId": holiday.holidayTypeId},
            "refEmployee": {
              "employeeId": UserSharePreferences.getEmployeeId(),
              "businessId": UserSharePreferences.getBusinessId()
            }
          }
        }));

    if (response.statusCode == 200) {
      var body = response.body;
      return body;
    } else {
      return response.body;
    }
  }

  static Future<String> apiForDeleteHoliday(Holiday holiday,
      {bool? isFirstTime}) async {
    if (isFirstTime!) {
      holiday.sdate = DateFormat('yyyy-MM-dd')
          .format(DateFormat('dd/MM/yyyy').parse((holiday.sdate!)));
      holiday.edate = DateFormat('yyyy-MM-dd')
          .format(DateFormat('dd/MM/yyyy').parse((holiday.edate!)));
    }

    http.Response response = await http.post(
        Uri.parse(
            'https://dev.rosterinsight.com/api/v1/MobileApp/deleteHoliday'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "holiday": {
            "isUpdate": true,
            "entryFlag": 2,
            "holidayId": holiday.holidayId,
            "businessId": UserSharePreferences.getBusinessId(),
            "fromDate": "${holiday.sdate}T00:00",
            "toDate": "${holiday.edate}T00:00",
            "narration": holiday.narration,
            "rVersion": holiday.rVersion,
            "refHolidayType": {"holidayTypeId": holiday.holidayTypeId},
            "refEmployee": {
              "employeeId": UserSharePreferences.getEmployeeId(),
              "businessId": UserSharePreferences.getBusinessId()
            }
          }
        }));

    if (response.statusCode == 200) {
      var body = response.body;
      return body;
    } else {
      return response.body;
    }
  }
}
