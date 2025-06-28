import 'dart:convert';
import 'dart:io';
import 'package:e_library/models/book.dart';
import 'package:e_library/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://e-library-backend-72451776465.asia-southeast2.run.app/api';

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
      return []; // ✅ Jangan return null, return list kosong jika error
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
        headers:
            _headers, // Pastikan kamu punya header ini kalau perlu Authorization, dll.
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['data']; // Ambil hanya bagian `data` untuk kemudahan
      } else if (response.statusCode == 404) {
        return null; // Belum pernah memberi rating
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
      return User.fromJson(jsonData['data']); // hanya ambil isi data
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
      final multipartFile = await http.MultipartFile.fromPath(
        'profileImage',
        profileImage.path,
      );
      request.files.add(multipartFile);
    }

    try {
      final streamedResponse = await request.send();
      final res = await http.Response.fromStream(streamedResponse);

      debugPrint('Status Code: ${res.statusCode}');
      debugPrint('Response Body: ${res.body}');

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final userResponse = SingleUserResponse.fromJson(
            data); // ✅ ganti 'responseJson' jadi 'data'
        return userResponse.data;
      } else {
        throw Exception(
            'Gagal update profile. Status: ${res.statusCode}, Body: ${res.body}');
      }
    } catch (e, stackTrace) {
      debugPrint('Exception saat update: $e');
      debugPrint('StackTrace: $stackTrace');
      throw Exception('Gagal update profile: ${e.toString()}');
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
        Uri.parse('$baseUrl/current-loans/$userId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get current loans: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting current loans: $e');
    }
  }

  // Books Methods - Tambahan untuk mendapatkan daftar buku
  Future<List<Book>> getBooks() async {
    try {
      final uri = Uri.parse('$baseUrl/books');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final bookResponse = BookResponse.fromJson(jsonData);
        if (bookResponse.success) {
          return bookResponse.data;
        } else {
          throw Exception('API returned success: false');
        }
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting books: $e');
    }
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
}
