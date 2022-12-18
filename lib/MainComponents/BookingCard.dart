import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:rosterinsight/Models/booking.dart';
import 'package:rosterinsight/screens/NavigationScreens/BookingScreen/component/bookingDetailScreen.dart';

class BookingCard extends StatelessWidget {
  BookingCard({
    required this.isNextBooking,
    required this.employeeDetail,
    this.bookOnFunction,
  });
  Booking employeeDetail;
  bool isNextBooking;
  VoidCallback? bookOnFunction;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(BookingDetail(
          booking: employeeDetail,
          isEmployeeBooking: true,
        ));
      },
      child: isNextBooking
          ? SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          employeeDetail.site!,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  employeeDetail.sdate!,
                                  softWrap: false,
                                ),
                                Text(
                                  '${employeeDetail.startTime!} - ${employeeDetail.endTime!}',
                                  softWrap: false,
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                      child: Text(employeeDetail.bookOnStts == 1
                                          ? 'Book off'
                                          : 'Book On'),
                                      onPressed: bookOnFunction),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          : SizedBox(
              height: 80,
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          employeeDetail.site ?? 'N/A',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              employeeDetail.sdate!,
                              softWrap: false,
                            ),
                            Text(
                              '${employeeDetail.startTime!} - ${employeeDetail.endTime!}',
                              softWrap: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
