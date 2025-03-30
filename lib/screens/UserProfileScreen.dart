import 'package:flutter/material.dart';
import 'package:mylibrary/models/user_model.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfileScreen extends StatelessWidget {
  final UserModel user;

  UserProfileScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
              color: Colors.white, // This is the only line you need to change
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 76, 89, 138),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: const Color.fromARGB(255, 76, 89, 138),
                child: Text(
                  user.name.substring(0, 1).toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildProfileItem(Icons.person, "Name", user.name),
            _buildProfileItem(Icons.email, "Email", user.email),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[700]),
        title: Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
        ),
        subtitle: Text(
          value,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
