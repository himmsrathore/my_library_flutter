import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'custom_app_bar.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Section
            Container(
              padding: EdgeInsets.fromLTRB(32, 32, 32, 48),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue[800]!,
                    Colors.blue[600]!,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/logo/logo-light.png',
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "MyLibrary",
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Your Digital Library Companion",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white70,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // About Section
                  Text(
                    "About Us",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[900],
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "MyLibrary revolutionizes library management with cutting-edge technology, making reading accessible and efficient for everyone. We bridge the gap between readers and resources seamlessly.",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 24),
                  Divider(color: Colors.grey[300]),

                  // Features Section
                  SizedBox(height: 24),
                  Text(
                    "Features",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[900],
                    ),
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildFeatureItem("Seat Management", Icons.event_seat),
                      _buildFeatureItem("Attendance", Icons.people_alt),
                      _buildFeatureItem("Payments", Icons.payment),
                      _buildFeatureItem("Reservations", Icons.bookmark),
                      _buildFeatureItem("Profiles", Icons.person),
                      _buildFeatureItem("Analytics", Icons.analytics),
                    ],
                  ),
                  SizedBox(height: 24),
                  Divider(color: Colors.grey[300]),

                  // Team Section
                  SizedBox(height: 24),
                  Text(
                    "Our Team",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[900],
                    ),
                  ),
                  SizedBox(height: 16),
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

            // Footer
            Container(
              padding: EdgeInsets.all(24),
              color: Colors.grey[100],
              child: Column(
                children: [
                  Text(
                    "Version 1.1.1",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    spacing: 32,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildFooterLink("Privacy Policy", Icons.privacy_tip),
                      _buildFooterLink("Terms", Icons.description),
                      _buildFooterLink("FAQ", Icons.help_outline),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.email, color: Colors.blue[700]),
                        onPressed: () =>
                            _launchUrl("mailto:support@mylibrary.com"),
                      ),
                      IconButton(
                        icon: Icon(Icons.language, color: Colors.blue[700]),
                        onPressed: () => _launchUrl("https://mylibrary.com"),
                      ),
                      IconButton(
                        icon: Icon(Icons.facebook, color: Colors.blue[700]),
                        onPressed: () =>
                            _launchUrl("https://facebook.com/mylibrary"),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Made with ❤️ in India 🇮🇳",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.blue[700]),
          SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.blue[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(String name, String role, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.blue[700], size: 24),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            Text(
              role,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterLink(String text, IconData icon) {
    return TextButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18, color: Colors.blue[700]),
      label: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.blue[700],
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
