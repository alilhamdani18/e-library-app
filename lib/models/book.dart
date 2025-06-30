// lib/models/book.dart
class Book {
  final String id;
  final String title;
  final String author;
  final String? year;
  final num? availableStock;
  final String? description;
  final String? coverUrl;
  final double? averageRating;
  final int? pages;
  final String? category;
  final DateTime? createdAt;
  final DateTime? updateAt;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.year,
    this.availableStock,
    this.description,
    this.coverUrl,
    this.averageRating,
    this.pages,
    this.category,
    this.createdAt,
    this.updateAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      author: json['author']?.toString() ?? '',
      year: json['year']?.toString(),
      description: json['description']?.toString(),
      availableStock: json['availableStock'],
      coverUrl: json['coverUrl']?.toString(),
      averageRating: _parseDouble(json['averageRating']),
      pages: json['pages'] is int
          ? json['pages']
          : int.tryParse(json['pages']?.toString() ?? ''),
      category: json['category']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updateAt: json['updateAt'] != null
          ? DateTime.tryParse(json['updateAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'year': year,
      'availableStock': availableStock,
      'description': description,
      'coverUrl': coverUrl,
      'averageRating': averageRating,
      'pages': pages,
      'category': category,
      'createdAt': createdAt?.toIso8601String(),
      'updateAt': updateAt?.toIso8601String(),
    };
  }
}

// Response wrapper untuk API
class BookResponse {
  final bool success;
  final List<Book> data;
  final Map<String, dynamic>? pagination;

  BookResponse({
    required this.success,
    required this.data,
    this.pagination,
  });

  factory BookResponse.fromJson(Map<String, dynamic> json) {
    return BookResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => Book.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: json['pagination'] as Map<String, dynamic>?,
    );
  }
}

// Tambahkan fungsi bantu ini di luar class Book (atau bisa juga sebagai static method)
double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
