import 'package:flutter/material.dart';
import 'package:e_library/utils/colors.dart';
// import 'dart:convert';
import 'package:e_library/models/user.dart';
import 'package:e_library/services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late String userId;
  User? user;
  bool isLoading = true;

  Future<void> getUserData() async {
    try {
      final data = await ApiService().getUserProfile(userId);
      setState(() {
        user = data;
        print('User data from API: $data');

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Bisa tampilkan error snackbar/toast
      print('Error fetching user: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    final fbUser = fb.FirebaseAuth.instance.currentUser;
    if (fbUser != null) {
      userId = fbUser.uid;
      print(userId);
      getUserData();
    } else {
      // handle user belum login
      print('User belum login');
      setState(() {
        isLoading = false;
      });
    }
  }

  String username = 'alilhd_18';
  String email = 'alilhamdanialil782@gmail.com';
  String nama = 'M. Alil Hamdani';
  String phone = '081945437744';
  String alamat = 'Dasan Baru Barat, Kalijaga Selatan';

  void _showEditProfileSheet() {
    final usernameController = TextEditingController(text: user?.username);
    final emailController = TextEditingController(text: user?.email);
    final namaController = TextEditingController(text: user?.name);
    final phoneController = TextEditingController(text: user?.phone);
    final alamatController = TextEditingController(text: user?.address);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.85,
        // minChildSize: 0.4,
        initialChildSize: 0.60,
        builder: (_, scrollController) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 12,
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Edit Profil',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'InterSemiBold',
                ),
              ),
              const SizedBox(height: 24),

              // Username
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Nama Lengkap
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Nomor Telepon
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Alamat
              TextFormField(
                controller: alamatController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Simpan button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      username = usernameController.text;
                      email = emailController.text;
                      nama = namaController.text;
                      phone = phoneController.text;
                      alamat = alamatController.text;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Simpan',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          'User Profile',
          style: TextStyle(
              color: Colors.white, fontFamily: 'InterSemiBold', fontSize: 20),
        ),
        actions: [
          PopupMenuTheme(
            data: PopupMenuThemeData(
              textStyle: TextStyle(fontSize: 14),
              menuPadding: EdgeInsets.all(0),
            ),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _showEditProfileSheet();
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Edit Profil'),
                  ),
                ];
              },
              icon: const Icon(Icons.more_vert, color: Colors.white),
            ),
          )
        ],
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? const Center(child: Text('Gagal memuat data user'))
              : SingleChildScrollView(
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
                                image: user!.profileImageUrl != null
                                    ? DecorationImage(
                                        image: NetworkImage(
                                            user!.profileImageUrl!),
                                        fit: BoxFit.cover)
                                    : const DecorationImage(
                                        image: AssetImage(
                                            'assets/images/google-icon.png'),
                                        fit: BoxFit.cover),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Ganti Avatar'),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(24),
                        width: double.infinity,
                        child: Column(
                          children: [
                            _buildProfileRow('Username',
                                user!.username ?? 'username tidak ada'),
                            _buildProfileRow('Email', user!.email),
                            _buildProfileRow('Nama Lengkap', user!.name ?? ''),
                            _buildProfileRow('Phone', user!.phone ?? ''),
                            _buildProfileRow('Alamat', user!.address ?? ''),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildProfileRow(String title, String value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                title,
                style:
                    const TextStyle(fontFamily: 'InterSemiBold', fontSize: 16),
              ),
              Text(
                value,
                style: TextStyle(
                    color: textGreyColor,
                    fontFamily: 'InterSemiBold',
                    fontSize: 16),
              ),
            ]),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
