// payment_service.dart

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/payment_model.dart';
import 'dart:io'; // For File handling

class PaymentService {
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
    String? token = prefs.getString('token');
    print("DEBUG: Retrieved Token: $token");
    return token;
  }

  /// Fetch payments from the API
  Future<List<PaymentModel>> fetchPayments() async {
    try {
      final String? token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception("Unauthorized: Please log in.");
      }

      print("DEBUG: Fetching payments with token: $token");
      final response = await _dio.get(
        "payments",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      print("DEBUG: Response status: ${response.statusCode}");
      print("DEBUG: Response data: ${response.data}");

      if (response.statusCode == 200) {
        List<dynamic> paymentsJson = response.data['payments'] ?? [];
        print("DEBUG: Payments JSON: $paymentsJson");
        List<PaymentModel> payments = paymentsJson.map((json) {
          print("DEBUG: Parsing JSON: $json");
          return PaymentModel.fromJson(json);
        }).toList();
        print("DEBUG: Parsed Payments: $payments");
        return payments;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again.');
      } else {
        throw Exception(
            "Server Error: ${response.statusCode} - ${response.data['message']}");
      }
    } on DioException catch (e) {
      print("DEBUG: DioException: ${e.message}");
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Session expired.');
      }
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      print("DEBUG: Unexpected error: $e");
      throw Exception("Unexpected error: $e");
    }
  }

  /// Process payment with the API
  /// Process payment with the API, including an optional payment slip
  Future<bool> makePayment({
    required double amount,
    required String paymentMethod,
    int? planId,
    File? paymentSlip, // Add payment slip as an optional parameter
  }) async {
    if (amount <= 0) throw Exception("Amount must be greater than 0");
    if (paymentMethod.isEmpty) throw Exception("Payment method is required");

    try {
      final String? token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception("Unauthorized: Please log in.");
      }

      // Create FormData to handle both file and text data
      FormData formData = FormData.fromMap({
        "amount": amount,
        "payment_method": paymentMethod,
        if (planId != null) "plan_id": planId,
        if (paymentSlip != null)
          "payment_slip": await MultipartFile.fromFile(
            paymentSlip.path,
            filename: paymentSlip.path.split('/').last,
          ),
      });

      print(
          "DEBUG: Making payment with token: $token, amount: $amount, method: $paymentMethod, slip: ${paymentSlip?.path}");
      final response = await _dio.post(
        "payments/pay",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: formData,
      );

      print(
          "DEBUG: Payment response: ${response.statusCode} - ${response.data}");
      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception(
            "Payment Failed: ${response.data['message'] ?? 'Unknown error'}");
      }
    } on DioException catch (e) {
      print("DEBUG: DioException in makePayment: ${e.message}");
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Session expired.');
      }
      throw Exception(
          "Payment failed: ${e.response?.data['message'] ?? e.message}");
    }
  }
}
