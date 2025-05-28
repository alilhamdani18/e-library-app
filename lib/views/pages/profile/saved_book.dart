import 'package:e_library/models/list_book.dart';
import 'package:e_library/utils/colors.dart';
import 'package:e_library/components/book_list.dart';
import 'package:flutter/material.dart';

class SavedBook extends StatelessWidget {
  const SavedBook({super.key});

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
          'Buku Tersimpan',
          style: TextStyle(
              color: Colors.white, fontFamily: 'InterSemiBold', fontSize: 20),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
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
          ],
        ),
      ),
    );
  }
}
