import 'package:e_library/utils/colors.dart';
import 'package:e_library/views/pages/library/detail_book.dart';
import 'package:flutter/material.dart';

class BottomSheetLoanBook extends StatefulWidget {
  const BottomSheetLoanBook({super.key});

  @override
  State<BottomSheetLoanBook> createState() => _BottomSheetLoanBookState();
}

class _BottomSheetLoanBookState extends State<BottomSheetLoanBook> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min, // ⬅️ menyesuaikan tinggi child
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Konfirmasi Peminjaman',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'InterBold',
                  color: primaryColor,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Center(
              child: Text(
            'Silahkan Konfirmasi Peminjaman Buku Anda',
            style: TextStyle(color: textGreyColor),
          )),
          const SizedBox(height: 20),

          // === Detail Buku ===
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/ancika.jpg',
                    width: 100,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ancika 1995',
                          style:
                              TextStyle(fontSize: 20, fontFamily: 'InterBold'),
                        ),
                        Text(
                          'Pidi Baiq',
                          style: TextStyle(
                              fontSize: 14, fontFamily: 'IntersemiBold'),
                        ),
                        Text(
                          '2021',
                          style: TextStyle(
                              fontSize: 14, fontFamily: 'IntersemiBold'),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text('4.4')
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const DetailsBook()));
                            },
                            child: Text('Lihat Detail'))
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Tombol Pinjam
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Pinjam Buku Ini',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
