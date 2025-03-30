import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({Key? key, required this.title, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: screenWidth < 360 ? 16 : 20, // Adjust font size dynamically
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 28, 34, 85),
      elevation: 3,
      centerTitle: true, // Ensures proper alignment on all devices
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
