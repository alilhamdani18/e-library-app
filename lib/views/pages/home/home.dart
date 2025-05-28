import 'package:e_library/models/list_book.dart';
import 'package:e_library/utils/colors.dart';
import 'package:e_library/views/pages/library/library.dart';
import 'package:e_library/views/pages/profile/profile.dart';
import 'package:e_library/components/book_list.dart';
import 'package:e_library/components/recommended_book_home.dart';
import 'package:flutter/material.dart';
import 'package:e_library/models/category_book.dart';
import 'package:e_library/models/recommended_book.dart';
import 'package:e_library/components/book_category.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              // height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              width: 50,
                            ),
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
                                    builder: (BuildContext context) =>
                                        const Profile()));
                              },
                              child: CircleAvatar(
                                  backgroundColor: primaryColor,
                                  child: Text(
                                    'A',
                                    style: TextStyle(color: textColor),
                                  )),
                            )
                          ],
                        ),
                        // Container(
                        //   margin: EdgeInsets.symmetric(vertical: 10),
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(5),
                        //     color: primaryColor,
                        //   ),
                        //   height: 5,
                        // ),
                        SizedBox(
                          height: 30,
                        ),
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
                        SizedBox(
                          height: 20,
                        ),
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
                                Icons.search,
                                size: 40,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        Container(
                          // height: 100,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [primaryColor, primaryGradientColor],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(0),
                                        child: Text(
                                          'Beragam Koleksi Buku Ada Dalam Genggamanmu',
                                          style: TextStyle(
                                              color: Colors.amber,
                                              fontFamily: 'InterBold',
                                              fontSize: 20),
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 8,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        const Library()));
                                          },
                                          child: Text(
                                            'Jelajah Pustaka',
                                            style:
                                                TextStyle(color: primaryColor),
                                          ))
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/book.png',
                                      height: 120,
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    'Kategori',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontFamily: 'InterBold',
                                        fontSize: 18),
                                  ),
                                )
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
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(0),
                          child: Row(
                            children: [
                              Text(
                                'Recommended',
                                style: TextStyle(
                                    color: primaryColor,
                                    fontFamily: 'InterBold',
                                    fontSize: 18),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            padding: EdgeInsets.all(0),
                            child: Row(
                              children: [
                                SingleChildScrollView(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: recommendedBook
                                        .map((e) => RecommendedBook(
                                              image: e['image'] as String,
                                              author: e['author'] as String,
                                              label: e['label'] as String,
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Buku Lainnya',
                                style: TextStyle(
                                    color: primaryColor,
                                    fontFamily: 'InterBold',
                                    fontSize: 20),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const Library()));
                                },
                                child: Text(
                                  'Lihat Semua',
                                  style: TextStyle(
                                      fontSize: 16, color: primaryColor),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
