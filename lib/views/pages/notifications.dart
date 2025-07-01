// lib/screens/notifications_page.dart

import 'package:e_library/models/notification.dart'; // Pastikan ini mengarah ke model baru
import 'package:e_library/services/api_service.dart';
import 'package:e_library/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  int myIndex = 2;
  final ApiService _apiService = ApiService();
  User? _currentUser;
  List<AppNotification> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser == null) {
      _errorMessage = "Anda harus login untuk melihat notifikasi.";
      _isLoading = false;
    } else {
      _fetchNotifications();
    }
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      if (_currentUser != null) {
        // Panggil getUserNotifications dari ApiService yang sudah diperbarui
        final fetchedNotifications =
            await _apiService.getUserNotifications(_currentUser!.uid);
        setState(() {
          _notifications = fetchedNotifications;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Gagal memuat notifikasi: ${e.toString()}";
        _isLoading = false;
      });
      print('Error fetching notifications: $e');
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    try {
      await _apiService.markNotificationAsRead(notificationId);
      setState(() {
        _notifications = _notifications.map((notification) {
          return notification.id == notificationId
              ? notification.copyWith(isRead: true)
              : notification;
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Gagal menandai notifikasi sebagai terbaca: $e")),
      );
      print('Error marking as read: $e');
    }
  }

  Future<bool> _deleteNotification(String notificationId, int index) async {
    final AppNotification originalNotification = _notifications[index];

    final bool confirmDelete = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Hapus Notifikasi?"),
              content: Text(
                  "Apakah Anda yakin ingin menghapus notifikasi ini secara permanen?"),
              actions: <Widget>[
                TextButton(
                  child: Text("Batal", style: TextStyle(color: textGreyColor)),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Hapus", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;

    if (!confirmDelete) {
      return false; // Pengguna membatalkan
    }

    // Hapus dari UI (optimistic update)
    setState(() {
      _notifications.removeAt(index);
    });

    try {
      // Panggil API untuk menghapus notifikasi dari koleksi NOTIFICATIONS
      await _apiService.deleteNotification(notificationId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Notifikasi berhasil dihapus."),
          backgroundColor: Colors.green,
        ),
      );
      return true; // Berhasil dihapus dari backend
    } catch (e) {
      // Jika gagal di backend, kembalikan notifikasi ke UI
      setState(() {
        _notifications.insert(index, originalNotification);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menghapus notifikasi: $e"),
          backgroundColor: Colors.red,
        ),
      );
      print('Error deleting notification from server: $e');
      return false; // Gagal menghapus dari backend
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return "Baru saja";
        }
        return "${difference.inMinutes} menit yang lalu";
      }
      return "${difference.inHours} jam yang lalu";
    } else if (difference.inDays == 1) {
      return "Kemarin pukul ${DateFormat('HH:mm').format(timestamp)}";
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE, HH:mm').format(timestamp);
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(timestamp);
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'loan_approved':
        return Icons.check_circle_outline;
      case 'loan_rejected':
        return Icons.cancel_outlined;
      case 'book_returned':
        return Icons.menu_book_rounded;
      default:
        return Icons.notifications_none;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'loan_approved':
        return Colors.green.shade700;
      case 'loan_rejected':
        return Colors.red.shade700;
      case 'book_returned':
        return Colors.blue.shade700;
      default:
        return primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Notifikasi',
          style: TextStyle(
              color: Colors.white, fontFamily: 'InterBold', fontSize: 20),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ))
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 48),
                        SizedBox(height: 8),
                        Text(_errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red, fontSize: 16)),
                        SizedBox(height: 16),
                        if (_currentUser == null)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('/login');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Login Sekarang',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'InterSemiBold')),
                          )
                        else
                          ElevatedButton(
                            onPressed: _fetchNotifications,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Coba Lagi',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'InterSemiBold')),
                          ),
                      ],
                    ),
                  ),
                )
              : _notifications.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications_off_outlined,
                                color: textGreyColor.withOpacity(0.6),
                                size: 60),
                            SizedBox(height: 16),
                            Text(
                              'Tidak ada notifikasi saat ini.',
                              style: TextStyle(
                                color: textGreyColor,
                                fontSize: 18,
                                fontFamily: 'InterSemiBold',
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Kami akan memberitahumu jika ada pembaruan status pinjaman.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: textGreyColor.withOpacity(0.8),
                                fontSize: 14,
                                fontFamily: 'InterRegular',
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchNotifications,
                      color: primaryColor,
                      child: ListView.builder(
                        itemCount: _notifications.length,
                        itemBuilder: (context, index) {
                          final notification = _notifications[index];
                          final notificationColor =
                              _getNotificationColor(notification.type);
                          final notificationIcon =
                              _getNotificationIcon(notification.type);

                          return Dismissible(
                            key: Key(notification.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              color: Colors.red,
                              child: const Icon(Icons.delete,
                                  color: Colors.white, size: 30),
                            ),
                            confirmDismiss: (direction) async {
                              // Panggil fungsi deleteNotification yang sudah diperbarui
                              return await _deleteNotification(
                                  notification.id, index);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: notification.isRead
                                    ? Colors.white
                                    : notificationColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                border: notification.isRead
                                    ? null
                                    : Border.all(
                                        color:
                                            notificationColor.withOpacity(0.5),
                                        width: 1),
                              ),
                              child: InkWell(
                                onTap: () {
                                  if (!notification.isRead) {
                                    _markAsRead(notification.id);
                                  }
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: notificationColor
                                              .withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(notificationIcon,
                                            color: notificationColor, size: 28),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              notification.librarianName,
                                              style: TextStyle(
                                                fontFamily: 'InterBold',
                                                fontSize: 16,
                                                color: primaryColor,
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              notification.message,
                                              style: TextStyle(
                                                fontFamily: 'InterRegular',
                                                fontSize: 14,
                                                color: textGreyColor,
                                                fontWeight: notification.isRead
                                                    ? FontWeight.normal
                                                    : FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Text(
                                                _formatTimestamp(
                                                    notification.timestamp),
                                                style: TextStyle(
                                                  fontFamily: 'InterLight',
                                                  fontSize: 12,
                                                  color: textGreyColor
                                                      .withOpacity(0.7),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (!notification.isRead)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, top: 4),
                                          child: Icon(Icons.circle,
                                              size: 10,
                                              color: notificationColor),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
