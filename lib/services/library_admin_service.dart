import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LibraryAdminService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl:
          "http://10.0.2.2/library/library/public/api/", // Update to your Laravel API
      headers: {'Accept': 'application/json'},
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  /// Get the authentication token from SharedPreferences
  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Fetch Library Details
  Future<Map<String, dynamic>> fetchLibraryDetails() async {
    try {
      final String? token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception("Unauthorized: Please log in.");
      }

      print("DEBUG: Fetching library details with token: $token");

      final response = await _dio.get(
        "library",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      print("DEBUG: Response status: ${response.statusCode}");
      print("DEBUG: Response data: ${response.data}");

      if (response.statusCode == 200) {
        return response.data; // Return library details
      } else {
        throw Exception("Failed to load library: ${response.data}");
      }
    } on DioException catch (e) {
      print("DEBUG: DioException: ${e.message}");
      throw Exception("Network error: ${e.message}");
    }
  }
}
