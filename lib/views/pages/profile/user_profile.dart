import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_library/utils/dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:e_library/utils/colors.dart';
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
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching user: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    final fbUser = fb.FirebaseAuth.instance.currentUser;
    if (fbUser != null) {
      userId = fbUser.uid;
      getUserData();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showEditProfileSheet() {
    final emailController = TextEditingController(text: user?.email);
    final nameController = TextEditingController(text: user?.name);
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
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final data = {
                      'name': nameController.text.trim(),
                      // 'email': emailController.text.trim(),
                      'phone': phoneController.text.trim(),
                      'address': alamatController.text.trim(),
                    };

                    try {
                      final updatedUser = await ApiService()
                          .updateUserProfile(userId: userId, profileData: data);

                      setState(() {
                        updatedUser;
                      });
                      Navigator.pop(context);
                      showAwesomeLibraryDialog(context,
                          title: 'Berhasil',
                          message: 'Profil berhasil diperbarui',
                          dialogType: DialogType.success,
                          autoClose: true,
                          autoCloseDelay: Duration(seconds: 2),
                          onOk: () {});
                    } catch (e) {
                      Navigator.pop(context);

                      showAwesomeLibraryDialog(context,
                          title: 'Terjadi Kesalahan',
                          message: e.toString(),
                          dialogType: DialogType.error,
                          autoClose: true,
                          autoCloseDelay: Duration(seconds: 2),
                          onOk: () {});
                    }
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

  Future<void> _pickAndUploadAvatar() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      try {
        print(userId);
        final updatedUser = await ApiService().updateUserProfile(
          userId: userId,
          profileImage: imageFile,
        );

        setState(() {
          user = updatedUser;
        });
        print(user);

        showAwesomeLibraryDialog(context,
            title: 'Berhasil',
            message: 'Avatar Berhasil Diperbarui',
            dialogType: DialogType.success,
            autoClose: true,
            autoCloseDelay: Duration(seconds: 2));
      } catch (e) {
        print(e);
        showAwesomeLibraryDialog(context,
            title: 'Terjadi Kesalahan',
            message: e.toString(),
            dialogType: DialogType.error,
            autoClose: true,
            autoCloseDelay: Duration(seconds: 2));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        ),
        title: const Text(
          'User Profile',
          style: TextStyle(
              color: Colors.white, fontFamily: 'InterSemiBold', fontSize: 20),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') _showEditProfileSheet();
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'edit',
                child: Text('Edit Profil'),
              ),
            ],
            icon: const Icon(Icons.more_vert, color: Colors.white),
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
                              onPressed: _pickAndUploadAvatar,
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
