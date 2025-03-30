// models/book_model.dart
class BookModel {
  final int id;
  final int libraryId;
  final int userId;
  final String title;
  final String type;
  final String category;
  final String file;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BookModel({
    required this.id,
    required this.libraryId,
    required this.userId,
    required this.title,
    required this.type,
    required this.category,
    required this.file,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    const String baseUrl =
        "http://10.0.2.2/library/library/public/storage/"; // ✅ Change this to match your API

    return BookModel(
      id: json['id'],
      libraryId: json['library_id'],
      userId: json['user_id'],
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      category: json['category'] ?? '',
      file:
          json['file'] != null ? baseUrl + json['file'] : '', // ✅ Fix file URL
      description: json['description'] ?? '',
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
      'type': type,
      'category': category,
      'file': file,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

/*

[
    {
        "id": 1,
        "library_id": 1,
        "user_id": 27,
        "title": "sdasd",
        "type": "PDF",
        "category": "FD",
        "file": "books/pUQ8i3KkI9wikSpqSuhNvXwUTH4RtTNZJPOSnkrj.pdf",
        "description": "534534",
        "created_at": "2025-03-29T08:39:02.000000Z",
        "updated_at": "2025-03-29T08:39:20.000000Z"
    }
]
*/
