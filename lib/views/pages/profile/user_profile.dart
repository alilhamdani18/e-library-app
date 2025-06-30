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

  bool _isUpdating = false;

  Future<void> getUserData() async {
    try {
      final fbUser = fb.FirebaseAuth.instance.currentUser;
      if (fbUser == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }
      userId = fbUser.uid;

      final data = await ApiService().getUserProfile(userId);
      setState(() {
        user = data;
        user!.email = fbUser.email!;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching user: $e');
      if (mounted) {
        showAwesomeLibraryDialog(context,
            title: 'Gagal Memuat Profil',
            message:
                'Terjadi kesalahan saat memuat data profil: ${e.toString()}',
            dialogType: DialogType.error,
            autoClose: true,
            autoCloseDelay: const Duration(seconds: 3));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<User?> _showEditProfileSheet() async {
    final nameController = TextEditingController(text: user?.name);
    final phoneController = TextEditingController(text: user?.phone);
    final alamatController = TextEditingController(text: user?.address);

    final User? updatedUserResult = await showModalBottomSheet<User?>(
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
        builder: (_, scrollController) => StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Padding(
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
                        backgroundColor: primaryColor,
                        foregroundColor: textColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isUpdating
                          ? null
                          : () async {
                              modalSetState(() {
                                _isUpdating = true;
                              });

                              final data = {
                                'name': nameController.text.trim(),
                                'phone': phoneController.text.trim(),
                                'address': alamatController.text.trim(),
                              };

                              try {
                                final updatedUserFromApi = await ApiService()
                                    .updateUserProfile(
                                        userId: userId, profileData: data);

                                final String? currentEmail = user?.email;
                                if (currentEmail != null) {
                                  updatedUserFromApi.email = currentEmail;
                                }

                                if (mounted) {
                                  modalSetState(() {
                                    _isUpdating = false;
                                  });
                                  showAwesomeLibraryDialog(context,
                                      title: 'Berhasil',
                                      message: 'Profil berhasil diperbarui',
                                      dialogType: DialogType.success,
                                      autoClose: true,
                                      autoCloseDelay:
                                          const Duration(seconds: 2), onOk: () {
                                    Navigator.pop(context, updatedUserFromApi);
                                  });
                                }
                              } catch (e) {
                                print('Error updating profile: $e');
                                if (mounted) {
                                  modalSetState(() {
                                    _isUpdating = false;
                                  });
                                  showAwesomeLibraryDialog(context,
                                      title: 'Terjadi Kesalahan',
                                      message:
                                          'Gagal memperbarui profil: ${e.toString()}',
                                      dialogType: DialogType.error,
                                      autoClose: true,
                                      autoCloseDelay:
                                          const Duration(seconds: 2), onOk: () {
                                    Navigator.pop(context, null);
                                  });
                                }
                              }
                            },
                      child: _isUpdating
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Simpan',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
    return updatedUserResult;
  }

  Future<void> _pickAndUploadAvatar() async {
    if (_isUpdating) return;

    setState(() {
      _isUpdating = true;
    });

    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      try {
        print('Uploading avatar for userId: $userId');
        final updatedUserResponse = await ApiService().updateUserProfile(
          userId: userId,
          profileImage: imageFile,
        );

        if (mounted) {
          setState(() {
            final String? currentEmail = user?.email;
            user = updatedUserResponse;
            if (currentEmail != null) {
              user!.email = currentEmail;
            }
            _isUpdating = false;
          });
        }
        print('Updated user data after avatar upload: $user');

        if (mounted) {
          showAwesomeLibraryDialog(context,
              title: 'Berhasil',
              message: 'Avatar Berhasil Diperbarui',
              dialogType: DialogType.success,
              autoClose: true,
              autoCloseDelay: const Duration(seconds: 2));
        }
      } catch (e) {
        print('Error uploading avatar: $e');
        if (mounted) {
          setState(() {
            _isUpdating = false;
          });
          showAwesomeLibraryDialog(context,
              title: 'Terjadi Kesalahan',
              message: 'Gagal memperbarui avatar: ${e.toString()}',
              dialogType: DialogType.error,
              autoClose: true,
              autoCloseDelay: const Duration(seconds: 2));
        }
      }
    } else {
      setState(() {
        _isUpdating = false;
      });
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
            onSelected: (value) async {
              if (value == 'edit') {
                final User? updatedUser = await _showEditProfileSheet();
                if (updatedUser != null) {
                  setState(() {
                    user = updatedUser;
                  });
                }
              }
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
              ? const Center(
                  child:
                      Text('Gagal memuat data user atau user tidak ditemukan.'))
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
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    color: greyBtnColor,
                                    shape: BoxShape.circle,
                                    image: user!.profileImageUrl != null &&
                                            user!.profileImageUrl!.isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(
                                                user!.profileImageUrl!),
                                            fit: BoxFit.cover)
                                        : const DecorationImage(
                                            image: AssetImage(
                                                'assets/images/placeholder_avatar.png'),
                                            fit: BoxFit.cover),
                                  ),
                                ),
                                if (_isUpdating)
                                  const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed:
                                  _isUpdating ? null : _pickAndUploadAvatar,
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
