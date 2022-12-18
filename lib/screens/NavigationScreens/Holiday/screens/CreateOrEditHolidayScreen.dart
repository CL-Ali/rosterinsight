import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';
import 'package:rosterinsight/MainComponents/constant.dart';
import 'package:rosterinsight/MainComponents/drawer.dart';
import 'package:rosterinsight/Models/holiday.dart';
import 'package:rosterinsight/main.dart';
import 'package:rosterinsight/screens/NavigationScreens/Holiday/entities/HolidayType.dart';
import 'package:rosterinsight/screens/NavigationScreens/MyNavigationScreen.dart';
import 'package:rosterinsight/services/Api_Call_Service.dart';
import 'package:skeletons/skeletons.dart';

class CreateHolidayScreen extends StatefulWidget {
  CreateHolidayScreen({this.isEdit, this.editHoliday});
  bool? isEdit;
  Holiday? editHoliday;
  @override
  State<CreateHolidayScreen> createState() => _CreateHolidayScreenState();
}

class _CreateHolidayScreenState extends State<CreateHolidayScreen> {
  List<HolidayType> listOfHolidays = [];
  HolidayType selectedHoliday = HolidayType(holidayName: 'Select Holiday');
  String fromDate = 'Select Date';
  String toDate = 'Select Date';
  DateFormat dateFormat = DateFormat('dd/MM/yyyy ');
  // DateFormat dateFormat = DateFormat('dd/MM/yyyy ').add_Hm();
  TextEditingController narrationController = TextEditingController();
  String narration = '';
  void dateTimePicker({double? height, bool? isStart}) {
    DatePicker.showDatePicker(context,
        theme: DatePickerTheme(
            doneStyle: TextStyle(color: primaryColor),
            containerHeight: height! / 2),
        showTitleActions: true,
        minTime: DateTime(2000, 3, 5),
        maxTime: DateTime(2030, 6, 7), onChanged: (date) {
      debugPrint('confirm $date');
    }, onConfirm: (date) {
      setState(() {
        if (isStart!) {
          fromDate = dateFormat.format(date);
        } else {
          toDate = dateFormat.format(date);
        }
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  void setEditParameter() {
    setState(() {
      selectedHoliday = HolidayType(
          holidayName: widget.editHoliday!.holidayType,
          holidayId: widget.editHoliday!.holidayTypeId);
      narration = widget.editHoliday!.narration!;
      narrationController.text = narration;

      fromDate = widget.editHoliday!.sdate!;
      toDate = widget.editHoliday!.edate!;
    });
  }

  @override
  void initState() {
    setState(() {
      listOfHolidays = MyNavigationScreen.listOfHolidays;
      if (widget.isEdit != null) {
        if (widget.isEdit!) {
          setEditParameter();
        }
      }
      // listOfHolidays.removeAt(0);
    });
    super.initState();
  }

  @override
  void dispose() {
    narrationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    Widget spaceBtwWidget = SizedBox(
      height: 40,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit == null || !widget.isEdit!
            ? 'Apply Holiday'
            : 'Edit Holiday'),
        centerTitle: true,
        actions: widget.isEdit == null || !widget.isEdit!
            ? []
            : [
                TextButton(
                  onPressed: () {
                    setState(() {
                      widget.isEdit = false;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyNavigationScreen(
                                  index: 2,
                                )));
                  },
                  child: Text(
                    'Back',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
      ),
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(children: [
            spaceBtwWidget,
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Text(
                      'Holiday Type',
                      style: TextStyle(fontSize: 18, color: textColor),
                    )),
                Expanded(
                  flex: 3,
                  child: DropdownButton(
                      // elevation: 1,
                      borderRadius: BorderRadius.circular(10),
                      hint: Text(
                        selectedHoliday.holidayName!,
                        style: TextStyle(fontSize: 21, color: textColor),
                      ),
                      alignment: Alignment.center,
                      isExpanded: true,
                      items: List.generate(listOfHolidays.length, ((index) {
                        return DropdownMenuItem(
                          child: Center(
                              child: Text(
                                  listOfHolidays[index].holidayName ?? 'N/A')),
                          value: index,
                        );
                      })),
                      onChanged: (value) async {
                        setState(() {
                          selectedHoliday = listOfHolidays[value!];
                        });
                      }),
                ),
              ],
            ),
            spaceBtwWidget,
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Text(
                      'From Date',
                      style: TextStyle(fontSize: 18, color: textColor),
                    )),
                Expanded(
                    flex: 3,
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            dateTimePicker(height: height, isStart: true);
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                            bottom:
                                3, // This can be the space you need between text and underline
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
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ))),
              ],
            ),
            spaceBtwWidget,
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Text(
                      'To Date',
                      style: TextStyle(fontSize: 18, color: textColor),
                    )),
                Expanded(
                    flex: 3,
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            dateTimePicker(height: height, isStart: false);
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                            bottom:
                                3, // This can be the space you need between text and underline
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
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ))),
              ],
            ),
            spaceBtwWidget,
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
            // child:
            TextFormField(
              minLines: 2,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              maxLength: 270,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              controller: narrationController,
              onChanged: (value) {
                setState(() {
                  narration = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(width: 20.0)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: primaryColor),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                labelText: 'Narration',
              ),
            ),
            // ),
            ElevatedButton(
                onPressed: checkDateAndTimeRange(fromDate, toDate) < 0
                    ? null
                    : () async {
                        Holiday holiday = Holiday()
                          ..holidayType = selectedHoliday.holidayName
                          ..holidayTypeId = selectedHoliday.holidayId
                          ..narration = narration
                          ..rVersion = ""
                          ..sdate = DateFormat('yyyy-MM-dd')
                              .format(
                                  DateFormat('dd/MM/yyyy').parse((fromDate)))
                              .toString()
                          ..edate = DateFormat('yyyy-MM-dd')
                              .format(DateFormat('dd/MM/yyyy').parse((toDate)))
                              .toString();
                        String msg = '';
                        if (widget.isEdit == null || !widget.isEdit!) {
                          msg = await ApiCall.apiForCreateHoliday(holiday);
                        } else {
                          holiday.rVersion = widget.editHoliday!.rVersion;
                          holiday.holidayId = widget.editHoliday!.holidayId;
                          msg = await ApiCall.apiForEditHoliday(holiday);
                        }
                        await exceptionSnackBar(msg);
                        setState(() {
                          selectedHoliday = HolidayType(
                            holidayName: 'Select Holiday',
                          );
                          narration = '';
                          narrationController.clear();

                          fromDate = 'Select Date';
                          toDate = 'Select Date';
                          widget.isEdit = false;
                        });

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => (MyNavigationScreen(
                                      index: 2,
                                    ))));
                      },
                // isExtended: true,
                // enableFeedback: true,
                child: Text(widget.isEdit == null || !widget.isEdit!
                    ? 'Save'
                    : 'Update')),
          ]),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {},
      //     isExtended: true,
      //     enableFeedback: true,
      //     child: Text('Save')),
    );
  }
}
