import 'package:flutter/material.dart';
import 'package:e_library/models/book.dart';
import 'package:e_library/components/book_card.dart'; // atau BookCard biasa jika beda tampilan
import 'package:e_library/utils/colors.dart';

class CategoryBooksPage extends StatelessWidget {
  final String category;
  final List<Book> books;

  const CategoryBooksPage({
    super.key,
    required this.category,
    required this.books,
  });

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
        title: const Text(
          'Pustaka',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'InterBold',
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: books.isEmpty
            ? const Center(child: Text('Tidak ada buku dalam kategori ini.'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Buku $category',
                    style: TextStyle(
                      fontSize: 24,
                      color: primaryColor,
                      fontFamily: 'InterBold',
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Daftar Buku $category pada Perpustakaan Himpelmanawaka',
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                      fontFamily: 'InterMedium',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: BookCard(
                            bookId: book.id,
                            image: book.coverUrl ?? '',
                            title: book.title.isNotEmpty
                                ? book.title
                                : 'Judul tidak tersedia',
                            author: book.author.isNotEmpty
                                ? book.author
                                : 'Penulis tidak diketahui',
                            year: book.createdAt?.year.toString() ?? '',
                            averageRating:
                                book.averageRating?.toString() ?? '0.0',
                            description:
                                book.description ?? 'Penulis tidak diketahui',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
