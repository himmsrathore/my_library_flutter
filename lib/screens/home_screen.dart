import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final String role;

  HomeScreen({required this.role});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> user = {};
  Map<String, dynamic>? libraryDetails;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadUserDetails();
    fetchLibraryDetails();
  }

  void loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString("user");
    if (userData != null) {
      setState(() {
        user = jsonDecode(userData);
      });
    }
  }

  Future<void> fetchLibraryDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      if (token == null) {
        setState(() {
          errorMessage = "No authentication token found";
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse("http://10.0.2.2/library/library/public/api/library"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          libraryDetails = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              "Failed to load library details: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (isLoading) {
      content = CircularProgressIndicator();
    } else if (errorMessage != null) {
      content = Text(
        errorMessage!,
        style: TextStyle(
          fontSize: 18,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      );
    } else if (libraryDetails == null) {
      content = Text(
        "No library details available",
        style: TextStyle(fontSize: 18),
      );
    } else {
      switch (widget.role) {
        case "super_admin":
          content = Column(
            children: [
              Text(
                "Super Admin Dashboard",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text("Manage all libraries and users"),
              SizedBox(height: 20),
              Text(
                "Library: ${libraryDetails!['name'] ?? 'N/A'}",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Address: ${libraryDetails!['address'] ?? 'N/A'}",
                style: TextStyle(fontSize: 18),
              ),
            ],
          );
          break;
        case "admin":
          content = Column(
            children: [
              Text(
                "Admin Dashboard",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text("Manage library operations"),
              SizedBox(height: 20),
              Text(
                "Library: ${libraryDetails!['name'] ?? 'N/A'}",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Address: ${libraryDetails!['address'] ?? 'N/A'}",
                style: TextStyle(fontSize: 18),
              ),
            ],
          );
          break;
        case "library_admin":
          content = Column(
            children: [
              Text(
                "Library Admin Dashboard",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text("Oversee library seats and attendance"),
              SizedBox(height: 20),
              Text(
                "Library: ${libraryDetails!['name'] ?? 'N/A'}",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Address: ${libraryDetails!['address'] ?? 'N/A'}",
                style: TextStyle(fontSize: 18),
              ),
            ],
          );
          break;
        default:
          content = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome, ${user['name'] ?? 'User'}!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text("Email: ${user['email'] ?? 'N/A'}"),
              Text("Library ID: ${user['library_id'] ?? 'N/A'}"),
              SizedBox(height: 20),
              Text(
                "Library: ${libraryDetails!['name'] ?? 'N/A'}",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Address: ${libraryDetails!['address'] ?? 'N/A'}",
                style: TextStyle(fontSize: 18),
              ),
            ],
          );
      }
    }

    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Home",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            content,
          ],
        ),
      ),
    );
  }
}
