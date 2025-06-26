import 'package:e_library/models/book.dart';
import 'package:e_library/services/api_service.dart';
import 'package:e_library/utils/colors.dart';
import 'package:e_library/views/pages/library/loan_book_sheet.dart';
import 'package:flutter/material.dart';

class DetailsBook extends StatefulWidget {
  final String bookId;

  const DetailsBook({super.key, required this.bookId});

  @override
  State<DetailsBook> createState() => _DetailsBookState();
}

class _DetailsBookState extends State<DetailsBook> {
  final ApiService _apiService = ApiService();
  Book? book;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookDetail();
  }

  Future<void> fetchBookDetail() async {
    try {
      final fetchedBook = await _apiService.getBookById(widget.bookId);
      print('Fetched book response: $fetchedBook');

      setState(() {
        book = Book.fromJson(fetchedBook['data']);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching book: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        title: Text(
          'Detail Buku',
          style: TextStyle(
              color: Colors.white, fontFamily: 'InterBold', fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // implement bookmark logic
            },
            icon: Icon(Icons.bookmark_border),
            color: Colors.white,
          )
        ],
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : book == null
              ? Center(child: Text('Gagal memuat data buku'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        color: primaryColor,
                        width: double.infinity,
                        child: Column(
                          children: [
                            Container(
                              width: 180,
                              height: 270,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: greyBtnColor,
                                boxShadow: [
                                  BoxShadow(
                                      color: const Color.fromARGB(
                                          255, 141, 249, 224),
                                      blurRadius: 7)
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: book!.coverUrl != null
                                    ? Image.network(
                                        book!.coverUrl!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset('assets/images/no_image.png'),
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(book!.title,
                                style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 24,
                                    fontFamily: 'InterBold')),
                            Text(book!.author,
                                style: TextStyle(
                                    color: textColor,
                                    fontSize: 14,
                                    fontFamily: 'InterSemiBold')),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => BottomSheetLoanBook(),
                                );
                              },
                              child: Text('Pinjam Buku',
                                  style: TextStyle(color: primaryColor)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _infoColumn(
                                    Icons.star,
                                    iconColor: Colors.amber,
                                    book!.rating?.toStringAsFixed(1) ?? '0.0',
                                    'Rating'),
                                _infoColumn(Icons.date_range,
                                    book!.year?.toString() ?? '-', 'Tahun'),
                                _infoColumn(Icons.description,
                                    book!.pages?.toString() ?? '-', 'Halaman'),
                              ],
                            ),
                            SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Sinopsis',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'InterBold',
                                      color: primaryColor)),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: greyBtnColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                book!.description ?? 'Tidak ada deskripsi.',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black87),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
    );
  }

  Widget _infoColumn(
    IconData icon,
    String value,
    String label, {
    Color? iconColor,
    Color? valueColor,
    Color? labelColor,
  }) {
    return Column(
      children: [
        Icon(icon, color: iconColor ?? primaryColor, size: 30),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: valueColor ?? Colors.black,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: labelColor ?? textGreyColor,
          ),
        ),
      ],
    );
  }
}
