import 'package:e_library/views/pages/library/loan_book_sheet.dart';
import 'package:e_library/utils/colors.dart';
import 'package:flutter/material.dart';

class BookCard extends StatefulWidget {
  final String image;
  final String title;
  final String author;
  final String year;
  final String rating;

  const BookCard({
    super.key,
    required this.image,
    required this.title,
    required this.author,
    required this.year,
    required this.rating,
  });

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(128, 10, 174, 114),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.image,
                width: 110,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.broken_image),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: TextStyle(
                        color: primaryColor,
                        fontFamily: 'InterBold',
                        fontSize: 18,
                      )),
                  Text(widget.author,
                      style: TextStyle(
                        color: textGreyColor,
                        fontFamily: 'InterMedium',
                        fontSize: 14,
                      )),
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
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 6),
                      Text(widget.rating,
                          style: TextStyle(
                            color: textGreyColor,
                            fontFamily: 'InterMedium',
                            fontSize: 14,
                          )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text('Pinjam Buku',
                            style: TextStyle(color: textColor)),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isBookmarked = !isBookmarked;
                          });
                        },
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: primaryColor,
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
