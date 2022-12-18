import 'package:flutter/cupertino.dart';
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
import 'package:rosterinsight/screens/RegistrationScreen/RegisterationScreen.dart';
import 'package:rosterinsight/services/Api_Call_Service.dart';
import 'package:skeletons/skeletons.dart';

class SiteBookingScreen extends StatefulWidget {
  const SiteBookingScreen({super.key});

  @override
  State<SiteBookingScreen> createState() => _SiteBookingScreenState();
}

class _SiteBookingScreenState extends State<SiteBookingScreen> {
  bool isAllDataGet = false;
  List<Booking> subBooking = [];
  var mapofgrpList = Map();
  List<String> nameOfSite = [];
  List<List<Booking>> booking = [];
  List<Booking> filterSiteDetail = [];
  TextEditingController searchController = TextEditingController();
  String isConfirm = 'Unconfirm';

  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  String fromdate = '';
  List<Booking> filterEmployeeDetail = [];
  String todate = '';
  DateTime now = DateTime.now();
  DateTime fromDate = DateFormat('dd/MM/yyyy')
      .parse(DateFormat('dd/MM/yyyy').format(DateTime.now()));
  DateTime toDate = DateFormat('dd/MM/yyyy')
      .parse(DateFormat('dd/MM/yyyy').format(DateTime.now()));
  bool isFilter = false;
  List<Booking> searchList = [];
  void filterList(String value) {
    setState(() {
      if (value.isEmpty) {
        isFilter = false;
      } else {
        filterSiteDetail = [];
        searchList.forEach((element) {
          if (element.site!.toLowerCase().contains(value))
            filterSiteDetail.add(element);
        });
        isFilter = true;
      }
    });
  }

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
          todate = todate;

          fromdate = dateFormat.format(date);
        } else {
          fromdate = fromdate;
          todate = dateFormat.format(date);
        }
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  List<Booking> tEmployeeDetail = [];
  Future<List<Booking>> dateFilter(String from, String to) async {
    List<Booking> temployeeDetail = [];

    temployeeDetail = await ApiCall.apiForGetBooking(
        isSearchDateRange: true,
        fromDate:
            "${DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(from))}T00:00:00",
        toDate:
            "${DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(to))}T00:00:00");
    int dif = checkDateRange(from, to);
    tEmployeeDetail = temployeeDetail;
    print(dif);
    for (int i = 0; i < tEmployeeDetail.length; i++) {
      if ((checkDateRange(from, tEmployeeDetail[i].sdate!) >= 0 &&
              checkDateRange(tEmployeeDetail[i].sdate!, to) >= 0) &&
          dif >= 0) {
        Booking employeeBooking = Booking()
          ..site = tEmployeeDetail[i].site
          ..sdate = tEmployeeDetail[i].sdate
          ..startTime = tEmployeeDetail[i].startTime
          ..endTime = tEmployeeDetail[i].endTime;
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

  separateGrpName(List<Booking> tList) {
    tList.forEach((element) {
      if (!mapofgrpList.containsKey(element.site)) {
        mapofgrpList[element.site] = 1;
      } else {
        mapofgrpList[element.site] += 1;
      }
    });
    mapofgrpList.forEach(
      (key, value) {
        nameOfSite.add(key.toString());
      },
    );
    print(nameOfSite[0]);
  }

  int count = 0;
  makeListbyGrp(List<Booking> tList) {
    List<Booking> list = [];
    tList.forEach((element) {
      if (nameOfSite[count].toLowerCase() == element.site!.toLowerCase()) {
        list.add(element);
      }
    });
    booking.add(list);
    count++;
    if (nameOfSite.length > 1 && count < nameOfSite.length) {
      makeListbyGrp(tList);
    }
  }

  forSearching(List booking) {
    booking.forEach((element) {
      if (element.length > 1) {
        element.forEach((subelement) {
          searchList.add(subelement);
        });
      } else {
        searchList.add(element.first);
      }
    });
  }

  bool isLoading = true;
  preload({bool? isSearch, List<Booking>? list}) async {
    isSearch = isSearch ?? false;
    List<Booking> tList = [];

    if (!isSearch) {
      tList = await ApiCall.apiForGetBooking(isSearchDateRange: false);
    } else {
      tList = list!;
    }

    setState(() {
      fromdate =
          (DateFormat('dd/MM/yyyy').format(DateTime(now.year, now.month, 1)));

      todate = (DateFormat('dd/MM/yyyy')
          .format(DateTime(now.year, now.month + 1, 0)));
      if (tList.isNotEmpty) {
        separateGrpName(tList);
        makeListbyGrp(tList);
        forSearching(booking);
        print(booking);
        booking;
        isAllDataGet = true;
      }
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
    return Scaffold(
        appBar: AppBar(
          title: Text('Site Booking'),
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
                    Padding(
                      padding: const EdgeInsets.all(18.0),
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
                                    fromdate,
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
                                    todate,
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
                            onPressed: checkDateRange(fromdate, todate) < 0
                                ? null
                                : () async {
                                    filterEmployeeDetail = await dateFilter(
                                        fromdate.toString(), todate.toString());
                                    await preload(
                                        isSearch: true,
                                        list: filterEmployeeDetail);
                                    build(context);
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 25),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              flex: 2,
                              child: Text(
                                "Site",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
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
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "Job Time",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            filterList(value);
                          });
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 13, horizontal: 20),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            // borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          labelText: 'Search Site',
                          // labelStyle: TextStyle(color: etradeMainColor),
                          suffixIcon: Icon(
                            Icons.search,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    isFilter
                        ? Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                                children: List.generate(filterSiteDetail.length,
                                    ((subindex) {
                              Booking currentindexValue =
                                  filterSiteDetail[subindex];
                              return BookingCard(
                                  isNextBooking: false,
                                  employeeDetail: currentindexValue);
                            }))),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                                children:
                                    List.generate(nameOfSite.length, ((index) {
                              return ExpansionTile(
                                title: Text(
                                  nameOfSite[index],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                children: List.generate(booking[index].length,
                                    (subindex) {
                                  Booking currentindexValue =
                                      booking[index][subindex];
                                  return BookingCard(
                                      isNextBooking: false,
                                      employeeDetail: currentindexValue);
                                }),
                              );
                            }))),
                          ),
                  ],
                ),
              ));
  }
}
