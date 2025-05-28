import 'package:e_library/models/list_book.dart';
import 'package:e_library/utils/colors.dart';
import 'package:e_library/components/book_list.dart';
import 'package:flutter/material.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  int myIndex = 1;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Jumlah tab
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
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
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
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
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: greyBtnColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 15),
                          Icon(
                            Icons.search,
                            color: greyColor,
                          ),
                          Expanded(
                            child: TextFormField(
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
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.filter_list,
                      size: 40,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TabBar(
                isScrollable: false,
                labelColor: primaryColor,
                unselectedLabelColor: greyColor,
                indicatorColor: primaryColor,
                tabs: [
                  Tab(icon: Icon(Icons.menu_book_outlined), text: 'Semua'),
                  Tab(icon: Icon(Icons.star), text: 'Populer'),
                  Tab(icon: Icon(Icons.bookmark), text: 'Favorit'),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Tab "Semua" dengan SingleChildScrollView
                    SingleChildScrollView(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
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
                    // Konten untuk Tab "Favorit" dengan SingleChildScrollView
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
                          Center(
                            child: Text(
                              'Buku Favorit akan ditampilkan di sini',
                              style: TextStyle(
                                color: primaryColor,
                                fontFamily: 'InterBold',
                                fontSize: 18,
                              ),
                            ),
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
