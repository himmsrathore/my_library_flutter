import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mylibrary/screens/menus/super_admin_menu.dart';
import 'package:mylibrary/screens/menus/admin_menu.dart';
import 'package:mylibrary/screens/menus/library_admin_menu.dart';
import 'package:mylibrary/screens/menus/user_menu.dart';

class UserDashboard extends StatefulWidget {
  final String userRole;

  UserDashboard({required this.userRole});

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0;
  late List<Widget> _screens;
  late List<BottomNavigationBarItem> _navItems;

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

  void _initializeScreens() {
    switch (widget.userRole) {
      case "super_admin":
        _screens = SuperAdminMenu.screens;
        _navItems = SuperAdminMenu.items;
        break;
      case "admin":
        _screens = AdminMenu.screens;
        _navItems = AdminMenu.items;
        break;
      case "library_admin":
        _screens = LibraryAdminMenu.screens;
        _navItems = LibraryAdminMenu.items;
        break;
      default:
        _screens = UserMenu.screens;
        _navItems = UserMenu.items;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo/logo.png',
              height: 40,
            ),
            SizedBox(width: 10),
            Text(
              "MyLibrary",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 4, 19, 52),
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
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        logout(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Yes",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
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
