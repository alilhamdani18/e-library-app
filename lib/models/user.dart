class User {
  final String? username;
  final String uid; // Menggunakan uid sebagai ID utama, bukan hanya 'id'
  String email;
  final String? name;
  final String? phone;
  final String? address;
  String? profileImageUrl;
  final DateTime? createdAt;
  DateTime? updatedAt; // Pastikan ini juga final

  User({
    this.username,
    required this.uid, // Pastikan ini required jika selalu ada
    required this.email, // Pastikan ini required jika selalu ada
    this.name,
    this.phone,
    this.address,
    this.profileImageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Helper function to parse Firestore Timestamps
    DateTime? parseTimestamp(dynamic timestampData) {
      if (timestampData is Map<String, dynamic> &&
          timestampData.containsKey('_seconds')) {
        return DateTime.fromMillisecondsSinceEpoch(
            (timestampData['_seconds'] as int) * 1000);
      } else if (timestampData is String) {
        // Handle ISO 8601 string if backend sends it directly
        return DateTime.tryParse(timestampData);
      }
      return null;
    }

    return User(
      username: json['username']?.toString(), // Opsional, bisa null
      uid: json['uid']?.toString() ??
          json['id']?.toString() ??
          '', // Ambil dari 'uid' atau 'id'
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString(),
      phone: json['phone']?.toString(),
      address: json['address']?.toString(),
      profileImageUrl: json['profileImageUrl']?.toString(),
      createdAt: parseTimestamp(json['createdAt']),
      updatedAt:
          parseTimestamp(json['updatedAt']), // <--- Sekarang parsing updatedAt
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'address': address,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt':
          updatedAt?.toIso8601String(), // <--- Sekarang menyertakan updatedAt
    };
  }

  // --- Metode copyWith ---
  User copyWith({
    String? username,
    String? uid,
    String? email,
    String? name,
    String? phone,
    String? address,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt, // Tambahkan updatedAt di copyWith
  }) {
    return User(
      username: username ?? this.username,
      uid: uid ??
          this.uid, // Pastikan UID juga bisa di-update jika diperlukan (walau jarang)
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt, // Gunakan updatedAt di copyWith
    );
  }
}

// Tidak ada perubahan pada UserResponse dan SingleUserResponse
// karena mereka sudah bekerja dengan List<User> atau User tunggal
// dan parsing JSON mereka tampak sudah benar untuk struktur respons Anda.

class UserResponse {
  final bool success;
  final List<User> data;
  final Map<String, dynamic>? pagination;

  UserResponse({
    required this.success,
    required this.data,
    this.pagination,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => User.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: json['pagination'] as Map<String, dynamic>?,
    );
  }
}

class SingleUserResponse {
  final bool success;
  final String? message;
  final User data;

  SingleUserResponse({
    required this.success,
    required this.data,
    this.message,
  });

  factory SingleUserResponse.fromJson(Map<String, dynamic> json) {
    return SingleUserResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: User.fromJson(json['data']),
    );
  }
}
