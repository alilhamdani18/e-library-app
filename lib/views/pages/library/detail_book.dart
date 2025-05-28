import 'package:e_library/models/library/loan_book_sheet.dart';
import 'package:e_library/utils/colors.dart';
import 'package:flutter/material.dart';

class DetailsBook extends StatefulWidget {
  const DetailsBook({super.key});

  @override
  State<DetailsBook> createState() => _DetailsBookState();
}

class _DetailsBookState extends State<DetailsBook> {
  bool isBookmarked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Detail Buku',
          style: TextStyle(
              color: Colors.white, fontFamily: 'InterBold', fontSize: 20),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    isBookmarked = !isBookmarked;
                  });
                },
                icon:
                    Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                color: textColor,
                iconSize: 30,
              ))
        ],
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              color: primaryColor,
              width: double.infinity,
              // height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: greyBtnColor,
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(128, 166, 247, 217),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 3))
                      ],
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset('assets/images/ancika.jpg')),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Ancika 1995',
                    style: TextStyle(
                        color: Colors.yellow,
                        fontFamily: 'InterBold',
                        fontSize: 24),
                  ),
                  Text(
                    'Pidi Baiq',
                    style: TextStyle(
                        color: textColor,
                        fontFamily: 'InterSemiBold',
                        fontSize: 14),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isDismissible: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => BottomSheetLoanBook(),
                              );
                            },
                            child: Text(
                              'Pinjam Buku',
                              style: TextStyle(color: primaryColor),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // color: greyBtnColor,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 30,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '4.9',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text('120 Ratings',
                                style: TextStyle(color: textGreyColor)),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.date_range_sharp,
                              color: primaryColor,
                              size: 30,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text('2021', style: TextStyle(fontSize: 16)),
                            Text(
                              'Tahun Terbit',
                              style: TextStyle(color: textGreyColor),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.description_rounded,
                              color: primaryColor,
                              size: 30,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text('150', style: TextStyle(fontSize: 16)),
                            Text('Halaman',
                                style: TextStyle(color: textGreyColor)),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sinopsis',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'InterBold',
                                    color: primaryColor),
                              ),
                              SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: greyBtnColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                child: Text(
                                  'Ini adalah contoh sinopsis kalimat random \nSegala sesuatu yang kita lihat di sekitar kita merupakan alam, termasuk matahari, bulan, pohon, bunga, buah, manusia, burung, hewan, dll. Di l lainnya. Banyak corak yang dapat terlihat di alam, yang berkontribusi pada keindahan planet ini. Bersama dengan manusia, hewan dan burung juga menemukan habitat dan cara bertahan hidup mereka di alam. Oleh karena itu, sangat penting untuk menjaga alam kita dengan baik untuk mempertahankan kehidupan yang sehat.',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 77, 77, 77)),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
