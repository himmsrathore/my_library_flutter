import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student_model.dart';

class StudentService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2/library/library/public/api/",
      headers: {'Accept': 'application/json'},
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  /// Retrieves the authentication token from shared preferences.
  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // No need to print in production
  }

  /// Fetch student details from the API
  Future<StudentModel> fetchStudentDetails() async {
    try {
      final String? token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception("Unauthorized: Please log in.");
      }

      final response = await _dio.get(
        "student/details",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        return StudentModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again.');
      } else {
        throw Exception("Failed to fetch details: ${response.statusCode}");
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Session expired.');
      }
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
