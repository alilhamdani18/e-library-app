import 'package:e_library/models/library/loan_book_sheet.dart';
import 'package:e_library/utils/colors.dart';
import 'package:flutter/material.dart';

class BookList extends StatefulWidget {
  final String image;
  final String title;
  final String author;
  final String year;
  final String rating;

  const BookList({
    super.key,
    required this.image,
    required this.title,
    required this.author,
    required this.year,
    required this.rating,
  });

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  bool isBookmarked = false;
  bool isRated = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: secondaryColor,
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(128, 10, 174, 114),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 3))
                  ],
                ),

                // height: 200,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(widget.image,
                              width: 100, fit: BoxFit.cover),
                        )
                      ],
                    ),
                    SizedBox(width: 20),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              color: primaryColor,
                              fontFamily: 'InterBold',
                              fontSize: 18,
                            ),
                            softWrap: true,
                          ),
                          Text(
                            widget.author,
                            style: TextStyle(
                              color: textGreyColor,
                              fontFamily: 'InterMedium',
                              fontSize: 14,
                            ),
                            softWrap: true,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(widget.year,
                                style: TextStyle(
                                  color: textGreyColor,
                                  fontFamily: 'InterMedium',
                                  fontSize: 14,
                                )),
                          ),
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      isRated = !isRated;
                                    });
                                  },
                                  child: Icon(
                                    isRated ? Icons.star : Icons.star_border,
                                    color: Colors.amber,
                                    size: 30,
                                  )),
                              SizedBox(
                                width: 8,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(widget.rating,
                                    style: TextStyle(
                                      color: textGreyColor,
                                      fontFamily: 'InterMedium',
                                      fontSize: 14,
                                    )),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isDismissible: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) =>
                                              BottomSheetLoanBook(),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15))),
                                      child: Text(
                                        'Pinjam Buku',
                                        style: TextStyle(color: textColor),
                                      ))
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isBookmarked = !isBookmarked;
                                      });
                                    },
                                    icon: Icon(
                                      isBookmarked
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                    ),
                                    color: primaryColor,
                                    iconSize: 30,
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
