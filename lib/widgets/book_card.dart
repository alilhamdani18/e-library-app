import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String judul;
  final String penulis;
  final String gambar; // path asset atau URL
  final bool fromNetwork;

  const BookCard({
    super.key,
    required this.judul,
    required this.penulis,
    required this.gambar,
    this.fromNetwork = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: fromNetwork
                ? Image.network(
                    gambar,
                    width: 60,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 60),
                  )
                : Image.asset(
                    gambar,
                    width: 60,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Judul Buku: $judul',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Penulis: $penulis'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
