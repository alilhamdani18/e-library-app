import 'dart:convert';

import 'package:e_library/services/api_service.dart';
import 'package:e_library/utils/dialog.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void showRatingDialog({
  required BuildContext context,
  required String userId,
  required String bookId,
  double initialRating = 0,
  String initialReview = '',
  bool isEdit = false,
  String? ratingId,
  required VoidCallback onSuccess,
}) {
  double rating = initialRating;
  final reviewController = TextEditingController(text: initialReview);

  AwesomeDialog(
    context: context,
    dialogType: DialogType.noHeader,
    animType: AnimType.scale,
    btnOkText: isEdit ? "Update" : "Kirim",
    btnCancelText: "Batal",
    btnCancelOnPress: () {},
    btnOkOnPress: () async {
      final ratingData = {
        'userId': userId,
        'bookId': bookId,
        'rating': rating,
        'review': reviewController.text,
      };
      print('Data yang dikirim ke API: ${jsonEncode(ratingData)}');

      try {
        if (isEdit) {
          await ApiService().updateRating(userId, bookId, ratingData);
        } else {
          await ApiService().addRating(userId, ratingData);
        }

        onSuccess();

        showAwesomeLibraryDialog(
          context,
          title: 'Sukses',
          message: isEdit
              ? 'Rating berhasil diperbarui!'
              : 'Rating berhasil dikirim!',
          dialogType: DialogType.success,
          autoClose: true,
          autoCloseDelay: Duration(seconds: 1)
        );
      } catch (e) {
        debugPrint('Error detail: $e');
        showAwesomeLibraryDialog(
          context,
          title: 'Gagal',
          message: 'Gagal mengirim rating.\n$e',
          dialogType: DialogType.error,
        );
        print('Update rating error: $e');
      }
    },
    body: StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEdit ? 'Edit Rating Buku' : 'Beri Rating Buku',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                maxRating: 5,
                itemCount: 5,
                allowHalfRating: false,
                glow: false,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) {
                  setState(() {
                    rating = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reviewController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Tulis ulasan (opsional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    ),
  ).show();
}
