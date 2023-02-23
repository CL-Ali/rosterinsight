import 'package:intl/intl.dart';
import 'package:rosterinsight/MainComponents/constant.dart';

class Booking {
  String? site;
  String? sdate;
  String? edate;
  String? startTime;
  String? endTime;
  String? narration;
  String? bookingId;
  int? bookOnStts;
  int? siteID;
  String? postCode;
  Booking(
      {this.sdate,
      this.edate,
      this.startTime,
      this.endTime,
      this.site,
      this.postCode,
      this.siteID,
      this.bookingId,
      this.bookOnStts,
      this.narration});
  Future<List<Booking>> mapToList(List map) async {
    List<Booking> tList = [];
    if (map.isNotEmpty) {
      // [count];
      map.forEach((element) {
        Booking booking = Booking();
        booking.bookingId = element['bookingId'].toString();
        booking.bookOnStts = element['bookOnOffStatus'];
        booking.postCode = element['postCode'].toString();

        booking.site = element['siteTitle'].toString();
        booking.siteID = element['fk_SiteId'] ?? 0;
        booking.startTime = DateFormat('HH:mm').format(
            DateFormat('HH:mm').parse(element['startDate'].split('T').last));
        booking.endTime = DateFormat('HH:mm').format(
            DateFormat('HH:mm').parse(element['endDate'].split('T').last));
        booking.sdate = DateFormat('dd/MM/yyyy')
            .format(DateFormat('yyyy-MM-dd')
                .parse((element['startDate'].split('T').first)))
            .toString();
        booking.edate = DateFormat('dd/MM/yyyy')
            .format(DateFormat('yyyy-MM-dd')
                .parse((element['endDate'].split('T').first)))
            .toString();
        booking.narration = element['narration'].toString();

        tList.add(booking);
      });
      return tList;
    }
    return [];
  }
}
