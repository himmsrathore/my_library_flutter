import 'dart:io';

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
    final response = await _getData("library_admin/banners");
    // Assuming the API returns a map like {"data": [banners], "status": "success"}
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      return response['data'] as List<dynamic>;
    }
    // If the response is already a list, return it directly
    if (response is List<dynamic>) {
      return response;
    }
    // Fallback: return an empty list if the structure is unexpected
    return [];
  }

  // New method to fetch subscription details
  Future<List<dynamic>> fetchSubscriptionDetails() async {
    final response = await _getData("subscription-details");
    // If the response is a list, return it directly
    if (response is List<dynamic>) {
      return response;
    }
    // If the response is a map (e.g., {"message": "No subscriptions found"}), return an empty list
    if (response is Map<String, dynamic>) {
      return [];
    }
    // Fallback: return an empty list for any unexpected response
    return [];
  }

  Future<Map<String, dynamic>> createSubscription({
    required String subscriptionPeriod,
    required double amount,
    required File paymentSlip,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final String? token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception("Unauthorized: Please log in.");
      }

      FormData formData = FormData.fromMap({
        'subscription_period': subscriptionPeriod,
        'amount': amount,
        'payment_slip': await MultipartFile.fromFile(
          paymentSlip.path,
          filename: paymentSlip.path.split('/').last,
        ),
        'start_date': startDate,
        'end_date': endDate,
      });

      final response = await _dio.post(
        "create-subscription",
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        await _logoutUser();
        throw Exception("Session expired. Please log in again.");
      } else {
        throw Exception(
            "Failed to create subscription: ${response.data['message'] ?? 'Unknown error'}");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    }
  }

  Future<List<dynamic>> fetchSeats() async {
    final response = await _getData("library_admin/seats");
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      return response['data'] as List<dynamic>;
    }
    if (response is List<dynamic>) {
      return response;
    }
    return [];
  }

  Future<Map<String, dynamic>> createSeat(String seatNumber) async {
    try {
      final String? token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception("Unauthorized: Please log in.");
      }

      final response = await _dio.post(
        "library_admin/seats",
        data: {'seat_number': seatNumber},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        await _logoutUser();
        throw Exception("Session expired. Please log in again.");
      } else {
        throw Exception(
            "Failed to create seat: ${response.data['message'] ?? 'Unknown error'}");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    }
  }

  Future<Map<String, dynamic>> updateSeat(
      int seatId, String seatNumber, bool isOccupied) async {
    try {
      final String? token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception("Unauthorized: Please log in.");
      }

      final response = await _dio.put(
        "library_admin/seats/$seatId",
        data: {
          'seat_number': seatNumber,
          'is_occupied': isOccupied,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        await _logoutUser();
        throw Exception("Session expired. Please log in again.");
      } else {
        throw Exception(
            "Failed to update seat: ${response.data['message'] ?? 'Unknown error'}");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    }
  }

  Future<Map<String, dynamic>> deleteSeat(int seatId) async {
    try {
      final String? token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception("Unauthorized: Please log in.");
      }

      final response = await _dio.delete(
        "library_admin/seats/$seatId",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        await _logoutUser();
        throw Exception("Session expired. Please log in again.");
      } else {
        throw Exception(
            "Failed to delete seat: ${response.data['message'] ?? 'Unknown error'}");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    }
  }

  Future<List<dynamic>> fetchPayments() async {
    final response = await _getData("library_admin/payments");
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      return response['data'] as List<dynamic>;
    }
    if (response is List<dynamic>) {
      return response;
    }
    return [];
  }

  Future<Map<String, dynamic>> updatePaymentStatus(
      int paymentId, String status) async {
    try {
      final String? token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception("Unauthorized: Please log in.");
      }

      final response = await _dio.post(
        "library_admin/payments/$paymentId/update-status",
        data: {'status': status},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        await _logoutUser();
        throw Exception("Session expired. Please log in again.");
      } else {
        throw Exception(
            "Failed to update payment status: ${response.data['message'] ?? 'Unknown error'}");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    }
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
