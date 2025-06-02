import 'package:e_library/utils/colors.dart';
import 'package:e_library/views/pages/library/detail_book.dart';
import 'package:flutter/material.dart';

class BookCardSlide extends StatelessWidget {
  final String image;
  final String author;
  final String title;

  const BookCardSlide({
    super.key,
    required this.image,
    required this.author,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: SizedBox(
        width: 120, // Menentukan lebar maksimal dari kontainer
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => const DetailsBook()));
              },
              child: Container(
                width: 120,
                height: 170,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x80000000),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    image,
                    width: 150,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'InterBold',
                fontSize: 14,
                color: primaryColor,
              ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 1, // Membatasi maksimal 2 baris
            ),
            Text(
              author,
              style: TextStyle(
                fontFamily: 'InterMedium',
                fontSize: 12,
                color: textGreyColor,
              ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 1, // Membatasi maksimal 2 baris
            ),
          ],
        ),
      ),
    );
  }
}
