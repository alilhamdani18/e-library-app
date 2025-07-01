// lib/models/notification.dart

class AppNotification {
  final String id;
  final String userId;
  final String? loanId; // Bisa null jika notifikasi tidak terkait loan
  final String message;
  final String type; // e.g., 'loan_approved', 'loan_rejected', 'book_returned'
  final String librarianName;
  final String? librarianProfileImageUrl;
  final bool isRead;
  final DateTime timestamp;

  AppNotification({
    required this.id,
    required this.userId,
    this.loanId,
    required this.message,
    required this.type,
    required this.librarianName,
    this.librarianProfileImageUrl,
    required this.isRead,
    required this.timestamp,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      userId: json['userId'] as String,
      loanId: json['loanId'] as String?, // Firestore mengirimkan null jika tidak ada
      message: json['message'] as String,
      type: json['type'] as String,
      librarianName: json['librarianName'] as String,
      librarianProfileImageUrl: json['librarianProfileImageUrl'] as String?,
      isRead: json['isRead'] as bool,
      // Konversi timestamp dari Firestore (jika berupa map { _seconds, _nanoseconds }) atau String ISO
      timestamp: json['timestamp'] is Map
          ? DateTime.fromMillisecondsSinceEpoch(json['timestamp']['_seconds'] * 1000)
          : DateTime.parse(json['timestamp'].toString()), // Jika backend mengembalikan ISO string
    );
  }

  AppNotification copyWith({
    String? id,
    String? userId,
    String? loanId,
    String? message,
    String? type,
    String? librarianName,
    String? librarianProfileImageUrl,
    bool? isRead,
    DateTime? timestamp,
  }) {
    return AppNotification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      loanId: loanId ?? this.loanId,
      message: message ?? this.message,
      type: type ?? this.type,
      librarianName: librarianName ?? this.librarianName,
      librarianProfileImageUrl:
          librarianProfileImageUrl ?? this.librarianProfileImageUrl,
      isRead: isRead ?? this.isRead,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}