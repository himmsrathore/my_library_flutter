import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final String role;

  PaymentScreen({required this.role});

  @override
  Widget build(BuildContext context) {
    if (role == "super_admin" || role == "admin" || role == "library_admin") {
      return Center(
          child: Text("Admins do not have payment options",
              style: TextStyle(fontSize: 18, color: Colors.red)));
    }

    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text(
          "Payment\n(To be implemented for users)",
          style: TextStyle(fontSize: 20, color: Colors.teal),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
