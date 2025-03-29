import 'package:flutter/material.dart';
import 'package:mylibrary/screens/home_screens/user_home_screen.dart';
import 'package:mylibrary/screens/select_seat_screen.dart';
import 'package:mylibrary/screens/attendance_summary_screen.dart';
import 'package:mylibrary/screens/payment_screen.dart';
import 'package:mylibrary/screens/about_screen.dart';

class UserMenu {
  static List<Widget> screens = [
    UserHomeScreen(),
    SelectSeatScreen(role: "user"),
    AttendanceSummaryScreen(role: "user"),
    PaymentScreen(role: "user"),
    AboutScreen(),
  ];

  static List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.event_seat), label: 'Select Seat'),
    BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Attendance'),
    BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payment'),
    BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
  ];
}
