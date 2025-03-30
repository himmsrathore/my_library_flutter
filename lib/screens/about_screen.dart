import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_app_bar.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "About MyLibrary"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // App Logo (Replace with your actual logo)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue[100],
              child:
                  Icon(Icons.local_library, size: 50, color: Colors.blue[700]),
            ),
          ),

          // App Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  "Welcome to MyLibrary 📚",
                  style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "MyLibrary is a modern library management system that helps you track attendance, manage seats, and make reading more accessible.\n\nDeveloped with ❤️ by xAI.",
                  style:
                      GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Divider(thickness: 1, color: Colors.grey[300]),
              ],
            ),
          ),

          // Version Info
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Version 1.1.1",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
            ),
          ),

          Spacer(),

          // Footer with Links
          Column(
            children: [
              GestureDetector(
                onTap: () {},
                child: Text("Privacy Policy",
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                        decoration: TextDecoration.underline)),
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {},
                child: Text("Terms & Conditions",
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                        decoration: TextDecoration.underline)),
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {},
                child: Text("FAQ",
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                        decoration: TextDecoration.underline)),
              ),
              SizedBox(height: 10),
              Text(
                "Made with ❤️ in India 🇮🇳",
                style:
                    GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
