// import 'package:e_library/models/list_book.dart';
import 'package:e_library/utils/colors.dart';
import 'package:e_library/components/book_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_library/services/api_service.dart';

class LoanBook extends StatefulWidget {
  const LoanBook({super.key});

  @override
  State<LoanBook> createState() => _LoanBookState();
}

class _LoanBookState extends State<LoanBook> {
  int myIndex = 1;
  List<dynamic> currentLoans = [];
  List<dynamic> completedLoans = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLoanHistory();
  }

  Future<void> fetchLoanHistory() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      final history = await ApiService().getUserLoanHistory(userId);

      setState(() {
        currentLoans =
            history.where((loan) => loan['status'] == 'approved').toList();

        completedLoans =
            history.where((loan) => loan['status'] == 'returned').toList();

        isLoading = false;
      });
      print(currentLoans);
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Jumlah tab
      child: Scaffold(
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
            'Buku Dipinjam',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'InterBold',
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          backgroundColor: primaryColor,
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TabBar(
                      isScrollable: false,
                      labelColor: primaryColor,
                      unselectedLabelColor: greyColor,
                      indicatorColor: primaryColor,
                      tabs: const [
                        Tab(
                            icon: Icon(Icons.replay_rounded),
                            text: 'Sedang Dipinjam'),
                        Tab(
                            icon: Icon(Icons.check_box),
                            text: 'Sudah Dipinjam'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Sedang Dipinjam
                          SingleChildScrollView(
                            child: Column(
                              children: currentLoans
                                  .map((e) => BookCard(
                                        bookId: e['bookId'] ?? '',
                                        image: e['book']?['coverUrl'] ?? '',
                                        title: e['book']?['title'] ?? '',
                                        author: e['book']?['author'] ?? '',
                                        year: e['book']?['year']?.toString() ??
                                            '',
                                        averageRating: e['book']
                                                    ?['averageRating']
                                                ?.toString() ??
                                            '0.0',
                                        description:
                                            e['book']?['description'] ?? '',
                                      ))
                                  .toList(),
                            ),
                          ),
                          // Sudah Dipinjam
                          SingleChildScrollView(
                            child: Column(
                              children: completedLoans
                                  .map((e) => BookCard(
                                        bookId: e['bookId'] ?? '',
                                        image: e['book']?['coverUrl'] ?? '',
                                        title: e['book']?['title'] ?? '',
                                        author: e['book']?['author'] ?? '',
                                        year: e['book']?['year']?.toString() ??
                                            '',
                                        averageRating: e['book']
                                                    ?['averageRating']
                                                ?.toString() ??
                                            '0.0',
                                        description:
                                            e['book']?['description'] ?? '',
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
