import 'dart:convert';
import 'dart:io';
import 'package:e_library/models/book.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://library-backend-72451776465.asia-southeast2.run.app/api';

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
        Uri.parse('$baseUrl/$userId/bookmarks'),
        headers: _headers,
        body: jsonEncode(bookmarkData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
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
      final response = await http.delete(
        Uri.parse('$baseUrl/$userId/bookmarks'),
        headers: _headers,
        body: jsonEncode(bookmarkData),
      );

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
        Uri.parse('$baseUrl/$userId/bookmarks'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get bookmarks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting bookmarks: $e');
    }
  }

  // Rating Methods
  Future<Map<String, dynamic>> addRating(
      String userId, Map<String, dynamic> ratingData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$userId/ratings'),
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
        Uri.parse('$baseUrl/$userId/$bookId/ratings'),
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
        Uri.parse('$baseUrl/'),
        headers: _headers,
        body: jsonEncode(loanData),
      );

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
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile/$userId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get user profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting user profile: $e');
    }
  }

  Future<Map<String, dynamic>> updateUserProfile(
      String userId, Map<String, dynamic> profileData,
      {File? profileImage}) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/profile/$userId'),
      );

      // Add form fields
      profileData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add profile image if provided
      if (profileImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('profileImage', profileImage.path),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to update user profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating user profile: $e');
    }
  }

  // User Loan Methods
  Future<List<dynamic>> getUserLoanHistory(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/loans/$userId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
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
