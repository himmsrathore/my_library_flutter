class BannerModel {
  final int id;
  final int libraryId;
  final int userId;
  final String title;
  final String image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BannerModel({
    required this.id,
    required this.libraryId,
    required this.userId,
    required this.title,
    required this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    const String baseUrl =
        "http://10.0.2.2/library/library/public/storage/"; // ✅ Change to your API domain

    return BannerModel(
      id: json['id'],
      libraryId: json['library_id'],
      userId: json['user_id'],
      title: json['title'] ?? '',
      image: json['image'] != null
          ? baseUrl + json['image']
          : '', // ✅ Fix image URL
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



/*
SAMPLE JSON

[
    {
        "id": 2,
        "library_id": 1,
        "user_id": 27,
        "title": "sdfsdf",
        "image": "banners/f6rNCvKOXx7XxPlRQ0tqZLrzVuOtKkxwGn7LSW6s.png",
        "created_at": "2025-03-29T09:52:26.000000Z",
        "updated_at": "2025-03-29T09:52:26.000000Z"
    },
    {
        "id": 3,
        "library_id": 1,
        "user_id": 27,
        "title": "sdfsd",
        "image": "banners/u78pFJxuH5Jz6jJerkqu73Ma83iEwQuJRxImEyR5.png",
        "created_at": "2025-03-29T09:52:43.000000Z",
        "updated_at": "2025-03-29T09:52:43.000000Z"
    }
]
*/