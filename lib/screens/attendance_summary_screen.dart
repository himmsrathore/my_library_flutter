import 'package:flutter/material.dart';

class AttendanceSummaryScreen extends StatelessWidget {
  final String role;

  AttendanceSummaryScreen({required this.role});

  @override
  Widget build(BuildContext context) {
    String content;
    switch (role) {
      case "super_admin":
        content = "Super Admin: View all attendance records";
        break;
      case "admin":
        content = "Admin: Manage library attendance";
        break;
      case "library_admin":
        content = "Library Admin: View library attendance";
        break;
      default:
        content = "User: View your attendance history";
    }

    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text(
          "Attendance Summary\n$content\n(To be implemented with API)",
          style: TextStyle(fontSize: 20, color: Colors.teal),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
