import 'package:e_library/models/list_book.dart';
import 'package:e_library/utils/colors.dart';
import 'package:e_library/components/book_list.dart';
import 'package:flutter/material.dart';

class LoanBook extends StatefulWidget {
  const LoanBook({super.key});

  @override
  State<LoanBook> createState() => _LoanBookState();
}

class _LoanBookState extends State<LoanBook> {
  int myIndex = 1;
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
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TabBar(
                isScrollable: false,
                labelColor: primaryColor,
                unselectedLabelColor: greyColor,
                indicatorColor: primaryColor,
                tabs: [
                  // Tab(icon: Icon(Icons.menu_book_outlined), text: 'Semua'),
                  Tab(
                      icon: Icon(Icons.replay_rounded),
                      text: 'Sedang Dipinjam'),
                  Tab(icon: Icon(Icons.check_box), text: 'Sudah Dipinjam'),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Konten untuk Tab "Sedang Dipinjam" dengan SingleChildScrollView
                    SingleChildScrollView(
                      child: Column(
                        children: listBook
                            .map((e) => BookList(
                                  image: e['image'] as String,
                                  title: e['title'] as String,
                                  author: e['author'] as String,
                                  year: e['year'] as String,
                                  rating: e['rating'] as String,
                                ))
                            .toList(),
                      ),
                    ),
                    // Konten untuk Tab "Populer" dengan SingleChildScrollView
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            children: listBook
                                .map((e) => BookList(
                                      image: e['image'] as String,
                                      title: e['title'] as String,
                                      author: e['author'] as String,
                                      year: e['year'] as String,
                                      rating: e['rating'] as String,
                                    ))
                                .toList(),
                          ),
                        ],
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
