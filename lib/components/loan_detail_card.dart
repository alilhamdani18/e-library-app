import 'package:flutter/material.dart';
import 'package:e_library/utils/colors.dart'; // Sesuaikan path jika berbeda
import 'package:intl/intl.dart'; // Import untuk formatting tanggal

class LoanDetailCard extends StatelessWidget {
  final String bookTitle;
  final String bookCoverUrl;
  final String loanStatus;
  final DateTime approvedAt;
  final int durationDays;
  final DateTime? returnedAt; // Bisa null jika belum dikembalikan

  const LoanDetailCard({
    super.key,
    required this.bookTitle,
    required this.bookCoverUrl,
    required this.loanStatus,
    required this.approvedAt,
    required this.durationDays,
    this.returnedAt,
  });

  // Helper untuk format tanggal
  String _formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }

  // Helper untuk mendapatkan warna status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green[700]!;
      case 'returned':
        return Colors.blue[700]!;
      case 'pending':
        return Colors.orange[700]!;
      case 'rejected':
        return Colors.red[700]!;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menghitung tanggal jatuh tempo
    final DateTime dueDate = approvedAt.add(Duration(days: durationDays));

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar sampul buku
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                bookCoverUrl,
                width: 90,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 90,
                    height: 120,
                    color: Colors.grey[200],
                    child: Icon(Icons.book, color: Colors.grey[400]),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul buku
                  Text(
                    bookTitle,
                    style: TextStyle(
                      fontFamily: 'InterSemiBold',
                      fontSize: 18,
                      color: primaryColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Status Pinjaman
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: _getStatusColor(loanStatus)),
                      const SizedBox(width: 4),
                      Text(
                        'Status: ${loanStatus == 'approved' ? 'Disetujui' : loanStatus == 'returned' ? 'Dikembalikan' : loanStatus == 'pending' ? 'Menunggu' : 'Ditolak'}',
                        style: TextStyle(
                          fontFamily: 'InterMedium',
                          fontSize: 14,
                          color: _getStatusColor(loanStatus),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Tanggal Disetujui
                  Row(
                    children: [
                      Icon(Icons.date_range, size: 16, color: textGreyColor),
                      const SizedBox(width: 4),
                      Text(
                        'Disetujui: ${_formatDate(approvedAt)}',
                        style: TextStyle(fontFamily: 'InterRegular', fontSize: 13, color: textGreyColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Durasi Pinjaman
                  Row(
                    children: [
                      Icon(Icons.timelapse, size: 16, color: textGreyColor),
                      const SizedBox(width: 4),
                      Text(
                        'Durasi: $durationDays hari',
                        style: TextStyle(fontFamily: 'InterRegular', fontSize: 13, color: textGreyColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Tanggal Jatuh Tempo
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.red[400]),
                      const SizedBox(width: 4),
                      Text(
                        'Jatuh Tempo: ${_formatDate(dueDate)}',
                        style: TextStyle(fontFamily: 'InterRegular', fontSize: 13, color: Colors.red[400]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Tanggal Dikembalikan (hanya tampil jika sudah dikembalikan)
                  if (returnedAt != null)
                    Row(
                      children: [
                        Icon(Icons.assignment_turned_in, size: 16, color: Colors.blue[400]),
                        const SizedBox(width: 4),
                        Text(
                          'Dikembalikan: ${_formatDate(returnedAt!)}',
                          style: TextStyle(fontFamily: 'InterRegular', fontSize: 13, color: Colors.blue[400]),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}