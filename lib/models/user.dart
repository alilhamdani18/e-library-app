class User {
  final String? username;
  final String uid;
  final String email;
  final String? name;
  final String? phone;
  final String? address;
  final String? profileImageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.username,
    required this.uid,
    required this.email,
    this.name,
    this.phone,
    this.address,
    this.profileImageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final createdAtJson = json['createdAt'];
    DateTime? createdAt;

    if (createdAtJson is Map<String, dynamic> &&
        createdAtJson.containsKey('_seconds')) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(
          (createdAtJson['_seconds'] as int) * 1000);
    }

    return User(
      username: json['username']?.toString() ?? '',
      uid: json['uid']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString(),
      phone: json['phone']?.toString(),
      address: json['address']?.toString(),
      profileImageUrl: json['profileImageUrl']?.toString(),
      createdAt: createdAt,
      updatedAt: null, // Tidak tersedia di respons kamu
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
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

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
