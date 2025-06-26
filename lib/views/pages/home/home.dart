// import 'package:e_library/models/list_book.dart';
import 'package:e_library/utils/colors.dart';
import 'package:e_library/views/main_screen.dart';
import 'package:e_library/components/book_card.dart';
import 'package:e_library/components/book_card_slide.dart';
import 'package:flutter/material.dart';
import 'package:e_library/models/category_book.dart';
import 'package:e_library/components/book_category.dart';
import 'package:e_library/services/api_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ApiService _apiService = ApiService();
  List<dynamic> booksFromApi = [];
  bool isLoadingBooks = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadBooksFromApi();
  }

  Future<void> loadBooksFromApi() async {
    setState(() {
      isLoadingBooks = true;
      errorMessage = '';
    });

    try {
      final response = await _apiService.getBooks();

      setState(() {
        booksFromApi = response;
        isLoadingBooks = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat buku: $e';
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

  Future<void> refreshBooks() async {
    await loadBooksFromApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        onRefresh: refreshBooks,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('assets/images/logo.png', width: 50),
                        Text(
                          'E-Library',
                          style: TextStyle(
                              color: primaryColor,
                              fontFamily: 'InterBold',
                              fontSize: 24),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) =>
                                    const MainScreen(initialIndex: 2)));
                          },
                          child: CircleAvatar(
                            backgroundColor: primaryColor,
                            child:
                                Text('A', style: TextStyle(color: textColor)),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Text(
                          'Selamat Datang',
                          style: TextStyle(
                              color: primaryColor,
                              fontFamily: 'InterBold',
                              fontSize: 24),
                        ),
                      ],
                    ),
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
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(16),
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
                                Text(
                                  'Beragam Koleksi Buku Ada Dalam Genggamanmu',
                                  style: TextStyle(
                                      color: Colors.amber,
                                      fontFamily: 'InterBold',
                                      fontSize: 20),
                                ),
                                SizedBox(height: 8),
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
                          Image.asset('assets/images/book.png', height: 120),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'Kategori',
                          style: TextStyle(
                              color: primaryColor,
                              fontFamily: 'InterBold',
                              fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categoryData
                            .map((e) => BookCategory(
                                  icon: e['icon'] as IconData,
                                  color: e['color'] as Color,
                                  label: e['label'] as String,
                                ))
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'Recommended',
                          style: TextStyle(
                              color: primaryColor,
                              fontFamily: 'InterBold',
                              fontSize: 18),
                        ),
                      ],
                    ),
                    // SizedBox(height: 10),
                    _buildRecommendedSection(),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Buku Lainnya',
                          style: TextStyle(
                              color: primaryColor,
                              fontFamily: 'InterBold',
                              fontSize: 20),
                        ),
                        Row(
                          children: [
                            // if (isLoadingBooks)
                            //   Container(
                            //     margin: EdgeInsets.only(right: 8),
                            //     child: SizedBox(
                            //       width: 16,
                            //       height: 16,
                            //       child: CircularProgressIndicator(
                            //         strokeWidth: 2,
                            //         valueColor: AlwaysStoppedAnimation<Color>(
                            //             primaryColor),
                            //       ),
                            //     ),
                            //   ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) =>
                                        const MainScreen(initialIndex: 1)));
                              },
                              child: Text(
                                'Lihat Semua',
                                style: TextStyle(
                                    fontSize: 16, color: primaryColor),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    // SizedBox(height: 5),
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

  Widget _buildRecommendedSection() {
    if (isLoadingBooks) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      );
    }

    if (booksFromApi.isEmpty || errorMessage.isNotEmpty) {
      return SizedBox.shrink();
    }

    final recommendedBooks = booksFromApi.take(5).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: recommendedBooks.map((book) {
          return BookCardSlide(
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

  Widget _buildBooksFromApiSection() {
    if (isLoadingBooks) {
      return Container(
        padding: EdgeInsets.all(0),
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
              // SizedBox(height: 16),
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
        padding: EdgeInsets.all(0),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: 8),
            Text('Gagal memuat buku',
                style: TextStyle(
                    color: Colors.red, fontFamily: 'InterBold', fontSize: 16)),
            SizedBox(height: 4),
            Text(
              errorMessage,
              style: TextStyle(
                  color: Colors.grey, fontFamily: 'InterMedium', fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: loadBooksFromApi,
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: Text('Coba Lagi', style: TextStyle(color: textColor)),
            ),
          ],
        ),
      );
    }

    final otherBooks = booksFromApi;

    if (otherBooks.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(0),
        child: Column(
          children: [
            Icon(Icons.book_outlined, color: Colors.grey, size: 48),
            SizedBox(height: 8),
            Text('Belum ada buku tersedia',
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'InterMedium',
                    fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: otherBooks.length,
      itemBuilder: (context, index) {
        final book = otherBooks[index];
        return BookCard(
          image: book.coverUrl ?? '',
          title: book.title.isNotEmpty ? book.title : 'Judul tidak tersedia',
          author:
              book.author.isNotEmpty ? book.author : 'Penulis tidak diketahui',
          year: book.createdAt?.year.toString() ?? '',
          rating: book.rating?.toString() ?? '0.0',
        );
      },
    );
  }
}
