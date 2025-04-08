import 'package:flutter/material.dart';
import 'package:mylibrary/services/library_service.dart';
import 'package:mylibrary/models/banner_model.dart';
import 'package:mylibrary/models/book_model.dart';
import 'package:mylibrary/models/gallery_model.dart';
import 'package:mylibrary/models/library_model.dart';
import 'package:mylibrary/models/user_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import '../user_profile_screen.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final LibraryService _libraryService = LibraryService();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? _buildLoadingState()
          : errorMessage != null
              ? _buildErrorState()
              : RefreshIndicator(
                  key: _refreshKey,
                  onRefresh: fetchAllData,
                  color: Color(0xFF3B82F6),
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      _buildAppBar(),
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildBannerSection(), // Banner carousel at the top
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildUserInfoSection(), // Student info card
                                  SizedBox(height: 16),
                                  Divider(
                                      thickness: 1, color: Colors.grey[300]),
                                  SizedBox(height: 16),
                                  _buildGallerySection(),
                                  SizedBox(height: 16),
                                  Divider(
                                      thickness: 1, color: Colors.grey[300]),
                                  SizedBox(height: 16),
                                  _buildBooksSection(),
                                  SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _refreshKey.currentState?.show(),
        backgroundColor: Color(0xFF3B82F6),
        shape: CircleBorder(),
        mini: true,
        child: Icon(Icons.refresh, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6))));
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 40, color: Color(0xFFF87171)),
            SizedBox(height: 8),
            Text("Something went wrong",
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF87171))),
            SizedBox(height: 4),
            Text(errorMessage!,
                style:
                    GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center),
            SizedBox(height: 16),
            TextButton(
                onPressed: fetchAllData,
                child: Text("Retry",
                    style: GoogleFonts.poppins(color: Color(0xFF3B82F6)))),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 100, // Fixed height
      floating: false,
      pinned: true,
      backgroundColor: Color(0xFF1E3A8A),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      title: Text(
        libraryDetails?.name?.toUpperCase() ?? "MY LIBRARY",
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.person_outline, color: Colors.white, size: 24),
          onPressed: () {
            if (user != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserProfileScreen(user: user!)));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("User profile not available")));
            }
          },
        ),
        SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBannerSection() {
    return Container(
      height: 160, // Fixed height for carousel
      child: (banners == null || banners!.isEmpty)
          ? _buildEmptyState("No announcements")
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: banners!.length,
              itemBuilder: (context, index) {
                final banner = banners![index];
                return Container(
                  width: MediaQuery.of(context).size.width *
                      0.8, // 80% of screen width
                  margin: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 4))
                    ],
                    border: Border.all(color: Colors.grey[200]!, width: 1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(banner.image, fit: BoxFit.cover),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.black.withOpacity(0.5),
                            child: Text(
                              banner.title,
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildUserInfoSection() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 4))
        ],
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFFBFDBFE),
            child: Text(
              user?.name?.substring(0, 1).toUpperCase() ?? "U",
              style:
                  GoogleFonts.poppins(fontSize: 20, color: Color(0xFF1E3A8A)),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? "User",
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E3A8A)),
                ),
                Divider(thickness: 1, color: Colors.grey[300], height: 8),
                Text("Email: ${user?.email ?? 'N/A'}",
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.grey[600])),
                Text("Library ID: ${user?.libraryId ?? 'N/A'}",
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.grey[600])),
                Text("Address: ${libraryDetails?.address ?? 'N/A'}",
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGallerySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Gallery",
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E3A8A))),
        SizedBox(height: 8),
        if (galleryImages == null || galleryImages!.isEmpty)
          _buildEmptyState("No gallery images")
        else
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: galleryImages!.length,
            itemBuilder: (context, index) {
              final image = galleryImages![index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 2))
                  ],
                  border: Border.all(color: Colors.grey[200]!, width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(image.image, fit: BoxFit.cover),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildBooksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Books",
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E3A8A))),
        SizedBox(height: 8),
        if (books == null || books!.isEmpty)
          _buildEmptyState("No books available")
        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: books!.length,
            itemBuilder: (context, index) {
              final book = books![index];
              return Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 2))
                  ],
                  border: Border.all(color: Colors.grey[200]!, width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Color(0xFFBFDBFE),
                          borderRadius: BorderRadius.circular(8)),
                      child:
                          Icon(Icons.book, color: Color(0xFF1E3A8A), size: 20),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        book.title,
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1E3A8A)),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final Uri url = Uri.parse(book.file);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        }
                      },
                      child: Text("Download",
                          style: GoogleFonts.poppins(
                              color: Color(0xFF3B82F6), fontSize: 12)),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Text(message,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
    );
  }
}
