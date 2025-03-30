import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'custom_app_bar.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "About MyLibrary",
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: _shareApp,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue[700]!,
                    Colors.blue[500]!,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // App Logo
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.local_library,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "MyLibrary",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Modern Library Management System",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // App Info Section
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildInfoCard(
                    icon: Icons.description,
                    title: "About",
                    child: Text(
                      "MyLibrary is a comprehensive library management solution that helps institutions track attendance, manage seating, and make reading more accessible to everyone. Our mission is to bridge the gap between readers and resources through technology.",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildInfoCard(
                    icon: Icons.people,
                    title: "Our Team",
                    child: Column(
                      children: [
                        _buildTeamMember(
                          "xAI Team",
                          "Development & Design",
                          Icons.code,
                        ),
                        SizedBox(height: 12),
                        _buildTeamMember(
                          "Library Staff",
                          "Content & Support",
                          Icons.library_books,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildInfoCard(
                    icon: Icons.star,
                    title: "Features",
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildFeatureChip("Seat Management"),
                        _buildFeatureChip("Attendance Tracking"),
                        _buildFeatureChip("Digital Payments"),
                        _buildFeatureChip("Book Reservations"),
                        _buildFeatureChip("User Profiles"),
                        _buildFeatureChip("Analytics"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Version & Legal
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "Version 1.1.1",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildFooterLink("Privacy Policy", Icons.privacy_tip),
                      _buildFooterLink("Terms", Icons.description),
                      _buildFooterLink("FAQ", Icons.help_outline),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Made with ❤️ in India 🇮🇳",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.email, color: Colors.blue),
                        onPressed: () =>
                            _launchUrl("mailto:support@mylibrary.com"),
                      ),
                      IconButton(
                        icon: Icon(Icons.language, color: Colors.blue),
                        onPressed: () => _launchUrl("https://mylibrary.com"),
                      ),
                      IconButton(
                        icon: Icon(Icons.facebook, color: Colors.blue),
                        onPressed: () =>
                            _launchUrl("https://facebook.com/mylibrary"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      {required IconData icon, required String title, required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.blue[700]),
            SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember(String name, String role, IconData icon) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.blue[700]),
      ),
      title: Text(
        name,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        role,
        style: GoogleFonts.poppins(
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String text) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.blue[50],
      labelStyle: GoogleFonts.poppins(
        color: Colors.blue[800],
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.blue[100]!),
      ),
    );
  }

  Widget _buildFooterLink(String text, IconData icon) {
    return TextButton.icon(
      onPressed: () {
        // Handle navigation to respective pages
      },
      icon: Icon(icon, size: 18, color: Colors.blue),
      label: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: Colors.blue,
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _shareApp() {
    // Implement share functionality
  }
}
