import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String apiUrl = "http://10.0.2.2/library/library/public/api";

  /// Logs in the user and saves the token & role
  static Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Save authentication details
        await prefs.setString("token", data["token"]);
        await prefs.setString("user", jsonEncode(data["user"]));
        await prefs.setString("role", data["user"]["role"]); // Store role ✅

        return data["user"]["role"]; // Return role for navigation
      } else {
        return null; // Login failed
      }
    } catch (e) {
      return null; // Handle network errors
    }
  }

  /// Retrieves the stored authentication token
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// Logs out the user by clearing saved data
  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Remove all stored data
  }
}
