import 'package:e_library/components/book_card.dart';
import 'package:e_library/services/api_service.dart'; // Pastikan ini ada
import 'package:e_library/utils/colors.dart';
import 'package:flutter/material.dart';

class SavedBook extends StatefulWidget {
  final String userId;
  const SavedBook({super.key, required this.userId});

  @override
  State<SavedBook> createState() => _SavedBookState();
}

class _SavedBookState extends State<SavedBook> {
  late Future<List<dynamic>> _bookmarksFuture;

  @override
  void initState() {
    super.initState();
    _bookmarksFuture = ApiService().getUserBookmarks(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Buku Tersimpan',
          style: TextStyle(
              color: Colors.white, fontFamily: 'InterSemiBold', fontSize: 20),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _bookmarksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Gagal memuat data: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Tidak ada buku tersimpan.'),
            );
          } else {
            final bookmarks = snapshot.data!;
            return ListView(
              padding: EdgeInsets.all(16),
              children: bookmarks.map((e) {
                final book = e['book'];
                return BookCard(
                  bookId: book['id'],
                  image: book['coverUrl'],
                  title: book['title'],
                  author: book['author'],
                  year: book['year'].toString(),
                  averageRating: book['averageRating'].toString(),
                  description: book['description'],
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
