import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mylibrary/screens/login_screen.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboarddd"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // ✅ Call logout function
              await logout(context);
            },
          ),
        ],
      ),
      body: Center(child: Text("Welcome Admin!")),
    );
  }

  // ✅ Logout function
  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Remove stored user data

    // Redirect to login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
