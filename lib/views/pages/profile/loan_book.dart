import 'package:e_library/components/book_card.dart';
import 'package:e_library/services/api_service.dart'; // Pastikan ini ada
import 'package:e_library/utils/colors.dart';
import 'package:flutter/material.dart';

class LoanBook extends StatefulWidget {
  final String userId;
  const LoanBook({super.key, required this.userId});

  @override
  State<LoanBook> createState() => _LoanBookState();
}

class _LoanBookState extends State<LoanBook> {
  // Hanya satu Future untuk mengambil semua riwayat pinjaman
  late Future<List<dynamic>> _allUserLoansFuture;

  @override
  void initState() {
    super.initState();
    // Menggunakan hanya satu API service untuk semua riwayat pinjaman
    _allUserLoansFuture = ApiService().getUserLoanHistory(widget.userId);
  }

  // Metode untuk me-refresh data (opsional, jika diperlukan)
  // void _refreshData() {
  //   setState(() {
  //     _allUserLoansFuture = ApiService().getUserLoanHistory(widget.userId);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Dua tab: Sedang Dipinjam dan Sudah Dipinjam
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
          title: const Text(
            'Buku Dipinjam',
            style: TextStyle(
                color: Colors.white, fontFamily: 'InterSemiBold', fontSize: 20),
          ),
          backgroundColor: primaryColor,
          centerTitle: true,
          bottom: TabBar(
            isScrollable: false,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            indicatorColor: Colors.white,
            tabs: const [
              Tab(icon: Icon(Icons.menu_book), text: 'Sedang Dipinjam'),
              Tab(
                  icon: Icon(Icons.check_circle_outline),
                  text: 'Sudah Dipinjam'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Konten untuk tab 'Sedang Dipinjam'
            FutureBuilder<List<dynamic>>(
              future: _allUserLoansFuture, // Menggunakan satu future yang sama
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print('Error loading loan history: ${snapshot.error}');
                  return Center(
                    child: Text('Gagal memuat pinjaman: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada buku yang sedang dipinjam.'),
                  );
                } else {
                  // Filter hanya pinjaman yang 'approved' dari seluruh riwayat
                  final currentLoans = snapshot.data!
                      .where((loan) =>
                          loan['status'] ==
                          'approved') // Filter status 'approved'
                      .toList();

                  if (currentLoans.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada buku yang sedang dipinjam.'),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: currentLoans.map((e) {
                      final book = e['book'];
                      if (book == null || book is! Map) {
                        print(
                            'Current loan entry found without valid book data: $e');
                        return const SizedBox.shrink();
                      }
                      return BookCard(
                        bookId: e['bookId']?.toString() ?? '',
                        image: book['coverUrl']?.toString() ?? '',
                        title: book['title']?.toString() ?? '',
                        author: book['author']?.toString() ?? '',
                        year: book['year']?.toString() ?? '',
                        averageRating:
                            book['averageRating']?.toString() ?? '0.0',
                        availableStock: (book['availableStock'] is num)
                            ? book['availableStock'] as num
                            : num.tryParse(book['availableStock']?.toString() ??
                                    '0') ??
                                0,
                      );
                    }).toList(),
                  );
                }
              },
            ),

            // Konten untuk tab 'Sudah Dipinjam'
            FutureBuilder<List<dynamic>>(
              future: _allUserLoansFuture, // Menggunakan satu future yang sama
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print('Error loading loan history: ${snapshot.error}');
                  return Center(
                    child: Text(
                        'Gagal memuat riwayat pinjaman: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada buku yang sudah dipinjam.'),
                  );
                } else {
                  // Filter hanya pinjaman yang 'returned' dari seluruh riwayat
                  final completedLoans = snapshot.data!
                      .where((loan) => loan['status'] == 'returned')
                      .toList();

                  if (completedLoans.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada buku yang sudah dipinjam.'),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: completedLoans.map((e) {
                      final book = e['book'];
                      if (book == null || book is! Map) {
                        print(
                            'Completed loan entry found without valid book data: $e');
                        return const SizedBox.shrink();
                      }
                      return BookCard(
                        bookId: e['bookId']?.toString() ?? '',
                        image: book['coverUrl']?.toString() ?? '',
                        title: book['title']?.toString() ?? '',
                        author: book['author']?.toString() ?? '',
                        year: book['year']?.toString() ?? '',
                        averageRating:
                            book['averageRating']?.toString() ?? '0.0',
                        availableStock: (book['availableStock'] is num)
                            ? book['availableStock'] as num
                            : num.tryParse(book['availableStock']?.toString() ??
                                    '0') ??
                                0,
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
