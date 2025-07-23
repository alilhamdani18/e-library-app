import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_library/models/book.dart';
import 'package:e_library/services/api_service.dart';
import 'package:e_library/utils/colors.dart';
import 'package:e_library/utils/dialog.dart';
import 'package:e_library/views/pages/library/pdfViewer.dart';
import 'package:e_library/widgets/loan_book_sheet.dart';
import 'package:e_library/widgets/rating_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  bool isBookmarked = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    fetchBookDetail();
  }

  Future<void> fetchBookDetail() async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedBookData = await _apiService.getBookById(widget.bookId);
      final currentUser = FirebaseAuth.instance.currentUser;

      bool bookmarked = false;
      if (currentUser != null) {
        bookmarked =
            await _apiService.isBookBookmarked(currentUser.uid, widget.bookId);
      }

      setState(() {
        book = Book.fromJson(fetchedBookData['data']);
        isBookmarked = bookmarked;
        isLoading = false;
      });
      print('Data Buku: $book');
      print('Bookmark status dari backend: $bookmarked');
    } catch (e) {
      print('Error fetching book: $e');
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat detail buku: $e'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: textColor,
        ),
        title: Text(
          'Detail Buku',
          style: TextStyle(
              color: textColor, fontFamily: 'InterBold', fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final userId = FirebaseAuth.instance.currentUser?.uid;
              if (userId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Anda perlu login untuk menandai buku.'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }
              try {
                if (isBookmarked) {
                  await ApiService()
                      .removeBookmark(userId, {'bookId': widget.bookId});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Buku dihapus dari bookmark!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  await ApiService().addBookmark(userId, {
                    'bookId': widget.bookId,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Buku ditambahkan ke bookmark!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }

                setState(() {
                  isBookmarked = !isBookmarked;
                });
              } catch (e) {
                debugPrint('Error updating bookmark: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal memperbarui bookmark: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: textColor,
            ),
          )
        ],
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ))
          : book == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 48),
                      const SizedBox(height: 8),
                      const Text('Gagal memuat data buku.',
                          style: TextStyle(color: Colors.red, fontSize: 16)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: fetchBookDetail,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        child: Text('Coba Lagi',
                            style: TextStyle(color: textColor)),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: primaryColor,
                        width: double.infinity,
                        child: Column(
                          children: [
                            Container(
                              width: 180,
                              height: 270,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: greyBtnColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: book!.coverUrl != null &&
                                        book!.coverUrl!.isNotEmpty
                                    ? Image.network(
                                        book!.coverUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error,
                                                stackTrace) =>
                                            Image.asset(
                                                'assets/images/no_image.png',
                                                fit: BoxFit.cover),
                                      )
                                    : Image.asset('assets/images/no_image.png',
                                        fit: BoxFit.cover),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              book!.title.isNotEmpty
                                  ? book!.title
                                  : 'Judul Tidak Tersedia',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.amber,
                                  fontSize: 26,
                                  fontFamily: 'InterBold'),
                            ),
                            Text(
                              book!.author.isNotEmpty
                                  ? '${book!.author}'
                                  : 'Penulis Tidak Diketahui',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontFamily: 'InterMedium'),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final currentUser =
                                          FirebaseAuth.instance.currentUser;

                                      if (book == null || currentUser == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Anda perlu login untuk memberi rating.'),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                        return;
                                      }

                                      final userId = currentUser.uid;
                                      final bookId = book!.id;

                                      try {
                                        final existingRating =
                                            await ApiService()
                                                .getRatingByUserAndBook(
                                                    userId, bookId);

                                        if (!mounted) return;

                                        showRatingDialog(
                                            context: context,
                                            userId: userId,
                                            bookId: bookId,
                                            initialRating:
                                                existingRating?['rating']
                                                        ?.toDouble() ??
                                                    0.0,
                                            initialReview:
                                                existingRating?['review'] ?? '',
                                            isEdit: existingRating != null,
                                            ratingId: existingRating?['id'],
                                            onSuccess: () {
                                              fetchBookDetail();
                                            });
                                      } catch (e) {
                                        print('Error: $e');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Gagal membuka dialog rating: $e'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 223, 170, 11),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                    ),
                                    child: Text('Beri Rating',
                                        style: TextStyle(
                                            color: textColor,
                                            fontFamily: 'InterSemiBold')),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      final currentUser =
                                          FirebaseAuth.instance.currentUser;
                                      if (book != null && currentUser != null) {
                                        final userId = currentUser.uid;
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          isScrollControlled: true,
                                          builder: (context) =>
                                              BottomSheetLoanBook(
                                            bookId: book!.id,
                                            book: book!,
                                            userId: userId,
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Anda perlu login untuk meminjam buku.'),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                    ),
                                    child: Text('Pinjam Buku',
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontFamily: 'InterSemiBold')),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  // Tombol "Baca Buku"
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (book?.bookFileUrl != null &&
                                          book!.bookFileUrl!.isNotEmpty) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PdfBookViewerPage(
                                              bookId:
                                                  widget.bookId, // Kirim bookId
                                            ),
                                          ),
                                        );
                                      } else {
                                        showAwesomeLibraryDialog(context,
                                            title: 'Info',
                                            message:
                                                'File Pdf tidak tersedia untuk buku ini. Silahkan ajukan pinjaman',
                                            dialogType: DialogType.info,
                                            onOk: () {});
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 11, 142, 223), // Warna biru
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                    ),
                                    child: Text(
                                      'Baca Buku',
                                      style: TextStyle(
                                          color: textColor,
                                          fontFamily: 'InterSemiBold'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _infoColumn(
                                    Icons.star_rounded,
                                    book!.averageRating?.toStringAsFixed(1) ??
                                        '0.0',
                                    'Rating',
                                    iconColor: Colors.amber.shade700,
                                    valueColor: primaryColor),
                                _infoColumn(
                                    Icons.calendar_month_rounded,
                                    book!.year != null &&
                                            book!.year!.toString().isNotEmpty
                                        ? book!.year.toString()
                                        : '-',
                                    'Tahun Terbit',
                                    iconColor: Colors.blue.shade700,
                                    valueColor: primaryColor),
                                _infoColumn(Icons.menu_book_rounded,
                                    book!.pages?.toString() ?? '-', 'Halaman',
                                    iconColor: Colors.green.shade700,
                                    valueColor: primaryColor),
                              ],
                            ),
                            const SizedBox(height: 25),
                            Row(
                              children: [
                                Text(
                                  'Stok Tersedia : ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: textGreyColor,
                                      fontFamily: 'InterSemiBold'),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: (book!.availableStock ?? 0) == 0
                                        ? const Color.fromARGB(
                                            255, 255, 199, 195)
                                        : const Color.fromARGB(
                                            255, 206, 255, 207),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    '${(book!.availableStock ?? 0)} Buku',
                                    style: TextStyle(
                                      color: (book!.availableStock ?? 0) == 0
                                          ? Colors.red.shade800
                                          : Colors.green.shade800,
                                      fontFamily: 'InterMedium',
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Deskripsi',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'InterBold',
                                  color: primaryColor),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isExpanded = !_isExpanded;
                                });
                              },
                              child: AnimatedCrossFade(
                                duration: const Duration(milliseconds: 300),
                                crossFadeState: _isExpanded
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                                firstChild: Text(
                                  book!.description ?? 'Tidak ada deskripsi.',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                secondChild: Text(
                                  book!.description ?? 'Tidak ada deskripsi.',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                              ),
                            ),
                            if ((book!.description?.length ?? 0) > 150)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isExpanded = !_isExpanded;
                                  });
                                },
                                child: Text(
                                  _isExpanded
                                      ? 'Sembunyikan'
                                      : 'Baca Selengkapnya',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontFamily: 'InterSemiBold'),
                                ),
                              ),
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
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: valueColor ?? primaryColor,
            fontFamily: 'InterBold',
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: labelColor ?? textGreyColor,
            fontFamily: 'InterMedium',
          ),
        ),
      ],
    );
  }
}
