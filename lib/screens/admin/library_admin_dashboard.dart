import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylibrary/screens/admin/library_details_screen.dart';
import 'package:mylibrary/screens/admin/books_screen.dart';
import 'package:mylibrary/screens/admin/gallery_screen.dart';
import 'package:mylibrary/screens/select_seat_screen.dart';
import 'package:mylibrary/screens/attendance_summary_screen.dart';
import 'package:mylibrary/screens/about_screen.dart';
import 'package:mylibrary/services/auth_service.dart';
import 'package:mylibrary/services/library_admin_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mylibrary/screens/login_screen.dart';
import 'package:mylibrary/screens/admin/seat_management_screen.dart'; // Import the new screen
import 'package:mylibrary/screens/admin/payment_management_screen.dart'; // Import the new screen

class LibraryAdminDashboard extends StatelessWidget {
  final List<Widget> _screens = [
    DashboardHome(),
    SeatManagementScreen(),
    PaymentManagementScreen(), // Added the new screen
    AttendanceSummaryScreen(role: "library_admin"),
    AboutScreen(),
  ];

  final List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
    BottomNavigationBarItem(icon: Icon(Icons.event_seat), label: 'Seats'),
    BottomNavigationBarItem(
        icon: Icon(Icons.payment), label: 'Payments'), // New tab
    BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Attendance'),
    BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
  ];

  Future<void> _logout(BuildContext context) async {
    await AuthService.logout();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _LibraryAdminDashboardContent(
      screens: _screens,
      navItems: _navItems,
      onLogout: () => _logout(context),
    );
  }
}

class _LibraryAdminDashboardContent extends StatefulWidget {
  final List<Widget> screens;
  final List<BottomNavigationBarItem> navItems;
  final VoidCallback onLogout;

  _LibraryAdminDashboardContent({
    required this.screens,
    required this.navItems,
    required this.onLogout,
  });

  @override
  __LibraryAdminDashboardContentState createState() =>
      __LibraryAdminDashboardContentState();
}

class __LibraryAdminDashboardContentState
    extends State<_LibraryAdminDashboardContent> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[800]!, Colors.purple[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          "Lib Admin Dashboard",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.person, color: Colors.white),
          //   onPressed: () {},
          //   tooltip: "Profile",
          // ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: widget.onLogout,
            tooltip: "Logout",
          ),

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
                      onPressed: widget.onLogout,
                      child: Text("Yes", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: widget.screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Colors.white,
        elevation: 8,
        items: widget.navItems,
      ),
    );
  }
}

class DashboardHome extends StatefulWidget {
  @override
  _DashboardHomeState createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  final LibraryAdminService _libraryService = LibraryAdminService();
  Map<String, dynamic>? libraryDetails;
  List<dynamic>? subscriptions;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      setState(() => isLoading = true);
      final libraryData = await _libraryService.fetchLibraryDetails();
      final subscriptionData = await _libraryService.fetchSubscriptionDetails();
      setState(() {
        libraryDetails = libraryData; // Library info
        subscriptions = subscriptionData; // Subscription list
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the first subscription's user data for admin info (assuming admin is the user here)
    final adminName = subscriptions?.isNotEmpty == true
        ? subscriptions![0]['user']['name']
        : 'Admin';
    final adminEmail = subscriptions?.isNotEmpty == true
        ? subscriptions![0]['user']['email']
        : 'admin@mylibrary.com';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Card
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[800]!, Colors.blue[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome, $adminName!",
                  style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.white, size: 40),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            adminName,
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          Text(
                            adminEmail,
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Subscription Details
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Subscription Details",
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[900]),
                ),
                SizedBox(height: 16),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : subscriptions == null || subscriptions!.isEmpty
                        ? _buildEmptyState("No subscriptions found")
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: subscriptions!.length,
                            itemBuilder: (context, index) {
                              final sub = subscriptions![index];
                              return Card(
                                elevation: 4,
                                margin: EdgeInsets.only(bottom: 8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${sub['subscription_period']}",
                                            style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blue[800]),
                                          ),
                                          Text(
                                            "${sub['status']}",
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: sub['status'] == 'approved'
                                                  ? Colors.green
                                                  : Colors.orange,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                          color: Colors.grey[300],
                                          thickness: 1),
                                      SizedBox(height: 4),
                                      Text("Amount: \$${sub['amount']}",
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.grey[800])),
                                      Text("Start: ${sub['start_date']}",
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.grey[800])),
                                      Text("End: ${sub['end_date']}",
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.grey[800])),
                                      SizedBox(height: 8),
                                      Text(
                                        "Library: ${sub['library']['name']}",
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ],
            ),
          ),
          // Quick Access Grid
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Quick Access",
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[900]),
                ),
                SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildMenuTile(context,
                        icon: Icons.library_books,
                        title: "Library Details",
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LibraryDetailsScreen()))),
                    _buildMenuTile(context,
                        icon: Icons.book,
                        title: "Books",
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BooksScreen()))),
                    _buildMenuTile(context,
                        icon: Icons.image,
                        title: "Gallery",
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GalleryScreen()))),
                    _buildMenuTile(context,
                        icon: Icons.settings,
                        title: "Settings",
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text("Settings not implemented yet")))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blue[800], size: 40),
            SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
      child: Text(message,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
    );
  }
}
