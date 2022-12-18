import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rosterinsight/MainComponents/constant.dart';
import 'package:rosterinsight/Models/booking.dart';
import 'package:rosterinsight/main.dart';
import 'package:rosterinsight/services/Api_Call_Service.dart';

class BookingDetail extends StatefulWidget {
  BookingDetail({required this.booking, required this.isEmployeeBooking});
  bool isEmployeeBooking;
  Booking booking;
  @override
  State<BookingDetail> createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {
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
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.booking.site!.toString(),
              style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 5,
            ),
            Column(
              children: [
                Text(
                  widget.booking.sdate!,
                  style: TextStyle(
                      fontSize: 22,
                      color: textColor,
                      fontWeight: FontWeight.w600),
                  softWrap: false,
                ),
                Text(
                  ' ${widget.booking.startTime!} - ${widget.booking.endTime!}',
                  style: TextStyle(
                      fontSize: 18,
                      color: textColor,
                      fontWeight: FontWeight.w500),
                  softWrap: false,
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height / 20,
                // ),
                widget.booking.narration! == 'null'
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                      ${widget.booking.narration! == 'null' ? '' : widget.booking.narration}
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
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                widget.isEmployeeBooking
                    ? ElevatedButton(
                        onPressed: () {
                          showAlertDialog(context);
                        },
                        child: Text('Mark CheckCall'))
                    : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
