import 'package:flutter/material.dart';
import 'package:mylibrary/services/library_admin_service.dart';

class LibraryAdminHomeScreen extends StatefulWidget {
  @override
  _LibraryAdminHomeScreenState createState() => _LibraryAdminHomeScreenState();
}

class _LibraryAdminHomeScreenState extends State<LibraryAdminHomeScreen> {
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
      LibraryAdminService libraryService = LibraryAdminService();
      Map<String, dynamic> data = await libraryService.fetchLibraryDetails();

      setState(() {
        libraryDetails = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Library Admin Dashboard")),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : errorMessage != null
                ? Text(
                    errorMessage!,
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  )
                : Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Library: ${libraryDetails!['name'] ?? 'N/A'}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text("Email: ${libraryDetails!['email'] ?? 'N/A'}"),
                        Text("Phone: ${libraryDetails!['phone'] ?? 'N/A'}"),
                        Text("Address: ${libraryDetails!['address'] ?? 'N/A'}"),
                        Text("Status: ${libraryDetails!['status'] ?? 'N/A'}"),
                        SizedBox(height: 20),
                        if (libraryDetails!['logo'] != null)
                          Image.network(
                            "http://10.0.2.2:8000/storage/${libraryDetails!['logo']}",
                            height: 100,
                          ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
