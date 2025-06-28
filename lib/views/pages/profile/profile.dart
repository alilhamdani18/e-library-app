import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_library/services/auth_service.dart';
import 'package:e_library/utils/colors.dart';
import 'package:e_library/utils/dialog.dart';
import 'package:e_library/views/login.dart';
import 'package:e_library/views/pages/profile/about_app.dart';
import 'package:e_library/views/pages/profile/loan_book.dart';
import 'package:e_library/views/pages/profile/saved_book.dart';
import 'package:e_library/views/pages/profile/user_profile.dart';
import 'package:e_library/widgets/profile_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int myIndex = 2;

  String? userId;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    userId = currentUser?.uid;
    if (userId != null) {
      fetchUserData(userId!);
    }
  }

  Future<void> fetchUserData(String uid) async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        setState(() {
          userData = doc.data();
          isLoading = false;
        });
      } else {
        // Data tidak ditemukan
        setState(() {
          userData = null;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _handleLogout(BuildContext context) {
    // Langkah 1: Konfirmasi logout
    showAwesomeLibraryDialog(
      context,
      title: 'Konfirmasi Logout',
      message: 'Apakah kamu yakin ingin keluar dari akun?',
      dialogType: DialogType.question,
      showCancelBtn: true,
      okText: 'Ya, Keluar',
      cancelText: 'Batal',
      onOk: () async {
        await AuthService().signOut();

        if (!context.mounted) return;

        // Langkah 2: Notifikasi berhasil logout
        showAwesomeLibraryDialog(
          context,
          title: 'Logout Berhasil',
          message: 'Kamu telah berhasil keluar dari akun.',
          dialogType: DialogType.success,
          autoClose: true,
          onOk: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const Login()),
              (route) => false,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'InterBold',
            fontSize: 20,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Container(
        color: thirdColor,
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          color: greyBtnColor,
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            image: AssetImage('assets/images/google-icon.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        userData?['name'] ?? 'Pengguna',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'InterSemiBold',
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: greyBtnColor,
                        ),
                        child: Text(
                          userData?['email'] ?? 'Pengguna',
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontFamily: 'InterSemiBold',
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: Column(
                    children: [
                      ProfileMenuItem(
                        icon: Icons.person,
                        title: 'Data Pengguna',
                        onTap: () {
                          if (userId != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserProfile(),
                              ),
                            );
                          }
                        },
                        childColor: const Color.fromARGB(255, 4, 114, 31),
                      ),
                      const SizedBox(height: 10),
                      ProfileMenuItem(
                        icon: Icons.bookmark_added,
                        title: 'Buku Tersimpan',
                        onTap: () {
                          final user = FirebaseAuth.instance.currentUser;
                          final userId = user?.uid;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SavedBook(
                                      userId: userId!,
                                    )),
                          );
                        },
                        childColor: const Color.fromARGB(255, 4, 114, 31),
                      ),
                      const SizedBox(height: 10),
                      ProfileMenuItem(
                        icon: Icons.menu_book_outlined,
                        title: 'Buku Dipinjam',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoanBook()),
                          );
                        },
                        childColor: const Color.fromARGB(255, 4, 114, 31),
                      ),
                      const SizedBox(height: 10),
                      ProfileMenuItem(
                        icon: Icons.error_outlined,
                        title: 'Tentang Aplikasi',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AboutApp()),
                          );
                        },
                        childColor: const Color.fromARGB(255, 4, 114, 31),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: TextButton(
                    onPressed: () => _handleLogout(context),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'InterBold',
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
