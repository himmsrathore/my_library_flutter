import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  Map<String, dynamic>? libraryDetails;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchLibraryDetails();
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
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.all(16),
      child: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : errorMessage != null
                ? Text(
                    errorMessage!,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Admin Dashboard",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Manage library operations",
                        textAlign: TextAlign.center,
                      ),
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
                  ),
      ),
    );
  }
}
