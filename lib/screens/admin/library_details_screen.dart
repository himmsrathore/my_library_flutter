import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylibrary/services/library_admin_service.dart';

class LibraryDetailsScreen extends StatefulWidget {
  @override
  _LibraryDetailsScreenState createState() => _LibraryDetailsScreenState();
}

class _LibraryDetailsScreenState extends State<LibraryDetailsScreen> {
  Map<String, dynamic>? libraryDetails;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchLibraryDetails();
  }

  Future<void> _fetchLibraryDetails() async {
    try {
      LibraryAdminService libraryService = LibraryAdminService();
      libraryDetails = await libraryService.fetchLibraryDetails();
      setState(() {
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
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blue[800]))
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: GoogleFonts.poppins(
                        fontSize: 18, color: Colors.red[800]),
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Library Details",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      SizedBox(height: 20),
                      if (libraryDetails!['logo'] != null)
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              "http://10.0.2.2:8000/storage/${libraryDetails!['logo']}",
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      SizedBox(height: 20),
                      _buildInfoTile(Icons.account_balance, "Name",
                          libraryDetails!['name']),
                      _buildInfoTile(
                          Icons.email, "Email", libraryDetails!['email']),
                      _buildInfoTile(
                          Icons.phone, "Phone", libraryDetails!['phone']),
                      _buildInfoTile(Icons.location_on, "Address",
                          libraryDetails!['address']),
                      _buildInfoTile(
                          Icons.power, "Status", libraryDetails!['status']),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String? value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[800], size: 24),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style:
                    GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 4),
              Text(
                value ?? "N/A",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[900],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
