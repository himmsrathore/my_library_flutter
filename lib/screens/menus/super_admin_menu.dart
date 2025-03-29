import 'package:flutter/material.dart';
import 'package:mylibrary/screens/home_screens/super_admin_home_screen.dart';
import 'package:mylibrary/screens/attendance_summary_screen.dart';
import 'package:mylibrary/screens/about_screen.dart';

class SuperAdminMenu {
  static List<Widget> screens = [
    SuperAdminHomeScreen(),
    AttendanceSummaryScreen(role: "super_admin"),
    AboutScreen(),
  ];

  static List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Attendance'),
    BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
  ];
}
