import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rosterinsight/MainComponents/BookingCard.dart';
import 'package:rosterinsight/MainComponents/HolidayCard.dart';
import 'package:rosterinsight/Models/holiday.dart';
import 'package:rosterinsight/screens/NavigationScreens/MyNavigationScreen.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rosterinsight/MainComponents/constant.dart';
import 'package:rosterinsight/MainComponents/drawer.dart';
import 'package:rosterinsight/MainComponents/notify.dart';
import 'package:rosterinsight/main.dart';
import 'package:rosterinsight/screens/LoginScreen/LoginScreen.dart';
import 'package:rosterinsight/screens/RegistrationScreen/RegisterationScreen.dart';
import 'package:rosterinsight/services/Api_Call_Service.dart';

class HolidayScreen extends StatefulWidget {
  const HolidayScreen({super.key});

  @override
  State<HolidayScreen> createState() => _HolidayScreenState();
}

class _HolidayScreenState extends State<HolidayScreen> {
  List<Holiday> filterEmployeeDetail = [];
  bool isAllDataGet = false;
  List<Holiday> holiday = [];
  List<Holiday> remainingList = [];
  String isConfirm = 'Unconfirm';
  DateTime now = DateTime.now();
  String fromDate = '';
  String toDate = '';
  bool isFirstTimeTry = true;
  bool isFilter = false;
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  void datePicker({double? height, bool? isStart}) {
    DatePicker.showDatePicker(context,
        theme: DatePickerTheme(
            // backgroundColor: primaryColor,
            containerHeight: height! / 2),
        showTitleActions: true,
        minTime: DateTime(2000, 3, 5),
        maxTime: DateTime(2030, 6, 7), onChanged: (date) {
      debugPrint('confirm $date');
    }, onConfirm: (date) {
      setState(() {
        if (isStart!) {
          toDate = toDate;

          fromDate = dateFormat.format(date);
        } else {
          fromDate = fromDate;
          toDate = dateFormat.format(date);
        }
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  int checkDateRange(String from, String to) {
    DateTime fromDate = dateFormat.parse(from);
    DateTime toDate = dateFormat.parse(to);
    int fDate = fromDate.millisecondsSinceEpoch;
    fDate = (fDate / 1000).round();
    int tDate = toDate.millisecondsSinceEpoch;
    tDate = (tDate / 1000).round();
    return tDate - fDate;
  }

  Future<List<Holiday>> dateFilter(String from, String to) async {
    List<Holiday> temployeeDetail = [];

    int dif = checkDateRange(from, to);
    print(dif);
    for (int i = 0; i < holiday.length - 1; i++) {
      if ((checkDateRange(from, holiday[i].sdate!) >= 0 &&
              checkDateRange(holiday[i].sdate!, to) >= 0) &&
          dif >= 0) {
        Holiday employeeholiday = Holiday()
          ..holidayId = holiday[i].holidayId
          ..holidayType = holiday[i].holidayType
          ..holidayTypeId = holiday[i].holidayTypeId
          ..narration = holiday[i].narration
          ..sdate = holiday[i].sdate
          ..startTime = holiday[i].startTime
          ..edate = holiday[i].edate
          ..rVersion = holiday[i].rVersion
          ..approvalStatus = holiday[i].approvalStatus
          ..endTime = holiday[i].endTime;
        temployeeDetail.add(employeeholiday);
      }
    }

    setState(() {
      if (temployeeDetail.length > 1) {
        for (int j = 0; j < temployeeDetail.length - 1; j++) {
          for (int i = 0; i < temployeeDetail.length - 1; i++) {
            if (dateFormat
                .parse(temployeeDetail[i].sdate!)
                .isAfter(dateFormat.parse(temployeeDetail[i + 1].sdate!))) {
              Holiday temp;
              temp = temployeeDetail[i];
              temployeeDetail[i] = temployeeDetail[i + 1];
              temployeeDetail[i + 1] = temp;
            }
          }
        }
      }
      isFilter = true;
    });
    return temployeeDetail;
  }

  bool isLoading = true;
  preload() async {
    holiday = await ApiCall.apiForGetHolidays();
    if (holiday.isNotEmpty) {
      setState(() {
        fromDate =
            (DateFormat('dd/MM/yyyy').format(DateTime(now.year, now.month, 1)));

        toDate = (DateFormat('dd/MM/yyyy')
            .format(DateTime(now.year, now.month + 1, 0)));
        holiday;
        isAllDataGet = true;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    preload();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    remainingList = [];
    if (holiday.isNotEmpty) {
      for (int i = 1; i < holiday.length; i++) {
        setState(() {
          remainingList.add(holiday[i]);
        });
      }
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Holiday'),
        ),
        drawer: const MyDrawer(),
        body: !isAllDataGet
            ? !isLoading && holiday.isEmpty
                ? Center(
                    child: Text('There is no Data.',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                        )),
                  )
                : SkeletonListView()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Holidays',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(children: [
                        Expanded(
                            flex: 3,
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    datePicker(height: height, isStart: true);
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(
                                    bottom:
                                        4, // This can be the space you need between text and underline
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                    color: textColor,
                                    width:
                                        1.0, // This would be the width of the underline
                                  ))),
                                  child: Text(
                                    fromDate,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ))),
                        Expanded(
                            flex: 3,
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    datePicker(height: height, isStart: false);
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(
                                    bottom:
                                        4, // This can be the space you need between text and underline
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                    color: textColor,
                                    width:
                                        1.0, // This would be the width of the underline
                                  ))),
                                  child: Text(
                                    toDate,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ))),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: checkDateRange(fromDate, toDate) < 0
                                ? null
                                : () async {
                                    filterEmployeeDetail = await dateFilter(
                                        fromDate.toString(), toDate.toString());
                                    setState(() {
                                      filterEmployeeDetail;
                                    });
                                  },
                            child: const Text(
                              'Fetch',
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white),
                            ),
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 8),
                        child: Row(children: [
                          const Expanded(
                            flex: 2,
                            child: Text(
                              "Holiday Type",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "Date",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: const Text(
                                      "Status",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Expanded(
                          //     flex: 1,
                          //     child: Container(
                          //       child: TextButton(
                          //         onPressed: () {
                          //           Notify.showBigTextNotification(
                          //               title: "Check Call",
                          //               body: "Tap the Notification",
                          //               fln: flutterLocalNotificationsPlugin);
                          //         },
                          //         child: Text('Show Notification'),
                          //       ),
                          //     )),
                        ]),
                      ),
                    ),
                    isFilter
                        ? Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                                children: List.generate(
                                    filterEmployeeDetail.length, ((subindex) {
                              Holiday currentindexValue =
                                  filterEmployeeDetail[subindex];
                              return HolidayCard(
                                holidayDetail: currentindexValue,
                              );
                            }))),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                                children:
                                    List.generate(holiday.length, ((subindex) {
                              Holiday holidayDetail = holiday[subindex];

                              return Slidable(
                                  key: UniqueKey(),
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: ((subContext) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyNavigationScreen(
                                                        index: 3,
                                                        isEditHoliday: true,
                                                        editHolidayData:
                                                            holidayDetail,
                                                      )));
                                        }),
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        icon: Icons.edit,
                                        label: 'Edit',
                                      ),
                                      SlidableAction(
                                        onPressed: ((subContext) async {
                                          String msg =
                                              await ApiCall.apiForDeleteHoliday(
                                                  holidayDetail,
                                                  isFirstTime: isFirstTimeTry);
                                          bool stts =
                                              await exceptionSnackBar(msg);
                                          if (stts) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            await preload();
                                          } else {
                                            setState(() {
                                              isFirstTimeTry = false;
                                            });
                                          }
                                        }),
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icons.edit,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child: HolidayCard(
                                    holidayDetail: holidayDetail,
                                  ));
                            }))),
                          ),
                  ],
                ),
              ));
  }
}
