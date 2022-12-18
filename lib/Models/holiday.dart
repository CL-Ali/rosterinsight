import 'package:intl/intl.dart';
import 'package:rosterinsight/screens/NavigationScreens/MyNavigationScreen.dart';

class Holiday {
  String? holidayType;
  int? holidayId;
  int? holidayTypeId;
  String? sdate;
  String? edate;
  String? startTime;
  String? endTime;
  String? narration;
  String? rVersion;
  int? approvalStatus;
  Holiday(
      {this.sdate,
      this.edate,
      this.startTime,
      this.endTime,
      this.holidayId,
      this.holidayType,
      this.rVersion,
      this.approvalStatus,
      this.narration});

  Future<List<Holiday>> mapToList(List map) async {
    List<Holiday> tList = [];
    if (map.isNotEmpty) {
      // [count];
      map.forEach((element) {
        Holiday holiday = Holiday();
        holiday.rVersion = element['rVersion'] ?? '';
        holiday.holidayTypeId =
            element['refHolidayType']['holidayTypeId'] ?? -1;
        holiday.holidayId = element['holidayId'] ?? -1;
        holiday.approvalStatus = element['approvalStatus'] ?? '';

        holiday.startTime = DateFormat('HH:mm').format(
            DateFormat('HH:mm').parse(element['fromDate'].split('T').last));
        holiday.endTime = DateFormat('HH:mm').format(
            DateFormat('HH:mm').parse(element['toDate'].split('T').last));
        holiday.sdate = DateFormat('dd/MM/yyyy')
            .format(DateFormat('yyyy-MM-dd')
                .parse((element['fromDate'].split('T').first)))
            .toString();
        holiday.edate = DateFormat('dd/MM/yyyy')
            .format(DateFormat('yyyy-MM-dd')
                .parse((element['toDate'].split('T').first)))
            .toString();
        holiday.narration = element['narration'].toString();
        if (MyNavigationScreen.listOfHolidays.isNotEmpty) {
          for (var element in MyNavigationScreen.listOfHolidays) {
            if (holiday.holidayTypeId == element.holidayId) {
              holiday.holidayType = element.holidayName;
              break;
            } else {
              holiday.holidayType = '';
            }
          }
        } else {
          holiday.holidayType = '';
        }
        tList.add(holiday);
      });
      return tList;
    }
    return [];
  }
}
