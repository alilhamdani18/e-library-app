import 'dart:convert';
import 'dart:io';
import 'package:e_library/models/book.dart';
import 'package:e_library/models/notification.dart';
import 'package:e_library/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://e-library-api-72451776465.asia-southeast2.run.app/api';

  // Headers untuk request
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Bookmark Methods
  Future<Map<String, dynamic>> addBookmark(
      String userId, Map<String, dynamic> bookmarkData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/books/$userId/bookmarks'),
        headers: _headers,
        body: jsonEncode(bookmarkData),
      );

      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          return {'message': decoded.toString()};
        }
      } else {
        throw Exception('Failed to add bookmark: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding bookmark: $e');
    }
  }

  Future<Map<String, dynamic>> removeBookmark(
      String userId, Map<String, dynamic> bookmarkData) async {
    try {
      final url = Uri.parse('$baseUrl/books/$userId/bookmarks');

      final request = http.Request("DELETE", url)
        ..headers.addAll(_headers)
        ..body = jsonEncode(bookmarkData);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to remove bookmark: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error removing bookmark: $e');
    }
  }

  Future<List<dynamic>> getUserBookmarks(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/books/$userId/bookmarks'),
        headers: _headers,
      );

      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return json['data'] ?? [];
      } else {
        throw Exception('Failed to get bookmarks: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting bookmarks: $e');
      return [];
    }
  }

  Future<bool> isBookBookmarked(String userId, String bookId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/books/$userId/bookmarks'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List bookmarks = json['data'] ?? [];

        print('Semua bookmarks: $bookmarks');
        final found = bookmarks.any((bookmark) =>
            bookmark['book'] != null &&
            bookmark['book']['id'].toString() == bookId);

        print('Bookmark status dari backend: $found');
        return found;
      } else {
        throw Exception('Failed to fetch bookmarks: ${response.statusCode}');
      }
    } catch (e) {
      print('Error checking bookmark: $e');
      return false;
    }
  }

  // Rating Methods
  Future<Map<String, dynamic>> addRating(
      String userId, Map<String, dynamic> ratingData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/books/$userId/ratings'),
        headers: _headers,
        body: jsonEncode(ratingData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to add rating: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding rating: $e');
    }
  }

  Future<Map<String, dynamic>> updateRating(
      String userId, String bookId, Map<String, dynamic> ratingData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/books/$userId/$bookId/ratings'),
        headers: _headers,
        body: jsonEncode(ratingData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update rating: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating rating: $e');
    }
  }

  Future<Map<String, dynamic>?> getRatingByUserAndBook(
      String userId, String bookId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/books/$userId/$bookId/ratings'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['data'];
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to fetch rating: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching rating: $e');
    }
  }

  Future<Map<String, dynamic>> deleteRating(
      String userId, String bookId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$userId/$bookId/ratings'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to delete rating: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting rating: $e');
    }
  }

  Future<List<dynamic>> getUserRatings(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$userId/ratings'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get ratings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting ratings: $e');
    }
  }

  // Loan Request Method
  Future<Map<String, dynamic>> requestLoan(
      Map<String, dynamic> loanData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/loans'),
        headers: _headers,
        body: jsonEncode(loanData),
      );
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to request loan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error requesting loan: $e');
    }
  }

  // User Profile Methods
  Future<User> getUserProfile(String userId) async {
    final uri = Uri.parse('$baseUrl/users/profile/$userId');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return User.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<User> updateUserProfile({
    required String userId,
    Map<String, dynamic>? profileData,
    File? profileImage,
  }) async {
    final uri = Uri.parse('$baseUrl/users/profile/$userId');
    final request = http.MultipartRequest('PUT', uri);

    if (profileData != null && profileData.isNotEmpty) {
      profileData.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });
    }

    if (profileImage != null) {
      final fileStream = http.ByteStream(profileImage.openRead());
      final length = await profileImage.length();

      final multipartFile = http.MultipartFile(
        'profileImage',
        fileStream,
        length,
        filename: profileImage.path.split('/').last,
      );

      request.files.add(multipartFile);
    }

    // Kirim request
    print('Sending request with file: ${profileImage?.path}');
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final decoded = json.decode(responseBody);

      return User.fromJson(decoded['data']);
    } else {
      final errorBody = await response.stream.bytesToString();
      throw Exception(
          'Failed to update user profile: ${response.statusCode}, $errorBody');
    }
  }

  Future<void> deleteUserProfile(String userId) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/users/$userId')); // Sesuaikan endpoint

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to delete user profile: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      debugPrint('Error in deleteUserProfile: $e');
      rethrow;
    }
  }

  // User Loan Methods
  Future<List<dynamic>> getUserLoanHistory(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/loans/user/$userId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final data = decoded['data'];

        print('API Response for loans: ${response.body}');
        if (data is List) {
          return data;
        } else {
          throw Exception('Unexpected response format: data is not a List');
        }
      } else {
        throw Exception('Failed to get loan history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting loan history: $e');
    }
  }

  Future<List<dynamic>> getUserCurrentLoans(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/loans/user/$userId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final data = decoded['data'];

        if (data is List) {
          return data;
        } else {
          throw Exception(
              'Unexpected response format: data is not a List in current loans');
        }
      } else {
        throw Exception('Failed to get current loans: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting current loans: $e');
    }
  }

  Future<List<Book>> getBooks() async {
    List<Book> allBooks = [];
    int currentPage = 1;
    bool hasMoreData = true;
    int _limitPerPage = 10;

    while (hasMoreData) {
      final uri =
          Uri.parse('$baseUrl/books?page=$currentPage&limit=$_limitPerPage');
      debugPrint('Fetching books from: $uri');

      try {
        final response = await http.get(uri);
        debugPrint('HTTP Response Status Code: ${response.statusCode}');
        debugPrint('HTTP Response Body: ${response.body}');

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          final bookResponse = BookResponse.fromJson(jsonData);

          if (bookResponse.success) {
            if (bookResponse.data.isNotEmpty) {
              allBooks.addAll(bookResponse.data);

              if (bookResponse.data.length < _limitPerPage) {
                hasMoreData = false;
                debugPrint(
                    'Reached end of data. Last page with ${bookResponse.data.length} books.');
              } else {
                currentPage++;
              }
            } else {
              hasMoreData = false;
              debugPrint('No more data found. Stopping pagination.');
            }
          } else {
            final errorMessage = jsonData['message'] ??
                'API returned success: false without specific message';
            debugPrint('API Error (Page $currentPage): $errorMessage');
            throw Exception('API returned success: false - $errorMessage');
          }
        } else {
          // Tangani status code non-200
          debugPrint(
              'Failed to load books from page $currentPage: ${response.statusCode}');
          throw Exception('Failed to load books: ${response.statusCode}');
        }
      } catch (e) {
        debugPrint('Error getting books from page $currentPage: $e');
        throw Exception('Error getting books: $e');
      }
    }

    debugPrint('Total books fetched: ${allBooks.length}');
    return allBooks;
  }

  Future<Map<String, dynamic>> getBookById(String bookId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/books/$bookId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get book details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting book details: $e');
    }
  }

  Future<List<dynamic>> searchBooks(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/books/search?query=${Uri.encodeComponent(query)}'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to search books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching books: $e');
    }
  }

  // Mengambil notifikasi pengguna dari koleksi NOTIFICATIONS
  Future<List<AppNotification>> getUserNotifications(String userId) async {
    try {
      final uri = Uri.parse('$baseUrl/notifications/user/$userId');
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['data'] is List) {
          return (responseData['data'] as List)
              .map((json) => AppNotification.fromJson(json))
              .toList();
        } else {
          throw Exception('Format respons notifikasi tidak valid.');
        }
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception(
            'Gagal memuat notifikasi: ${response.statusCode} - ${errorData['error'] ?? 'Unknown Error'}');
      }
    } catch (e) {
      print('Error fetching user notifications: $e');
      rethrow;
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final uri =
          Uri.parse('$baseUrl/notifications/$notificationId/mark-as-read');
      final response = await http.patch(
        uri,
        headers: _headers,
      );

      if (response.statusCode == 200) {
        print(
            'Notification with ID $notificationId marked as read successfully.');
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception(
            'Gagal menandai notifikasi sebagai terbaca: ${response.statusCode} - ${errorData['error'] ?? 'Unknown Error'}');
      }
    } catch (e) {
      print('Error marking notification as read: $e');
      rethrow;
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      final uri = Uri.parse('$baseUrl/notifications/$notificationId');
      final response = await http.delete(
        uri,
        headers: _headers,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print(
            'Notification with ID $notificationId deleted successfully from backend.');
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception(
            'Gagal menghapus notifikasi: ${response.statusCode} - ${errorData['error'] ?? 'Unknown Error'}');
      }
    } catch (e) {
      print('Error deleting notification: $e');
      rethrow;
    }
  }
}
