import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:e_library/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class PdfBookViewerPage extends StatefulWidget {
  final String bookId;

  const PdfBookViewerPage({super.key, required this.bookId});

  @override
  State<PdfBookViewerPage> createState() => _PdfBookViewerPageState();
}

class _PdfBookViewerPageState extends State<PdfBookViewerPage> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  // Menggunakan Map untuk menyimpan URL dan Title
  late Future<Map<String, String>?> _bookDataFuture;

  @override
  void initState() {
    super.initState();
    _bookDataFuture = _fetchBookData(
        widget.bookId); // Panggil fungsi untuk mengambil data buku
  }

  // Fungsi untuk mengambil URL PDF dan Judul Buku dari Firestore
  Future<Map<String, String>?> _fetchBookData(String bookId) async {
    try {
      DocumentSnapshot bookDoc = await FirebaseFirestore.instance
          .collection('books')
          .doc(bookId)
          .get();

      if (bookDoc.exists) {
        Map<String, dynamic>? data = bookDoc.data() as Map<String, dynamic>?;

        String? bookFileUrl;
        String? title;

        if (data != null) {
          bookFileUrl = data['bookFileUrl'] as String?;
          title = data['title'] as String?; // Ambil field 'title'
        }

        if (bookFileUrl != null && bookFileUrl.isNotEmpty) {
          return {
            'bookFileUrl': bookFileUrl,
            'title': title ??
                'Judul Tidak Tersedia', // Berikan default jika title null
          };
        } else {
          debugPrint(
              'Error: bookFileUrl not found or is null/empty for bookId: $bookId');
          return null;
        }
      } else {
        debugPrint('Error: Book document not found for bookId: $bookId');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching book data from Firestore: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: FutureBuilder<Map<String, String>?>(
          future: _bookDataFuture, // Menggunakan FutureBuilder untuk judul juga
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                  'Memuat Judul...'); // Teks sementara saat loading
            } else if (snapshot.hasData && snapshot.data != null) {
              return Text(snapshot.data!['title'] ?? 'Judul Tidak Tersedia');
            } else {
              return const Text('Pembaca PDF'); // Judul default jika gagal
            }
          },
        ),
      ),
      body: FutureBuilder<Map<String, String>?>(
        future: _bookDataFuture, // Menggunakan FutureBuilder yang sama
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError ||
              snapshot.data == null ||
              snapshot.data!['bookFileUrl'] == null ||
              snapshot.data!['bookFileUrl']!.isEmpty) {
            String errorMessage = 'Gagal memuat PDF. ';
            if (snapshot.hasError) {
              errorMessage += 'Error: ${snapshot.error}';
            } else if (snapshot.data == null ||
                snapshot.data!['bookFileUrl'] == null ||
                snapshot.data!['bookFileUrl']!.isEmpty) {
              errorMessage += 'URL PDF tidak ditemukan atau kosong.';
            }
            debugPrint(errorMessage);
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 50),
                    const SizedBox(height: 10),
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          } else {
            final String pdfUrl = snapshot.data!['bookFileUrl']!;
            return SfPdfViewer.network(
              pdfUrl,
              controller: _pdfViewerController,
              onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                debugPrint(
                    'Failed to load PDF (SfPdfViewer): ${details.description}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal memuat PDF: ${details.description}'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }
}
