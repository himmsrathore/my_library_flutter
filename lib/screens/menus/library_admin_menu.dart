import 'package:flutter/material.dart';
import 'package:mylibrary/screens/home_screens/library_admin_home_screen.dart';
import 'package:mylibrary/screens/select_seat_screen.dart';
import 'package:mylibrary/screens/attendance_summary_screen.dart';
import 'package:mylibrary/screens/about_screen.dart';

class LibraryAdminMenu {
  static List<Widget> screens = [
    LibraryAdminHomeScreen(),
    SelectSeatScreen(role: "library_admin"),
    AttendanceSummaryScreen(role: "library_admin"),
    AboutScreen(),
  ];

  static List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.event_seat), label: 'Select Seat'),
    BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Attendance'),
    BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
  ];
}
