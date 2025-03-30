import 'package:dio/dio.dart';
import '../models/student_model.dart';

class StudentService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://localhost/library/library/public/api/",
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  Future<StudentModel> fetchStudentDetails(String token) async {
    try {
      final response = await _dio.get(
        "student/details",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return StudentModel.fromJson(response.data);
      } else {
        throw Exception("Failed to load student details");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
