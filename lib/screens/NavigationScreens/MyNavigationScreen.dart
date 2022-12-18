import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:rosterinsight/MainComponents/constant.dart';
import 'package:rosterinsight/Models/holiday.dart';
import 'package:rosterinsight/screens/NavigationScreens/BookingScreen/HomeScreen.dart';
import 'package:rosterinsight/screens/NavigationScreens/BookingScreen/SiteBooking.dart';
import 'package:rosterinsight/screens/NavigationScreens/Holiday/entities/HolidayType.dart';
import 'package:rosterinsight/screens/NavigationScreens/Holiday/screens/CreateOrEditHolidayScreen.dart';
import 'package:rosterinsight/screens/NavigationScreens/Holiday/screens/HolidayScreen.dart';

class MyNavigationScreen extends StatefulWidget {
  MyNavigationScreen({this.index, this.isEditHoliday, this.editHolidayData});
  int? index;

  bool? isEditHoliday;
  Holiday? editHolidayData;
  static List<HolidayType> listOfHolidays = [];
  @override
  State<MyNavigationScreen> createState() => _MyNavigationScreenState();
}

class _MyNavigationScreenState extends State<MyNavigationScreen> {
  int _selectedItemPosition = 0;

  var snakeShape = SnakeShape.indicator;
  Color selectedColor = Colors.deepPurple.shade100;
  Color unselectedColor = Colors.deepPurple.shade200;

  void _onPageChanged(int page) {
    setState(() {
      _selectedItemPosition = page;
      widget.index = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomeScreen(),
      SiteBookingScreen(),
      HolidayScreen(),
      CreateHolidayScreen(
        isEdit: widget.isEditHoliday ?? false,
        editHoliday: widget.editHolidayData ?? Holiday(),
      ),
    ];
    PageController pageController =
        PageController(initialPage: widget.index ?? 0);
    _selectedItemPosition = widget.index ?? 0;
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(seconds: 1),
        child: PageView(
          controller: pageController,
          onPageChanged: _onPageChanged,
          children: pages,
        ),
      ),
      bottomNavigationBar: SnakeNavigationBar.color(
        behaviour: SnakeBarBehaviour.floating,
        snakeShape: SnakeShape.indicator,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),

        padding: const EdgeInsets.all(12),
        backgroundColor: primaryColor,
        snakeViewColor: selectedColor,
        selectedItemColor:
            snakeShape == SnakeShape.indicator ? selectedColor : null,
        unselectedItemColor: unselectedColor,
        // showUnselectedLabels: showUnselectedLabels,
        showSelectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 11),
        currentIndex: _selectedItemPosition,
        onTap: (index) {
          setState(() {
            pageController.animateToPage(index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastLinearToSlowEaseIn);
          });

          _onPageChanged(index);
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.house), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.bookmark), label: 'Site Booking'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.restart), label: 'Holidays'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.restart), label: 'Apply Holiday'),
        ],
      ),
    );
  }
}

class IconWithNotification extends StatelessWidget {
  IconWithNotification({
    required this.icon,
    required this.notificationNo,
  });
  IconData icon;
  String notificationNo;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Icon(icon),
        Positioned(
          right: 0,
          child: Container(
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(
              minWidth: 14,
              minHeight: 14,
            ),
            child: Text(
              notificationNo,
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
