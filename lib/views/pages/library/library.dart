import 'package:e_library/components/book_card_slide.dart';
import 'package:e_library/models/list_book.dart';
import 'package:e_library/utils/colors.dart';
import 'package:flutter/material.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  // Misal ini data buku berdasarkan kategori (dummy contoh)
  final Map<String, List<Map<String, dynamic>>> categorizedBooks = {
    'Buku Motivation':
        listBook.where((b) => b['category'] == 'Motivation').toList(),
    'Buku Novel': listBook.where((b) => b['category'] == 'Novel').toList(),
    'Buku Pendidikan':
        listBook.where((b) => b['category'] == 'Pendidikan').toList(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Bagian search tetap sama
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
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: greyBtnColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        SizedBox(width: 15),
                        Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: TextField(
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
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.filter_list,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Sekarang untuk tiap kategori bikin listview horizontal
            ...categorizedBooks.entries.map((entry) {
              final category = entry.key;
              final books = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          color: primaryColor,
                          fontFamily: 'InterBold',
                          fontSize: 18,
                        ),
                      ),
                      TextButton(onPressed: () {}, child: Text('Lihat Semua')),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: SizedBox(
                      height: 230, // tinggi fixed untuk card horizontal
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return BookCardSlide(
                            image: book['image'] as String,
                            title: book['title'] as String,
                            author: book['author'] as String,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
