class User {
  final String? username;
  final String uid; 
  String email;
  final String? name;
  final String? phone;
  final String? address;
  String? profileImageUrl;
  final DateTime? createdAt;
  DateTime? updatedAt; 

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
    DateTime? parseTimestamp(dynamic timestampData) {
      if (timestampData is Map<String, dynamic> &&
          timestampData.containsKey('_seconds')) {
        return DateTime.fromMillisecondsSinceEpoch(
            (timestampData['_seconds'] as int) * 1000);
      } else if (timestampData is String) {
        return DateTime.tryParse(timestampData);
      }
      return null;
    }

    return User(
      username: json['username']?.toString(), 
      uid: json['uid']?.toString() ??
          json['id']?.toString() ??
          '', 
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString(),
      phone: json['phone']?.toString(),
      address: json['address']?.toString(),
      profileImageUrl: json['profileImageUrl']?.toString(),
      createdAt: parseTimestamp(json['createdAt']),
      updatedAt:
          parseTimestamp(json['updatedAt']), 
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
          updatedAt?.toIso8601String(), 
    };
  }
  User copyWith({
    String? username,
    String? uid,
    String? email,
    String? name,
    String? phone,
    String? address,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt, 
  }) {
    return User(
      username: username ?? this.username,
      uid: uid ??
          this.uid, 
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt, 
    );
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
