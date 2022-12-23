import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rosterinsight/MainComponents/constant.dart';
import 'package:rosterinsight/Models/holiday.dart';
import 'package:rosterinsight/main.dart';
import 'package:rosterinsight/services/Api_Call_Service.dart';

class HolidayDetail extends StatefulWidget {
  HolidayDetail({required this.holiday, required this.approvalStts});
  int approvalStts;
  Holiday holiday;
  @override
  State<HolidayDetail> createState() => _HolidayDetailState();
}

class _HolidayDetailState extends State<HolidayDetail> {
  showAlertDialog(BuildContext context) {
// Create button
    Widget okButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        Navigator.of(context).pop();
      },
    );
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

// Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Mark CheckCall"),
      content: Text("This is an alert message."),
      actions: [
        cancelButton,
        okButton,
      ],
    );

// show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holiday Detail'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.holiday.holidayType!.toString(),
              style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 5,
            ),
            Column(
              children: [
                Text(
                  ' ${widget.holiday.sdate!.toString()} - ${widget.holiday.edate!.toString()}',
                  style: TextStyle(
                      fontSize: 22,
                      color: textColor,
                      fontWeight: FontWeight.w600),
                  softWrap: false,
                ),
                Text(
                  widget.holiday.approvalStatus == 0
                      ? "Pending"
                      : widget.holiday.approvalStatus == 1
                          ? "Approved"
                          : "Rejected",
                  style: TextStyle(
                      fontSize: 20,
                      color: widget.holiday.approvalStatus == 0
                          ? Colors.black
                          : widget.holiday.approvalStatus == 1
                              ? Colors.green
                              : Colors.red,
                      fontWeight: FontWeight.w500),
                  softWrap: false,
                ),
                // Text(
                //   ' ${widget.holiday.startTime!} - ${widget.holiday.endTime!}',
                //   style: TextStyle(
                //       fontSize: 18,
                //       color: textColor,
                //       fontWeight: FontWeight.w500),
                //   softWrap: false,
                // ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height / 35,
                // ),
                widget.holiday.narration! == 'null' || widget.holiday.narration! ==''
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.zero,
                        //  const EdgeInsets.symmetric(horizontal: 15.0),
                        child: RichText(
                          text: TextSpan(
                              text: 'Narration : ',
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      """
                    \t\t
                       ${widget.holiday.narration! == 'null' ? '' : widget.holiday.narration!}
                     """,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ]),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
