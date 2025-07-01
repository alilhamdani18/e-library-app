import 'package:e_library/utils/colors.dart';
import 'package:e_library/views/pages/notifications.dart';
import 'package:flutter/material.dart';
import 'package:e_library/views/pages/home/home.dart';
import 'package:e_library/views/pages/library/library.dart';
import 'package:e_library/views/pages/profile/profile.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  final Widget? nestedPage;
  const MainScreen({super.key, this.initialIndex = 0, this.nestedPage});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  // List halaman yang akan ditampilkan
  final List<Widget> _pages = [
    const Home(),
    const Library(),
    const Notifications(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.nestedPage ?? _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        // Background color of the navigation bar itself
        backgroundColor: primaryColor, // Ini akan membuat latar belakang hijau
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        // Warna item yang dipilih (ikon dan label)
        selectedItemColor:
            textColor, // Ganti ini agar kontras dengan primaryColor
        // Warna item yang tidak dipilih (ikon dan label)
        unselectedItemColor: textColor,
        onTap: _onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType
            .fixed, // Penting: Jika jumlah item > 3, gunakan fixed
      ),
    );
  }
}
