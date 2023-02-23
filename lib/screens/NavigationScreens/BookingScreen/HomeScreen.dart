import 'package:flutter/cupertino.dart';
import 'package:rosterinsight/MainComponents/sharePreferences.dart';
import 'package:rosterinsight/screens/NavigationScreens/MyNavigationScreen.dart';
import 'package:rosterinsight/services/Location_Service.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rosterinsight/MainComponents/BookingCard.dart';
import 'package:rosterinsight/MainComponents/constant.dart';
import 'package:rosterinsight/MainComponents/drawer.dart';
import 'package:rosterinsight/MainComponents/notify.dart';
import 'package:rosterinsight/Models/booking.dart';
import 'package:rosterinsight/main.dart';
import 'package:rosterinsight/screens/LoginScreen/LoginScreen.dart';
import 'package:rosterinsight/screens/NavigationScreens/BookingScreen/component/bookingDetailScreen.dart';
import 'package:rosterinsight/screens/RegistrationScreen/RegisterationScreen.dart';
import 'package:rosterinsight/services/Api_Call_Service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Booking> filterEmployeeDetail = [];
  bool isAllDataGet = false;
  List<Booking> booking = [];
  List<Booking> remainingList = [];
  String isConfirm = 'Unconfirm';
  DateTime now = DateTime.now();
  String fromDate = '';
  String toDate = '';
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

  Future<List<Booking>> dateFilter(String from, String to) async {
    List<Booking> temployeeDetail = [];

    int dif = checkDateRange(from, to);
    print(dif);
    for (int i = 0; i < remainingList.length; i++) {
      if ((checkDateRange(from, booking[i].sdate!) >= 0 &&
              checkDateRange(booking[i].sdate!, to) >= 0) &&
          dif >= 0) {
        Booking employeeBooking = Booking()
          ..site = remainingList[i].site
          ..sdate = remainingList[i].sdate
          ..startTime = remainingList[i].startTime
          ..endTime = remainingList[i].endTime;
        temployeeDetail.add(employeeBooking);
      }
    }

    setState(() {
      if (temployeeDetail.length > 1) {
        for (int j = 0; j < temployeeDetail.length - 1; j++) {
          for (int i = 0; i < temployeeDetail.length - 1; i++) {
            if (dateFormat
                .parse(temployeeDetail[i].sdate!)
                .isAfter(dateFormat.parse(temployeeDetail[i + 1].sdate!))) {
              Booking temp;
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
    booking = await ApiCall.apiForGetBooking(isSearchDateRange: false);
    if (booking.isNotEmpty) {
      setState(() {
        fromDate =
            (DateFormat('dd/MM/yyyy').format(DateTime(now.year, now.month, 1)));

        toDate = (DateFormat('dd/MM/yyyy')
            .format(DateTime(now.year, now.month + 1, 0)));
        booking;
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

// Define TextEditingController to get text from TextFields

// Function to show alert box with two text fields
  Future<bool> _showDialog(Booking booking) async {
    bool isLoading = false;
    TextEditingController _textFieldController1 = TextEditingController();
    TextEditingController _textFieldController2 = TextEditingController();
    bool isValidUser = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter your information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _textFieldController1,
                decoration: InputDecoration(
                  labelText: 'Site ID',
                ),
              ),
              TextField(
                controller: _textFieldController2,
                decoration: InputDecoration(
                  labelText: 'Employee Code',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Text('Submit'),
              onPressed: () async {
                // Do something with the text entered in the text fields
                // String _siteId = (_textFieldController1.text);
                setState(() {
                  isLoading = true;
                });
                int _siteId = int.parse(_textFieldController1.text);
                String employeecode = _textFieldController2.text;
                isValidUser = _siteId == booking.siteID &&
                    employeecode == UserSharePreferences.getEmployeeId();
                if (isValidUser) {
                  isValidUser = false;
                  double distance = 0;

                  await LocationApi.getCurrentLocation();

                  await LocationApi.getDestinationLocation(booking.postCode!);
                  distance = LocationApi.calculateDistance();
                  if (distance <= 200) {
                    isValidUser = true;
                  } else {
                    Get.rawSnackbar(
                      snackPosition: SnackPosition.TOP,
                      isDismissible: true,
                      snackStyle: SnackStyle.GROUNDED,
                      message: 'Please take your device in working area',
                      // borderRadius: 10,
                      // colorText: Colors.white,
                      backgroundColor: failColor,
                      icon: const Icon(Icons.add_alert),
                    );
                  }
                }
                setState(() {
                  isLoading = false;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return isValidUser;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    remainingList = [];
    if (booking.isNotEmpty) {
      for (int i = 1; i < booking.length; i++) {
        setState(() {
          remainingList.add(booking[i]);
        });
      }
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        drawer: const MyDrawer(),
        body: !isAllDataGet
            ? !isLoading && booking.isEmpty
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
                        'Next Booking',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // ignore: unrelated_type_equality_checks
                    booking.first.bookOnStts == 1 ||
                            booking.first.bookOnStts == 0
                        ? BookingCard(
                            isNextBooking: true,
                            employeeDetail: booking.first,
                            bookOnFunction: () async {
                              Booking currentBooking = booking.first;
                              bool isValid = await _showDialog(currentBooking);
                              if (isValid) {
                                String book =
                                    await ApiCall.apiForMarkOnBookingOnOff(
                                        bookOnStts:
                                            currentBooking.bookOnStts! + 1,
                                        bookingId: currentBooking.bookingId,
                                        startDate:
                                            '${DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(booking.first.sdate!))}T${booking.first.startTime}:00');

                                bool stts = await exceptionSnackBar(book);
                                if (stts) {
                                  // ignore: use_build_context_synchronously
                                  build(context);
                                }
                              }
                            })
                        : Container(),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Upcoming Bookings',
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
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                flex: 2,
                                child: Text(
                                  "Site",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      "Date",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "Job Time",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
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
                              Booking currentindexValue =
                                  filterEmployeeDetail[subindex];
                              return BookingCard(
                                isNextBooking: false,
                                employeeDetail: currentindexValue,
                              );
                            }))),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                                children: List.generate(
                                    booking.first.bookOnStts == 2
                                        ? booking.length
                                        : remainingList.length, ((subindex) {
                              Booking currentindexValue =
                                  booking.first.bookOnStts == 2
                                      ? booking[subindex]
                                      : remainingList[subindex];

                              return BookingCard(
                                isNextBooking: false,
                                employeeDetail: currentindexValue,
                              );
                            }))),
                          ),
                  ],
                ),
              ));
  }
}
