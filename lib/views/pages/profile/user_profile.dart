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

  final fb.FirebaseAuth _auth =
      fb.FirebaseAuth.instance; 
  Future<void> getUserData() async {
    try {
      final fbUser = _auth.currentUser; 
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

  Future<void> _showChangePasswordSheet() async {
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmNewPasswordController =
        TextEditingController();

    final fb.User? currentUser = _auth.currentUser;
    if (currentUser == null ||
        !currentUser.providerData
            .any((info) => info.providerId == 'password')) {
      showAwesomeLibraryDialog(
        context,
        title: 'Tidak Diizinkan',
        message:
            'Untuk mengubah kata sandi, Anda harus login menggunakan email dan kata sandi.',
        dialogType: DialogType.info,
        autoClose: true,
        autoCloseDelay: const Duration(seconds: 3),
        onOk: () {
          Navigator.pop(context); 
        },
      );
      return;
    }

    await showModalBottomSheet(
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
                    'Ubah Kata Sandi',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'InterSemiBold',
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: oldPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi Lama',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi Baru',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: confirmNewPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Kata Sandi Baru',
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

                              if (newPasswordController.text.isEmpty ||
                                  confirmNewPasswordController.text.isEmpty) {
                                showAwesomeLibraryDialog(context,
                                    title: 'Perhatian',
                                    message:
                                        'Kata sandi baru tidak boleh kosong.',
                                    dialogType: DialogType.info,
                                    autoClose: true,
                                    autoCloseDelay: const Duration(seconds: 2));
                                modalSetState(() {
                                  _isUpdating = false;
                                });
                                return;
                              }

                              if (newPasswordController.text !=
                                  confirmNewPasswordController.text) {
                                showAwesomeLibraryDialog(context,
                                    title: 'Perhatian',
                                    message: 'Kata sandi baru tidak cocok.',
                                    dialogType: DialogType.info,
                                    autoClose: true,
                                    autoCloseDelay: const Duration(seconds: 2));
                                modalSetState(() {
                                  _isUpdating = false;
                                });
                                return;
                              }

                              try {
                                fb.User? currentUser = _auth.currentUser;
                                if (currentUser != null) {
                                  // Re-authenticate user before changing password
                                  fb.AuthCredential credential =
                                      fb.EmailAuthProvider.credential(
                                    email: currentUser.email!,
                                    password: oldPasswordController.text,
                                  );
                                  await currentUser
                                      .reauthenticateWithCredential(credential);
                                  await currentUser.updatePassword(
                                      newPasswordController.text);

                                  if (mounted) {
                                    showAwesomeLibraryDialog(context,
                                        title: 'Berhasil',
                                        message: 'Kata sandi berhasil diubah.',
                                        dialogType: DialogType.success,
                                        autoClose: true,
                                        autoCloseDelay:
                                            const Duration(seconds: 2),
                                        onOk: () {
                                      Navigator.pop(context); // Tutup dialog
                                      Navigator.pop(
                                          context); // Tutup bottom sheet
                                    });
                                  }
                                }
                              } on fb.FirebaseAuthException catch (e) {
                                String errorMessage =
                                    'Gagal mengubah kata sandi.';
                                if (e.code == 'wrong-password') {
                                  errorMessage = 'Kata sandi lama salah.';
                                } else if (e.code == 'weak-password') {
                                  errorMessage = 'Kata sandi terlalu lemah.';
                                } else if (e.code == 'user-not-found' ||
                                    e.code == 'invalid-email') {
                                  errorMessage =
                                      'Akun tidak ditemukan atau email tidak valid.';
                                } else {
                                  errorMessage =
                                      'Terjadi kesalahan: ${e.message}';
                                }

                                if (mounted) {
                                  showAwesomeLibraryDialog(context,
                                      title: 'Gagal',
                                      message: errorMessage,
                                      dialogType: DialogType.error,
                                      autoClose: true,
                                      autoCloseDelay:
                                          const Duration(seconds: 3));
                                }
                              } catch (e) {
                                print('Error changing password: $e');
                                if (mounted) {
                                  showAwesomeLibraryDialog(context,
                                      title: 'Terjadi Kesalahan',
                                      message:
                                          'Gagal mengubah kata sandi: ${e.toString()}',
                                      dialogType: DialogType.error,
                                      autoClose: true,
                                      autoCloseDelay:
                                          const Duration(seconds: 2));
                                }
                              } finally {
                                modalSetState(() {
                                  _isUpdating = false;
                                });
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
                              'Ubah Kata Sandi',
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
  }

  // Future<void> _deleteAccount() async {
  //   // Tampilkan dialog konfirmasi sebelum menghapus akun
  //   showAwesomeLibraryDialog(
  //     context,
  //     title: 'Hapus Akun',
  //     message:
  //         'Apakah Anda yakin ingin menghapus akun ini? Tindakan ini tidak dapat dibatalkan.',
  //     dialogType: DialogType.warning,
  //     okText: 'Ya, Hapus',
  //     cancelText: 'Batal',
  //     onOk: () async {
  //       setState(() {
  //         _isUpdating = true;
  //       });

  //       try {
  //         final fb.User? currentUser = _auth.currentUser;
  //         if (currentUser != null) {
  //           await currentUser.delete();
  //           await ApiService().deleteUserProfile(userId);

  //           if (mounted) {
  //             showAwesomeLibraryDialog(context,
  //                 title: 'Berhasil',
  //                 message: 'Akun berhasil dihapus.',
  //                 dialogType: DialogType.success,
  //                 autoClose: true,
  //                 autoCloseDelay: const Duration(seconds: 2), onOk: () {
  //               // Navigasi ke halaman login atau halaman awal setelah penghapusan
  //               Navigator.of(context)
  //                   .pushNamedAndRemoveUntil('/login', (route) => false);
  //             });
  //           }
  //         }
  //       } on fb.FirebaseAuthException catch (e) {
  //         String errorMessage = 'Gagal menghapus akun.';
  //         if (e.code == 'requires-recent-login') {
  //           errorMessage =
  //               'Demi keamanan, Anda perlu login ulang untuk menghapus akun Anda.';
  //           if (mounted) {
  //             showAwesomeLibraryDialog(context,
  //                 title: 'Perhatian',
  //                 message: errorMessage,
  //                 dialogType: DialogType.warning,
  //                 autoClose: true,
  //                 autoCloseDelay: const Duration(seconds: 3), onOk: () {
  //               _auth.signOut();
  //               Navigator.of(context)
  //                   .pushNamedAndRemoveUntil('/login', (route) => false);
  //             });
  //           }
  //         } else {
  //           errorMessage = 'Terjadi kesalahan: ${e.message}';
  //         }
  //         print('Error deleting account: $e');
  //         if (mounted) {
  //           showAwesomeLibraryDialog(context,
  //               title: 'Gagal',
  //               message: errorMessage,
  //               dialogType: DialogType.error,
  //               autoClose: true,
  //               autoCloseDelay: const Duration(seconds: 3));
  //         }
  //       } catch (e) {
  //         print('Error deleting account: $e');
  //         if (mounted) {
  //           showAwesomeLibraryDialog(context,
  //               title: 'Terjadi Kesalahan',
  //               message: 'Gagal menghapus akun: ${e.toString()}',
  //               dialogType: DialogType.error,
  //               autoClose: true,
  //               autoCloseDelay: const Duration(seconds: 2));
  //         }
  //       } finally {
  //         setState(() {
  //           _isUpdating = false;
  //         });
  //       }
  //     },
  //     onCancel: () {
  //       setState(() {
  //         _isUpdating = false;
  //       });
  //     },
  //   );
  // }

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
        // initialChildSize: 0.60,
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
        print('User object BEFORE update: ${user?.toString()}');

        final User? updatedAvatarResponse =
            await ApiService().updateUserProfile(
          userId: userId,
          profileImage: imageFile,
        );

        final String? newProfileImageUrl =
            updatedAvatarResponse?.profileImageUrl;

        if (mounted) {
          setState(() {
            _isUpdating = false; 
            if (user != null && newProfileImageUrl != null) {
              user = user!.copyWith(
                profileImageUrl: newProfileImageUrl,
                updatedAt: DateTime.now(),
              );
            } else if (updatedAvatarResponse != null) {
              user = updatedAvatarResponse;
            }
          });
        }
        print('Updated user data after avatar upload: ${user?.toString()}');

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
              } else if (value == 'change_password') {
                await _showChangePasswordSheet();
              }
              // else if (value == 'delete_account') {
              //   await _deleteAccount();
              // }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'edit',
                child: Text('Edit Profil'),
              ),
              const PopupMenuItem<String>(
                // Item baru
                value: 'change_password',
                child: Text('Ubah Kata Sandi'),
              ),
              // const PopupMenuItem<String>(
              //   // Item baru
              //   value: 'delete_account',
              //   child: Text('Hapus Akun'),
              // ),
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
                                                'assets/images/icon-app.png'),
                                            fit: BoxFit.cover),
                                  ),
                                ),
                                if (_isUpdating)
                                  const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                    strokeWidth: 2,
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
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontFamily: 'InterSemiBold',
                          fontSize: 16,
                          color: primaryColor),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                          color: textGreyColor,
                          fontFamily: 'InterSemiBold',
                          fontSize: 16),
                    ),
                  ]),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
