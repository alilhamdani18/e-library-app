import 'package:e_library/views/pages/library/category_page.dart';
import 'package:flutter/material.dart';
import 'package:e_library/components/book_card_slide.dart';
import 'package:e_library/models/book.dart';
import 'package:e_library/services/api_service.dart'; // pastikan file ini sudah ada
import 'package:e_library/utils/colors.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  final ApiService _apiService = ApiService();

  List<Book> allBooks = [];
  Map<String, List<Book>> categorizedBooks = {};
  bool isLoading = true;
  String errorMessage = '';

  final List<String> categories = ['Romance', 'Motivation', 'Novel', 'Manga'];

  @override
  void initState() {
    super.initState();
    getBooks();
  }

  Future<void> getBooks() async {
    // print('Mengambil data buku...');
    try {
      final books = await _apiService.getBooks();
      // print('Berhasil dapat ${books.length} buku');
      setState(() {
        allBooks = books;
        for (var category in categories) {
          categorizedBooks[category] =
              books.where((b) => b.category == category).toList();
        }
        isLoading = false;
      });
    } catch (e) {
      // print('Gagal mengambil buku: $e');
      // print(stackTrace);
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        body: Center(child: Text(errorMessage)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cari Buku Apa ?',
                      style: TextStyle(
                        color: primaryColor,
                        fontFamily: 'InterBold',
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Temukan buku yang kamu inginkan disini',
                      style: TextStyle(
                        color: primaryColor,
                        fontFamily: 'InterMedium',
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: greyBtnColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        SizedBox(width: 15),
                        Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Search',
                              filled: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.search,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Tampilkan buku berdasarkan kategori
            ...categorizedBooks.entries.map((entry) {
              final category = entry.key;
              final books = entry.value;

              if (books.isEmpty) return const SizedBox();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Buku $category',
                        style: TextStyle(
                          color: primaryColor,
                          fontFamily: 'InterBold',
                          fontSize: 18,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CategoryBooksPage(
                                category: category,
                                books: books,
                              ),
                            ),
                          );
                        },
                        child: const Text('Lihat Semua'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 230,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return BookCardSlide(
                          image: book.coverUrl ?? '',
                          title: book.title,
                          author: book.author,
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
