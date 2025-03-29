import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceService {
  static const String baseUrl = "http://10.0.2.2/library/library/public/api";

  static Future<List<dynamic>> getAllSeats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/attendance/seats"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print("Get All Seats - Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body)["seats"] ?? [];
      } else {
        print("Failed to fetch seats: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching seats: $e");
      return [];
    }
  }

  static Future<Map<String, dynamic>> checkIn(int seatId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) return {'success': false, 'message': 'No token found'};

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/attendance/check-in"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"seat_id": seatId}),
      );

      print("Check-In Response - Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final data = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? 'Unknown error',
      };
    } catch (e) {
      print("Error during check-in: $e");
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> checkOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) return {'success': false, 'message': 'No token found'};

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/attendance/check-out"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print("Check-Out Response - Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final data = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? 'Unknown error',
      };
    } catch (e) {
      print("Error during check-out: $e");
      return {'success': false, 'message': e.toString()};
    }
  }
}
