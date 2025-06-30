import 'package:e_library/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  String _appName = 'E-Library App';
  String _version = '1.0.0'; // Default value
  String _buildNumber = '1'; // Default value

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  // Fungsi untuk mendapatkan informasi aplikasi (nama, versi, build number)
  Future<void> _initPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        _appName = info.appName;
        _version = info.version;
        _buildNumber = info.buildNumber;
      });
    } catch (e) {
      // Handle error jika package info tidak bisa diambil
      print('Error getting package info: $e');
      setState(() {
        _appName = 'E-Library App';
        _version = 'N/A';
        _buildNumber = 'N/A';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Tentang Aplikasi', // Ubah teks menjadi Bahasa Indonesia
          style: TextStyle(
              color: Colors.white, fontFamily: 'InterSemiBold', fontSize: 20),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/logo.png', // Pastikan path logo aplikasi Anda benar
                height: 120, // Sesuaikan ukuran logo
                width: 120,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                _appName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontFamily: 'InterBold',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Versi: $_version (Build $_buildNumber)',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontFamily: 'InterMedium',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(height: 40, thickness: 1.0, color: Colors.grey),
            Text(
              'Deskripsi Aplikasi',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontFamily: 'InterBold',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'E-Library adalah aplikasi perpustakaan digital inovatif yang dirancang untuk membawa dunia literasi langsung ke genggaman Anda. Dengan E-Library, Anda dapat menjelajahi ribuan judul buku dari berbagai genre, mulai dari fiksi, non-fiksi, sains, pendidikan, hingga buku motivasi dan manga. Aplikasi ini memudahkan Anda untuk menemukan, membaca, dan mengelola koleksi buku favorit Anda kapan saja dan di mana saja. Kami berkomitmen untuk menyediakan pengalaman membaca yang lancar dan menyenangkan bagi semua.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.grey[800],
                fontFamily: 'InterRegular',
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            Text(
              'Fitur Utama:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontFamily: 'InterBold',
              ),
            ),
            const SizedBox(height: 10),
            _buildFeaturePoint(
                'Koleksi Buku Lengkap: Akses berbagai kategori buku dengan mudah.',
                Icons.library_books),
            _buildFeaturePoint(
                'Rekomendasi Personal: Temukan buku baru berdasarkan rating tertinggi.',
                Icons.star),
            _buildFeaturePoint(
                'Antarmuka Intuitif: Navigasi yang mudah dan desain yang ramah pengguna.',
                Icons.devices),
            _buildFeaturePoint(
                'Manajemen Profil: Kelola informasi pengguna dan riwayat baca Anda.',
                Icons.person),
            _buildFeaturePoint(
                'Pencarian Cepat: Temukan buku yang Anda cari dalam hitungan detik.',
                Icons.search),
            const SizedBox(height: 20),
            Text(
              'Cara Penggunaan Aplikasi',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontFamily: 'InterBold',
              ),
            ),
            const SizedBox(height: 10),
            _buildUsagePoint(
                '1. Registrasi/Login',
                'Daftarkan akun baru atau masuk dengan akun yang sudah ada. Jika Anda sudah memiliki akun, masukkan email dan kata sandi Anda. Jika belum, lakukan pendaftaran cepat.',
                'user_add_rounded' // Contoh icon, bisa diganti
                ),
            _buildUsagePoint(
                '2. Jelajahi Kategori',
                'Di halaman utama, Anda bisa melihat berbagai kategori buku. Ketuk kategori untuk melihat daftar buku di dalamnya. Anda juga bisa melihat buku-buku rekomendasi berdasarkan rating dan buku-buku lainnya.',
                'category' // Contoh icon, bisa diganti
                ),
            _buildUsagePoint(
                '3. Cari Buku',
                'Gunakan fitur pencarian untuk menemukan buku berdasarkan judul atau penulis. Ketuk ikon pencarian dan masukkan kata kunci Anda.',
                'search' // Contoh icon, bisa diganti
                ),
            _buildUsagePoint(
                '4. Lihat Detail Buku',
                'Ketuk kartu buku untuk melihat detail lengkap seperti sinopsis, penulis, rating, dan stok tersedia. Di halaman detail, Anda mungkin menemukan opsi untuk membaca buku (jika fitur ini tersedia).',
                'info_outline' // Contoh icon, bisa diganti
                ),
            _buildUsagePoint(
                '5. Kelola Profil',
                'Ketuk ikon profil di pojok kanan atas untuk melihat dan mengedit informasi profil Anda. Anda dapat memperbarui nama, email, atau gambar profil.',
                'account_circle' // Contoh icon, bisa diganti
                ),
            const SizedBox(height: 20),
            Text(
              'Dukungan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontFamily: 'InterBold',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Jika Anda memiliki pertanyaan, saran, atau mengalami masalah saat menggunakan aplikasi, jangan ragu untuk menghubungi tim dukungan kami melalui email di:',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.grey[800],
                fontFamily: 'InterRegular',
              ),
              textAlign: TextAlign.justify,
            ),
            GestureDetector(
              onTap: () {
                // TODO: Implementasi membuka email client atau copy email ke clipboard
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email dukungan disalin!')),
                );
              },
              child: Text(
                'support@elibraryapp.com', // Ganti dengan email dukungan Anda
                style: TextStyle(
                  fontSize: 16,
                  color: primaryColor,
                  fontFamily: 'InterBold',
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                '© 2025 E-Library App. Hak Cipta Dilindungi.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'InterRegular',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget untuk Fitur Utama
  Widget _buildFeaturePoint(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon,
              size: 20, color: primaryColor), // Menggunakan icon yang diberikan
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                fontFamily: 'InterRegular',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget untuk Cara Penggunaan
  Widget _buildUsagePoint(String title, String description, String iconName) {
    IconData icon;
    // Menggunakan switch case untuk mapping string ke IconData
    switch (iconName) {
      case 'user_add_rounded':
        icon = Icons.person_add_rounded;
        break;
      case 'category':
        icon = Icons.category;
        break;
      case 'search':
        icon = Icons.search;
        break;
      case 'info_outline':
        icon = Icons.info_outline;
        break;
      case 'account_circle':
        icon = Icons.account_circle;
        break;
      default:
        icon = Icons.help_outline;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 24, color: primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontFamily: 'InterMedium',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    fontFamily: 'InterRegular',
                    height: 1.4,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
