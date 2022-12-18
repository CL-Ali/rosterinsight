import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:rosterinsight/MainComponents/constant.dart';
import 'package:rosterinsight/Models/holiday.dart';
import 'package:rosterinsight/screens/NavigationScreens/Holiday/components/holidayDetailScreen.dart';
import 'package:rosterinsight/screens/NavigationScreens/Holiday/screens/CreateOrEditHolidayScreen.dart';
import 'package:rosterinsight/screens/NavigationScreens/MyNavigationScreen.dart';
import 'package:rosterinsight/services/Api_Call_Service.dart';

class HolidayCard extends StatelessWidget {
  HolidayCard({
    required this.holidayDetail,
    this.bookOnFunction,
  });
  Holiday holidayDetail;
  VoidCallback? bookOnFunction;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(HolidayDetail(
          holiday: holidayDetail,
          approvalStts: 0,
        ));
      },
      child: SizedBox(
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
                    holidayDetail.holidayType.toString(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${holidayDetail.sdate!}-${holidayDetail.edate!}',
                            softWrap: false,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            holidayDetail.approvalStatus == 0
                                ? "Pending"
                                : holidayDetail.approvalStatus == 1
                                    ? "Approved"
                                    : "Rejected",
                            softWrap: false,
                            style: TextStyle(
                              color: holidayDetail.approvalStatus == 0
                                  ? Colors.black
                                  : holidayDetail.approvalStatus == 1
                                      ? Colors.green
                                      : Colors.red,
                            ),
                          ),
                        ),
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
