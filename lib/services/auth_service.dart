import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String apiUrl = "http://10.0.2.2/library/library/public/api";

  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$apiUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", data["token"]);
      prefs.setString("user", jsonEncode(data["user"]));
      prefs.setString("role", data["user"]["role"]); // ✅ Store user role
      return true;
    }
    return false;
  }
}
