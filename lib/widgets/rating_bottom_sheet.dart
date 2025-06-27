import 'package:e_library/services/api_service.dart';
import 'package:e_library/utils/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void showRatingDialog({
  required BuildContext context,
  required String userId,
  required String bookId,
  required void Function()? onSuccess,
}) {
  double rating = 0;
  final TextEditingController reviewController = TextEditingController();

  AwesomeDialog(
    context: context,
    dialogType: DialogType.noHeader,
    animType: AnimType.scale,
    btnOkText: "Kirim",
    btnCancelText: "Batal",
    btnCancelOnPress: () {},
    btnOkOnPress: () async {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;
      final ratingData = {
        'userId': userId,
        'bookId': bookId,
        'rating': rating,
        'review': reviewController.text,
      };

      try {
        await ApiService().addRating(userId!, ratingData);
        onSuccess?.call();
        showAwesomeLibraryDialog(
          context,
          title: 'Sukses',
          message: 'Rating berhasil dikirim!',
          dialogType: DialogType.success,
          autoClose: true,
        );
      } catch (e) {
        debugPrint('Error detail: $e');
        showAwesomeLibraryDialog(
          context,
          title: 'Gagal',
          message: 'Gagal mengirim rating.\n$e',
          dialogType: DialogType.error,
        );
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
                'Beri Rating Buku',
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
