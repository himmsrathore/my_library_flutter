import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Import model classes
import 'package:mylibrary/models/banner_model.dart';
import 'package:mylibrary/models/book_model.dart';
import 'package:mylibrary/models/gallery_model.dart';
import 'package:mylibrary/models/library_model.dart';
import 'package:mylibrary/models/user_model.dart';

class LibraryService {
  // Base URL for API endpoints
  static const String baseUrl = "http://10.0.2.2/library/library/public/api";

  // Get authentication token from shared preferences
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // Create HTTP headers with authentication token
  Future<Map<String, String>> _getHeaders() async {
    String? token = await _getToken();
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  // Handle HTTP responses and throw meaningful errors
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'API Error: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }

  // Fetch library details
  Future<LibraryModel> getLibraryDetails() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse("$baseUrl/library"),
      headers: headers,
    );
    final jsonData = _handleResponse(response);
    return LibraryModel.fromJson(jsonData);
  }

  // Fetch banners
  Future<List<BannerModel>> getBanners() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse("$baseUrl/library/banners"),
      headers: headers,
    );
    final jsonData = _handleResponse(response) as List<dynamic>;
    return jsonData.map((item) => BannerModel.fromJson(item)).toList();
  }

  // Fetch gallery images
  Future<List<GalleryModel>> getGalleryImages() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse("$baseUrl/library/gallery"),
      headers: headers,
    );
    final jsonData = _handleResponse(response) as List<dynamic>;
    return jsonData.map((item) => GalleryModel.fromJson(item)).toList();
  }

  // Fetch books
  Future<List<BookModel>> getBooks() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse("$baseUrl/library/books"),
      headers: headers,
    );
    final jsonData = _handleResponse(response) as List<dynamic>;
    return jsonData.map((item) => BookModel.fromJson(item)).toList();
  }

  // Fetch user details from shared preferences
  Future<UserModel?> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString("user");
    if (userData != null) {
      Map<String, dynamic> userMap = jsonDecode(userData);
      return UserModel.fromJson(userMap);
    }
    return null;
  }

  // Fetch all data at once for the home screen
  Future<Map<String, dynamic>> fetchAllHomeData() async {
    try {
      // Check if token exists
      String? token = await _getToken();
      if (token == null) {
        throw Exception("No authentication token found");
      }

      // Fetch user details
      final user = await getUserDetails();

      // Fetch all other data in parallel
      final results = await Future.wait([
        getLibraryDetails(),
        getBanners(),
        getGalleryImages(),
        getBooks(),
      ]);

      // Return all data in a structured format
      return {
        "user": user,
        "libraryDetails": results[0],
        "banners": results[1],
        "galleryImages": results[2],
        "books": results[3],
      };
    } catch (e) {
      throw Exception("Failed to fetch data: $e");
    }
  }

  // Add a book to the library
  Future<BookModel> addBook({
    required String title,
    required String type,
    required String category,
    required String description,
    required String filePath,
  }) async {
    final headers = await _getHeaders();

    final response = await http.post(
      Uri.parse("$baseUrl/library/books"),
      headers: headers,
      body: jsonEncode({
        "title": title,
        "type": type,
        "category": category,
        "description": description,
        "file": filePath,
      }),
    );

    final jsonData = _handleResponse(response);
    return BookModel.fromJson(jsonData);
  }

  // Update a book
  Future<BookModel> updateBook({
    required int bookId,
    String? title,
    String? type,
    String? category,
    String? description,
    String? filePath,
  }) async {
    final headers = await _getHeaders();

    // Build request body with only the fields that are provided
    Map<String, dynamic> requestBody = {};
    if (title != null) requestBody["title"] = title;
    if (type != null) requestBody["type"] = type;
    if (category != null) requestBody["category"] = category;
    if (description != null) requestBody["description"] = description;
    if (filePath != null) requestBody["file"] = filePath;

    final response = await http.put(
      Uri.parse("$baseUrl/library/books/$bookId"),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    final jsonData = _handleResponse(response);
    return BookModel.fromJson(jsonData);
  }

  // Delete a book
  Future<bool> deleteBook(int bookId) async {
    final headers = await _getHeaders();

    final response = await http.delete(
      Uri.parse("$baseUrl/library/books/$bookId"),
      headers: headers,
    );

    return response.statusCode >= 200 && response.statusCode < 300;
  }

  // Add a banner
  Future<BannerModel> addBanner({
    required String title,
    required String imagePath,
  }) async {
    final headers = await _getHeaders();

    final response = await http.post(
      Uri.parse("$baseUrl/library/banners"),
      headers: headers,
      body: jsonEncode({
        "title": title,
        "image": imagePath,
      }),
    );

    final jsonData = _handleResponse(response);
    return BannerModel.fromJson(jsonData);
  }

  // Update a banner
  Future<BannerModel> updateBanner({
    required int bannerId,
    String? title,
    String? imagePath,
  }) async {
    final headers = await _getHeaders();

    Map<String, dynamic> requestBody = {};
    if (title != null) requestBody["title"] = title;
    if (imagePath != null) requestBody["image"] = imagePath;

    final response = await http.put(
      Uri.parse("$baseUrl/library/banners/$bannerId"),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    final jsonData = _handleResponse(response);
    return BannerModel.fromJson(jsonData);
  }

  // Delete a banner
  Future<bool> deleteBanner(int bannerId) async {
    final headers = await _getHeaders();

    final response = await http.delete(
      Uri.parse("$baseUrl/library/banners/$bannerId"),
      headers: headers,
    );

    return response.statusCode >= 200 && response.statusCode < 300;
  }

  // Add a gallery image
  Future<GalleryModel> addGalleryImage({
    required String title,
    required String imagePath,
  }) async {
    final headers = await _getHeaders();

    final response = await http.post(
      Uri.parse("$baseUrl/library/gallery"),
      headers: headers,
      body: jsonEncode({
        "title": title,
        "image": imagePath,
      }),
    );

    final jsonData = _handleResponse(response);
    return GalleryModel.fromJson(jsonData);
  }

  // Update a gallery image
  Future<GalleryModel> updateGalleryImage({
    required int galleryId,
    String? title,
    String? imagePath,
  }) async {
    final headers = await _getHeaders();

    Map<String, dynamic> requestBody = {};
    if (title != null) requestBody["title"] = title;
    if (imagePath != null) requestBody["image"] = imagePath;

    final response = await http.put(
      Uri.parse("$baseUrl/library/gallery/$galleryId"),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    final jsonData = _handleResponse(response);
    return GalleryModel.fromJson(jsonData);
  }

  // Delete a gallery image
  Future<bool> deleteGalleryImage(int galleryId) async {
    final headers = await _getHeaders();

    final response = await http.delete(
      Uri.parse("$baseUrl/library/gallery/$galleryId"),
      headers: headers,
    );

    return response.statusCode >= 200 && response.statusCode < 300;
  }

  updateUserProfile(UserModel updatedUser) {}

  logout() {}
}
