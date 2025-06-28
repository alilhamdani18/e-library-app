// import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_library/models/book.dart';
import 'package:e_library/services/api_service.dart';
import 'package:e_library/utils/colors.dart';
import 'package:e_library/utils/dialog.dart';
// import 'package:e_library/views/pages/library/detail_book.dart';
// import 'package:e_library/views/pages/library/detail_book.dart';
import 'package:flutter/material.dart';

class BottomSheetLoanBook extends StatefulWidget {
  final String bookId;
  final String userId;
  final Book? book;
  const BottomSheetLoanBook(
      {super.key,
      required this.bookId,
      required this.book,
      required this.userId});

  @override
  State<BottomSheetLoanBook> createState() => _BottomSheetLoanBookState();
}

class _BottomSheetLoanBookState extends State<BottomSheetLoanBook> {
  final apiService = ApiService();
  bool isLoading = false;
  int? selectedDays;

  Future<void> _submitLoanRequest() async {
    if (selectedDays == null) {
      showAwesomeLibraryDialog(
        context,
        title: 'Perhatian',
        message: 'Masukkan durasi peminjaman buku',
        dialogType: DialogType.info,
        autoClose: false,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final loanData = {
      'bookId': widget.bookId,
      'userId': widget.userId,
      'loanDuration': selectedDays,
      'status': 'pending',
      'requestedAt': DateTime.now().toIso8601String(),
    };
    print('Selected days: $selectedDays');
    print('Loan data: $loanData');

    try {
      await apiService.requestLoan(loanData);

      showAwesomeLibraryDialog(context,
          title: 'Berhasil',
          message: 'Permintaan peminjaman berhasil diajukan.',
          dialogType: DialogType.success,
          autoClose: false, onOk: () {
        Navigator.pop(context);
      });
    } catch (e) {
      final errorStr = e.toString();
      String errorMessage = 'Gagal meminjam buku.';

      if (errorStr.contains('active loan request')) {
        errorMessage =
            'Kamu sudah memiliki permintaan peminjaman aktif untuk buku ini.';
      }

      showAwesomeLibraryDialog(
        context,
        title: 'Gagal',
        message: errorMessage,
        dialogType: DialogType.error,
        autoClose: true,
        autoCloseDelay: const Duration(seconds: 2),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.book?.coverUrl ?? '',
                    width: 120,
                    height: 170,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.book?.title ?? '',
                        style: TextStyle(fontSize: 20, fontFamily: 'InterBold'),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        widget.book?.author ?? '',
                        style: TextStyle(
                            fontSize: 14, fontFamily: 'InterSemiBold'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.book?.year.toString() ?? '',
                        style: TextStyle(
                            fontSize: 14, fontFamily: 'InterSemiBold'),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 8),
                          Text(
                            (widget.book?.averageRating ?? 0.0)
                                .toStringAsFixed(1),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.book?.description ?? '',
                        style: TextStyle(
                          color: textGreyColor,
                          fontFamily: 'InterMedium',
                          fontSize: 14,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      // Row(
                      //   children: [
                      //     ElevatedButton(
                      //       onPressed: () {
                      //         Navigator.pop(context);
                      //       },
                      //       child: const Text('Lihat Detail'),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(children: [
            Text(
              'Pilih Durasi Peminjaman',
              style: TextStyle(fontSize: 16, fontFamily: 'InterSemiBold'),
            ),
          ]),
          SizedBox(height: 10),

          Row(
            children: [
              Wrap(
                spacing: 8,
                children: [7, 14, 21].map((day) {
                  return ChoiceChip(
                    label: Text('$day hari'),
                    selected: selectedDays == day,
                    onSelected: (selected) {
                      setState(() {
                        selectedDays = selected ? day : null;
                        debugPrint('Selected days: $selectedDays');
                      });
                    },
                  );
                }).toList(),
              ),
            ],
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
              onPressed: isLoading ? null : _submitLoanRequest,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Pinjam Buku Ini',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
