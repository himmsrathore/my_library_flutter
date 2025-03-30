import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mylibrary/models/attendance_model.dart';

class AttendanceService {
  static const String baseUrl = "http://10.0.2.2/library/library/public/api";

  static Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<List<dynamic>> getAllSeats() async {
    String? token = await _getToken();
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/attendance/seats"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json"
        },
      );

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
    String? token = await _getToken();
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

      final data = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? 'Unknown error',
      };
    } catch (e) {
      return {'success': false, 'message': 'Error during check-in: $e'};
    }
  }

  static Future<Map<String, dynamic>> checkOut() async {
    String? token = await _getToken();
    if (token == null) return {'success': false, 'message': 'No token found'};

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/attendance/check-out"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json"
        },
      );

      final data = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? 'Unknown error',
      };
    } catch (e) {
      return {'success': false, 'message': 'Error during check-out: $e'};
    }
  }

  static Future<List<AttendanceModel>> getAttendance() async {
    String? token = await _getToken();
    if (token == null) {
      print("No token found");
      return []; // ✅ Return an empty list instead of a map
    }

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/attendance"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json"
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> attendanceJson =
            jsonDecode(response.body)["attendance"] ?? [];
        print("Token: $token");
        return attendanceJson
            .map((json) => AttendanceModel.fromJson(json))
            .toList();
      } else {
        print("Error response: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error fetching attendance: $e");
      return [];
    }
  }
}
