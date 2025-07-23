import 'package:e_library/components/loan_detail_card.dart';
import 'package:e_library/services/api_service.dart';
import 'package:e_library/utils/colors.dart';
import 'package:flutter/material.dart';

class LoanBook extends StatefulWidget {
  final String userId;
  const LoanBook({super.key, required this.userId});

  @override
  State<LoanBook> createState() => _LoanBookState();
}

class _LoanBookState extends State<LoanBook> {
  late Future<List<dynamic>> _allUserLoansFuture;

  @override
  void initState() {
    super.initState();
    _allUserLoansFuture = ApiService().getUserLoanHistory(widget.userId);
  }

  DateTime? _parseTimestampToDateTime(dynamic timestamp) {
    if (timestamp is Map && timestamp.containsKey('_seconds')) {
      final int seconds = timestamp['_seconds'];
      final int nanoseconds =
          timestamp['_nanoseconds'] ?? 0; // Default 0 jika null
      return DateTime.fromMillisecondsSinceEpoch(
          seconds * 1000 + (nanoseconds / 1000000).round());
    }
  
    return null; 
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
            FutureBuilder<List<dynamic>>(
              future: _allUserLoansFuture,
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
                  final currentLoans = snapshot.data!
                      .where((loan) =>
                          loan['status'] == 'approved' &&
                          loan['returnDate'] ==
                              null) 
                      .toList();

                  if (currentLoans.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada buku yang sedang dipinjam.'),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: currentLoans.map((loan) {
                      final book = loan['book'];
                      if (book == null || book is! Map) {
                        print(
                            'Current loan entry found without valid book data: $loan');
                        return const SizedBox.shrink();
                      }

                     
                      DateTime? approvedAt = _parseTimestampToDateTime(loan[
                          'approvedDate']); 
                      if (approvedAt == null) {
                        print('Failed to parse approvedDate for loan: $loan');
                        return const SizedBox
                            .shrink(); 
                      }

                      DateTime? returnedAt = _parseTimestampToDateTime(loan[
                          'returnDate']); 

                      int durationDays = (loan['loanDuration'] is num)
                          ? (loan['loanDuration'] as num).toInt()
                          : 0;

                      return LoanDetailCard(
                        bookTitle: book['title']?.toString() ??
                            'Judul Tidak Diketahui',
                        bookCoverUrl: book['coverUrl']?.toString() ?? '',
                        loanStatus: loan['status']?.toString() ?? 'unknown',
                        approvedAt: approvedAt,
                        durationDays: durationDays,
                        returnedAt: returnedAt,
                      );
                    }).toList(),
                  );
                }
              },
            ),

            FutureBuilder<List<dynamic>>(
              future: _allUserLoansFuture,
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
                    children: completedLoans.map((loan) {
                      final book = loan['book'];
                      if (book == null || book is! Map) {
                        print(
                            'Completed loan entry found without valid book data: $loan');
                        return const SizedBox.shrink();
                      }

                      DateTime? approvedAt =
                          _parseTimestampToDateTime(loan['approvedDate']);
                      if (approvedAt == null) {
                        print('Failed to parse approvedDate for loan: $loan');
                        return const SizedBox.shrink();
                      }

                      DateTime? returnedAt =
                          _parseTimestampToDateTime(loan['returnDate']);

                      int durationDays = (loan['loanDuration'] is num)
                          ? (loan['loanDuration'] as num).toInt()
                          : 0;

                      return LoanDetailCard(
                        bookTitle: book['title']?.toString() ??
                            'Judul Tidak Diketahui',
                        bookCoverUrl: book['coverUrl']?.toString() ?? '',
                        loanStatus: loan['status']?.toString() ?? 'unknown',
                        approvedAt: approvedAt,
                        durationDays: durationDays,
                        returnedAt: returnedAt,
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
