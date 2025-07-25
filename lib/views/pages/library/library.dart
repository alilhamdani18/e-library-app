import 'package:e_library/components/book_card.dart';
import 'package:e_library/views/pages/library/category_page.dart';
import 'package:flutter/material.dart';
import 'package:e_library/components/book_card_slide.dart';
import 'package:e_library/models/book.dart';
import 'package:e_library/services/api_service.dart';
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

  final TextEditingController _searchController = TextEditingController();
  List<Book> _filteredBooks = [];

  final List<String> primaryCategories = [
    'Islamic',
    'Novel',
    'Motivation',
    'Pendidikan',
    'Kitab',
  ];

  final List<String> displayCategories = [
    'Islamic',
    'Novel',
    'Motivation',
    'Pendidikan',
    'Kitab',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    getBooks().then((_) {
      setState(() {
        _filteredBooks = allBooks;
      });
      _searchController.addListener(_onSearchChanged);
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> getBooks() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      final books = await _apiService.getBooks();
      setState(() {
        allBooks = books;
        categorizedBooks.clear();
        for (var category in primaryCategories) {
          categorizedBooks[category] = [];
        }
        categorizedBooks['Lainnya'] = [];
        for (var book in books) {
          bool assigned = false;
          if (book.category != null) {
            for (var category in primaryCategories) {
              if (book.category!.toLowerCase() == category.toLowerCase()) {
                categorizedBooks[category]!.add(book);
                assigned = true;
                break;
              }
            }
          }
          if (!assigned) {
            categorizedBooks['Lainnya']!.add(book);
          }
        }

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal mengambil buku: $e';
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onSearchChanged() {
    _filterBooks(_searchController.text);
  }

  void _filterBooks(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredBooks = allBooks;
      } else {
        final lowerCaseQuery = query.toLowerCase();
        _filteredBooks = allBooks.where((book) {
          final titleLower = book.title.toLowerCase();
          final authorLower = book.author.toLowerCase();

          return titleLower.contains(lowerCaseQuery) ||
              authorLower.contains(lowerCaseQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 8),
              Text(
                'Terjadi kesalahan',
                style: TextStyle(
                    color: Colors.red, fontFamily: 'InterBold', fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                errorMessage,
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'InterMedium',
                    fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: getBooks,
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                child: Text('Coba Lagi', style: TextStyle(color: textColor)),
              ),
            ],
          ),
        ),
      );
    }

    final bool isSearching = _searchController.text.isNotEmpty;

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
                      children: [
                        const SizedBox(width: 15),
                        const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Search by title or author...',
                              filled: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Container(
                //   decoration: BoxDecoration(
                //     color: primaryColor,
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   padding: const EdgeInsets.all(8),
                //   child: GestureDetector(
                //     onTap: () {
                //       _filterBooks(_searchController.text);
                //     },
                //     child: const Icon(
                //       Icons.search,
                //       size: 40,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 20),
            if (isSearching)
              _buildSearchResults()
            else
              // Loop melalui displayCategories untuk memastikan urutan yang diinginkan
              ...displayCategories.map((category) {
                final booksInCategory = categorizedBooks[category] ?? [];

                // Filter 5 buku pertama untuk tampilan slide
                final limitedBooks = booksInCategory.take(5).toList();

                if (limitedBooks.isEmpty && category != 'Lainnya') {
                  // Jangan tampilkan judul kategori jika tidak ada buku, kecuali untuk 'Lainnya' jika ingin selalu ada
                  return const SizedBox();
                }

                // Jika kategori Lainnya kosong, bisa juga disembunyikan
                if (category == 'Lainnya' && booksInCategory.isEmpty) {
                  return const SizedBox();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kategori $category',
                          style: TextStyle(
                            color: primaryColor,
                            fontFamily: 'InterBold',
                            fontSize: 18,
                          ),
                        ),
                        if (booksInCategory.length > 5)
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CategoryBooksPage(
                                    category: category,
                                    books:
                                        booksInCategory, // Kirim semua buku untuk kategori ini
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
                        // Gunakan limitedBooks untuk menampilkan hanya 5 buku
                        itemCount: limitedBooks.length,
                        itemBuilder: (context, index) {
                          final book = limitedBooks[index];
                          return BookCardSlide(
                            bookId: book.id,
                            image: book.coverUrl ?? '',
                            title: book.title,
                            author: book.author,
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                        height: 20), // Tambahkan spasi antar kategori
                  ],
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_filteredBooks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.sentiment_dissatisfied,
                size: 50, color: Colors.grey),
            const SizedBox(height: 10),
            Text(
              'Tidak ditemukan buku untuk "${_searchController.text}".',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: primaryColor),
            ),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hasil Pencarian untuk "${_searchController.text}"',
          style: TextStyle(
            color: primaryColor,
            fontFamily: 'InterBold',
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _filteredBooks.length,
          itemBuilder: (context, index) {
            final book = _filteredBooks[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: BookCard(
                bookId: book.id,
                image: book.coverUrl ?? '',
                title: book.title,
                author: book.author,
                year: book.year ?? '',
                averageRating: book.averageRating?.toString() ?? '0.0',
                availableStock: book.availableStock,
              ),
            );
          },
        ),
      ],
    );
  }
}
