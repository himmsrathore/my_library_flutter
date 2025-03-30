import 'package:flutter/material.dart';
import 'package:mylibrary/services/library_service.dart';
import 'package:mylibrary/models/banner_model.dart';
import 'package:mylibrary/models/book_model.dart';
import 'package:mylibrary/models/gallery_model.dart';
import 'package:mylibrary/models/library_model.dart';
import 'package:mylibrary/models/user_model.dart';
import 'package:url_launcher/url_launcher.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final LibraryService _libraryService = LibraryService();

  UserModel? user;
  LibraryModel? libraryDetails;
  List<BannerModel>? banners;
  List<GalleryModel>? galleryImages;
  List<BookModel>? books;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Use the service to fetch all data at once
      final data = await _libraryService.fetchAllHomeData();

      setState(() {
        user = data["user"] as UserModel?;
        libraryDetails = data["libraryDetails"] as LibraryModel?;
        banners = data["banners"] as List<BannerModel>?;
        galleryImages = data["galleryImages"] as List<GalleryModel>?;
        books = data["books"] as List<BookModel>?;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Info
                      Text(
                        "Welcome, ${user?.name ?? 'User'}!",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("Email: ${user?.email ?? 'N/A'}"),
                      Text("Library ID: ${user?.libraryId ?? 'N/A'}"),
                      SizedBox(height: 20),

                      // Library Details
                      Text(
                        "Library Details",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Name: ${libraryDetails?.name ?? 'N/A'}",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "Address: ${libraryDetails?.address ?? 'N/A'}",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),

                      // Banners
                      Text(
                        "Banners",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 10),
                      banners != null && banners!.isNotEmpty
                          ? Column(
                              children: banners!.map((banner) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Column(
                                    children: [
                                      Text(
                                        banner.title,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5),
                                      Image.network(
                                        banner
                                            .image, // ✅ Display image from API
                                        width: double.infinity,
                                        height: 150,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(Icons.broken_image,
                                                    size: 50,
                                                    color: Colors.red),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            )
                          : Text("No banners available"),
                      SizedBox(height: 20),

                      // Gallery Images
                      Text(
                        "Gallery",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 10),
                      galleryImages != null && galleryImages!.isNotEmpty
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    2, // ✅ Adjust the number of columns
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: galleryImages!.length,
                              itemBuilder: (context, index) {
                                final image = galleryImages![index];
                                return Column(
                                  children: [
                                    Text(
                                      image.title,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Image.network(
                                      image.image, // ✅ Load image from API
                                      width: double.infinity,
                                      height: 150,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                              Icons.broken_image,
                                              size: 50,
                                              color: Colors.red),
                                    ),
                                  ],
                                );
                              },
                            )
                          : Text("No gallery images available"),
                      SizedBox(height: 20),

                      // Books
                      Text(
                        "Books",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 10),
                      books != null && books!.isNotEmpty
                          ? Column(
                              children: books!.map((book) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Column(
                                    children: [
                                      Text(
                                        book.title,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5),
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          final Uri url = Uri.parse(book.file);
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url,
                                                mode: LaunchMode
                                                    .externalApplication);
                                          } else {
                                            print(
                                                "Could not launch ${book.file}");
                                          }
                                        },
                                        icon: Icon(Icons.download),
                                        label: Text("Download"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.teal,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            )
                          : Text("No books available"),

                      // Refresh button
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: fetchAllData,
                          child: Text("Refresh Data"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
