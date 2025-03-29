// models/gallery_model.dart
class GalleryModel {
  final int id;
  final int libraryId;
  final int userId;
  final String title;
  final String image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GalleryModel({
    required this.id,
    required this.libraryId,
    required this.userId,
    required this.title,
    required this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory GalleryModel.fromJson(Map<String, dynamic> json) {
    return GalleryModel(
      id: json['id'],
      libraryId: json['library_id'],
      userId: json['user_id'],
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'library_id': libraryId,
      'user_id': userId,
      'title': title,
      'image': image,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
