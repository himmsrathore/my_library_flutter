import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LibraryAdminService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl:
          "http://10.0.2.2/library/library/public/api/", // Update if needed
      headers: {'Accept': 'application/json'},
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  /// Retrieve the authentication token from SharedPreferences
  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Fetch Library Admin Details
  Future<Map<String, dynamic>> fetchLibraryDetails() async {
    return await _getData("library_admin");
  }

  /// Fetch Books for Library Admin
  Future<List<dynamic>> fetchBooks() async {
    return await _getData("library_admin/books");
  }

  /// Fetch Gallery Images for Library Admin
  Future<List<dynamic>> fetchGallery() async {
    return await _getData("library_admin/gallery");
  }

  /// Fetch Banners for Library Admin
  Future<List<dynamic>> fetchBanners() async {
    return await _getData("library_admin/banners");
  }

  /// General function to fetch data
  Future<dynamic> _getData(String endpoint) async {
    try {
      final String? token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception("Unauthorized: Please log in.");
      }

      final response = await _dio.get(
        endpoint,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 401) {
        await _logoutUser(); // Handle expired tokens
        throw Exception("Session expired. Please log in again.");
      }

      if (response.statusCode == 200) {
        return response.data; // Successfully fetched data
      } else {
        throw Exception("Failed to load data: ${response.data}");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    }
  }

  /// Log out user by clearing the stored token
  Future<void> _logoutUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Clear the token
  }
}
