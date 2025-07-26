import 'package:e_library/utils/colors.dart';
import 'package:e_library/views/main_screen.dart';
import 'package:e_library/components/book_card.dart';
import 'package:e_library/components/book_card_slide.dart';
import 'package:e_library/views/pages/library/category_page.dart';
import 'package:flutter/material.dart';
import 'package:e_library/components/book_category.dart';
import 'package:e_library/services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_library/models/book.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ApiService _apiService = ApiService();
  List<Book> booksFromApi = [];
  List<String> displayedCategories = [];
  bool isLoadingBooks = false;
  String errorMessage = '';

  User? _currentUser;
  Map<String, dynamic>? _userData;

  final List<String> primaryCategories = [
    'Islamic',
    'Novel',
    'Pendidikan',
    'Motivation',
    'Kitab',
  ];

  final Map<String, IconData> categoryIconsMap = {
    'Islamic': Icons.mosque_sharp,
    'Novel': Icons.auto_stories,
    'Pendidikan': Icons.science,
    'Motivation': Icons.person,
    'Kitab': Icons.menu_book_rounded,
    'Lainnya': Icons.reorder_sharp,
  };

  final Map<String, Color> categoryColorsMap = {
    'Islamic': Colors.green,
    'Novel': Colors.pink,
    'Pendidikan': Colors.amber,
    'Motivation': Colors.blue,
    'Kitab': Colors.orange,
    'Lainnya': Colors.grey,
  };

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _fetchUserData();
    loadBooksAndProcessCategories();
  }

  Future<void> _fetchUserData() async {
    if (_currentUser != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .get();
        if (doc.exists) {
          setState(() {
            _userData = doc.data();
          });
        } else {
          setState(() {
            _userData = null;
          });
        }
      } catch (e) {
        print('Error fetching user data');
      }
    } else {
      setState(() {
        _userData = null;
      });
    }
  }

  Future<void> loadBooksAndProcessCategories() async {
    setState(() {
      isLoadingBooks = true;
      errorMessage = '';
      displayedCategories = [];
    });

    try {
      final List<Book> responseBooks = await _apiService.getBooks();

      Set<String> allUniqueBookCategoriesLower = {};
      for (var book in responseBooks) {
        if (book.category != null && book.category!.isNotEmpty) {
          allUniqueBookCategoriesLower.add(book.category!.toLowerCase());
        }
      }

      List<String> tempDisplayedCategories = [];
      Set<String> primaryCategoriesLowerSet =
          primaryCategories.map((e) => e.toLowerCase()).toSet();
      bool hasOtherCategory = false;

      for (String pCat in primaryCategories) {
        if (allUniqueBookCategoriesLower.contains(pCat.toLowerCase())) {
          tempDisplayedCategories.add(pCat);
        }
      }

      for (String bookCatLower in allUniqueBookCategoriesLower) {
        if (!primaryCategoriesLowerSet.contains(bookCatLower)) {
          hasOtherCategory = true;
          break;
        }
      }

      if (hasOtherCategory) {
        tempDisplayedCategories.add('Lainnya');
      }

      setState(() {
        booksFromApi = responseBooks;
        displayedCategories = tempDisplayedCategories;
        isLoadingBooks = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat data buku. Silakan coba lagi.';
        isLoadingBooks = false;
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

  Future<void> refreshAllData() async {
    await _fetchUserData();
    await loadBooksAndProcessCategories();
  }

  @override
  Widget build(BuildContext context) {
    final String userName = _userData?['name'] ?? 'Pengguna';
    final String userEmail = _currentUser?.email ?? 'user@example.com';
    final String profileImageUrl = _userData?['profileImageUrl'] ?? '';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        onRefresh: refreshAllData,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.network(
                            'https://storage.googleapis.com/image-bucket-app/logo.png',
                            width: 50),
                        // Image.asset('assets/images/logo.png', width: 50),
                        Text(
                          'E-Library',
                          style: TextStyle(
                              color: primaryColor,
                              fontFamily: 'InterBold',
                              fontSize: 24),
                        ),
                        TextButton(
                          onPressed: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) =>
                                    const MainScreen(initialIndex: 3)));
                            _fetchUserData();
                          },
                          child:
                              _buildProfileAvatar(profileImageUrl, userEmail),
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Selamat Datang, $userName',
                            style: TextStyle(
                                color: primaryColor,
                                fontFamily: 'InterBold',
                                fontSize: 22),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          'Cari Buku Apa hari ini ?',
                          style: TextStyle(
                            color: primaryColor,
                            fontFamily: 'InterMedium',
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor, primaryGradientColor],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Beragam Koleksi Buku Ada Dalam Genggamanmu',
                                  style: TextStyle(
                                      color: Colors.amber,
                                      fontFamily: 'InterBold',
                                      fontSize: 18),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const MainScreen(initialIndex: 1),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Jelajah Pustaka',
                                    style: TextStyle(color: primaryColor),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Image.network(
                            'https://storage.googleapis.com/image-bucket-app/book.png',
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                          // Image.asset('assets/images/book.png', height: 110),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'Kategori',
                          style: TextStyle(
                              color: primaryColor,
                              fontFamily: 'InterBold',
                              fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildCategorySection(),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'Recommended',
                          style: TextStyle(
                              color: primaryColor,
                              fontFamily: 'InterBold',
                              fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildRecommendedSection(),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Buku Lainnya',
                          style: TextStyle(
                              color: primaryColor,
                              fontFamily: 'InterBold',
                              fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) =>
                                    const MainScreen(initialIndex: 1)));
                          },
                          child: Text(
                            'Lihat Semua',
                            style: TextStyle(fontSize: 14, color: primaryColor),
                          ),
                        )
                      ],
                    ),
                    _buildBooksFromApiSection(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    if (isLoadingBooks) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return const SizedBox.shrink();
    }

    if (displayedCategories.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text(
          'Tidak ada kategori tersedia.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: displayedCategories.map((categoryName) {
          IconData icon = categoryIconsMap[categoryName] ?? Icons.category;
          Color color = categoryColorsMap[categoryName] ?? Colors.deepOrange;

          return BookCategory(
            icon: icon,
            color: color,
            label: categoryName,
            onTap: () {
              List<Book> filteredBooks;
              if (categoryName.toLowerCase() == 'lainnya') {
                final primaryCategoriesLower =
                    primaryCategories.map((e) => e.toLowerCase()).toSet();
                filteredBooks = booksFromApi
                    .where((book) =>
                        book.category != null &&
                        book.category!.isNotEmpty &&
                        !primaryCategoriesLower
                            .contains(book.category!.toLowerCase()))
                    .toList();
              } else {
                filteredBooks = booksFromApi
                    .where((book) =>
                        book.category != null &&
                        book.category!.toLowerCase() ==
                            categoryName.toLowerCase())
                    .toList();
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryBooksPage(
                    category: categoryName,
                    books: filteredBooks,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecommendedSection() {
    if (isLoadingBooks) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      );
    }

    if (booksFromApi.isEmpty || errorMessage.isNotEmpty) {
      return const SizedBox.shrink();
    }

    List<Book> sortedBooks = List.from(booksFromApi);
    sortedBooks.sort(
        (a, b) => (b.averageRating ?? 0.0).compareTo(a.averageRating ?? 0.0));
    final recommendedBooks = sortedBooks.take(5).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: recommendedBooks.map((book) {
          return BookCardSlide(
            bookId: book.id,
            image: book.coverUrl ?? '',
            author: book.author.isNotEmpty
                ? book.author
                : 'Penulis tidak diketahui',
            title: book.title.isNotEmpty ? book.title : 'Judul tidak tersedia',
          );
        }).toList(),
      ),
    );
  }

  // Build Component For Books From API Section
  Widget _buildBooksFromApiSection() {
    if (isLoadingBooks) {
      return Container(
        padding: const EdgeInsets.all(0),
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
              Text(
                'Memuat buku...',
                style:
                    TextStyle(color: primaryColor, fontFamily: 'InterMedium'),
              ),
            ],
          ),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 8),
            Text('Gagal memuat buku',
                style: TextStyle(
                    color: Colors.red, fontFamily: 'InterBold', fontSize: 16)),
            const SizedBox(height: 4),
            Text(
              errorMessage,
              style: TextStyle(
                  color: Colors.grey, fontFamily: 'InterMedium', fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loadBooksAndProcessCategories,
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: Text('Coba Lagi', style: TextStyle(color: textColor)),
            ),
          ],
        ),
      );
    }

    List<Book> sortedBooks = List.from(booksFromApi);
    sortedBooks.sort(
        (a, b) => (b.averageRating ?? 0.0).compareTo(a.averageRating ?? 0.0));

    final otherBooks = sortedBooks.skip(5).take(5).toList();

    if (otherBooks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            const Icon(Icons.book_outlined, color: Colors.grey, size: 48),
            const SizedBox(height: 8),
            Text('Belum ada buku tersedia di kategori ini',
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'InterMedium',
                    fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: otherBooks.length,
      itemBuilder: (context, index) {
        final book = otherBooks[index];
        return BookCard(
          bookId: book.id,
          image: book.coverUrl ?? '',
          title: book.title.isNotEmpty ? book.title : 'Judul tidak tersedia',
          author:
              book.author.isNotEmpty ? book.author : 'Penulis tidak diketahui',
          year: book.createdAt?.year.toString() ?? '',
          averageRating: book.averageRating?.toString() ?? '0.0',
          availableStock: book.availableStock,
        );
      },
    );
  }

  Widget _buildProfileAvatar(String? imageUrl, String email) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CircleAvatar(
        backgroundColor: primaryColor,
        backgroundImage: NetworkImage(imageUrl),
        radius: 20,
      );
    } else {
      String initial = '';
      if (email.isNotEmpty) {
        initial = email.substring(0, 1).toUpperCase();
      }
      return CircleAvatar(
        backgroundColor: primaryColor,
        radius: 20,
        child: Text(
          initial,
          style: TextStyle(color: textColor),
        ),
      );
    }
  }
}
