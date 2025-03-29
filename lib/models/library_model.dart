// models/library_model.dart
class LibraryModel {
  final int id;
  final String name;
  final String address;
  final String? contactInfo;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LibraryModel({
    required this.id,
    required this.name,
    required this.address,
    this.contactInfo,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory LibraryModel.fromJson(Map<String, dynamic> json) {
    return LibraryModel(
      id: json['id'],
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      contactInfo: json['contact_info'],
      description: json['description'],
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
      'name': name,
      'address': address,
      'contact_info': contactInfo,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
