import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'select_seat_screen.dart';
import 'attendance_summary_screen.dart';
import 'payment_screen.dart';
import 'about_screen.dart';

class UserDashboard extends StatefulWidget {
  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0;
  String userRole = "";
  late List<Widget> _screens;
  late List<BottomNavigationBarItem> _navItems;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  void _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString("role") ?? "";
      _initializeScreens();
    });
  }

  void _initializeScreens() {
    _screens = [
      HomeScreen(role: userRole),
      SelectSeatScreen(role: userRole),
      AttendanceSummaryScreen(role: userRole),
      PaymentScreen(role: userRole),
      AboutScreen(),
    ];

    _navItems = [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(
          icon: Icon(Icons.event_seat), label: 'Select Seat'),
      BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Attendance'),
      BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payment'),
      BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
    ];

    // Customize nav items based on role
    if (userRole == "super_admin" || userRole == "admin") {
      _navItems.removeWhere(
          (item) => item.label == 'Select Seat' || item.label == 'Payment');
      _screens.removeAt(3); // Remove Payment
      _screens.removeAt(1); // Remove Select Seat
    } else if (userRole == "library_admin") {
      _navItems.removeWhere((item) => item.label == 'Payment');
      _screens.removeAt(3); // Remove Payment
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyLibrary"),
        backgroundColor: Colors.teal,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            tooltip: "Logout",
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Logout"),
                  content: Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel")),
                    TextButton(
                      onPressed: () {
                        logout();
                        Navigator.pop(context);
                      },
                      child: Text("Yes", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: userRole.isEmpty
          ? Center(child: CircularProgressIndicator())
          : _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
