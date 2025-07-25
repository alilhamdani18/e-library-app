import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_library/utils/colors.dart';
import 'package:e_library/utils/dialog.dart';
import 'package:flutter/material.dart';
import 'package:e_library/views/login.dart';
import 'package:e_library/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isHide = true;
  bool isConfirmHide = true;
  bool _isLoading = false; 

  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    userController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    final name = userController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Validasi input
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {}
    final emailRegex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");
    if (!emailRegex.hasMatch(email)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format email tidak valid')),
      );
      return;
    }
    final passwordStrengthRegex =
        RegExp(r"""^(?=.*[0-9])(?=.*[!@#$%^&*(),.?"':{}|<>]).*$""");
    if (!passwordStrengthRegex.hasMatch(password)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Password harus mengandung angka dan karakter khusus')),
      );
      return;
    }
    if (password.length < 6) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password minimal 6 karakter')),
      );
      return;
    }

    if (password != confirmPassword) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Password dan Konfirmasi Password tidak cocok')),
      );
      return;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final String? resultUid =
          await AuthService().signUpWithEmail(name, email, password);

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      if (resultUid != null) {
        userController.clear();
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();

        showAwesomeLibraryDialog(
          context,
          title: 'Registrasi Berhasil!',
          message:
              'Akun Anda berhasil dibuat. Silakan cek email Anda (${email}) untuk verifikasi sebelum login.',
          dialogType: DialogType.success,
          autoClose: false,
          onOk: () {
            if (!mounted) return;
            // Navigasi ke halaman Login
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const Login(),
              ),
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Registrasi gagal. Silakan coba lagi.')));
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      String errorMessage = 'Registrasi gagal. Silakan coba lagi.';

      if (e.code == 'email-already-in-use') {
        errorMessage =
            'Email ini sudah terdaftar. Silakan gunakan email lain atau login.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Password terlalu lemah.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Format email tidak valid.';
      } else {
        errorMessage =
            e.message ?? 'Terjadi kesalahan tidak dikenal saat registrasi.';
      }

      // Notifikasi error dengan SnackBar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Registrasi gagal. Terjadi kesalahan tidak terduga: ${e.toString()}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
                        child: Column(
                          children: [
                            Image.asset('assets/images/logo.png',
                                width: 100, height: 100),
                            Text(
                              'Selamat Datang',
                              style: TextStyle(
                                  fontFamily: 'InterBold',
                                  fontSize: 28,
                                  color: primaryColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                'Masukkan username, email, dan password untuk membuat akun',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'InterMedium',
                                    fontSize: 16,
                                    color: textGreyColor),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: Text(
                                    'Nama Lengkap',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: 'InterMedium',
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: TextFormField(
                                controller: userController,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(8),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          width: 0, style: BorderStyle.none),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: primaryColor, width: 2)),
                                    filled: true,
                                    fillColor: greyBtnColor,
                                    hintText: 'myname18',
                                    hintStyle: TextStyle(
                                      color: textGreyColor,
                                    )),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: Text(
                                    'Email',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: 'InterMedium',
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(8),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          width: 0, style: BorderStyle.none),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: primaryColor, width: 2)),
                                    filled: true,
                                    fillColor: greyBtnColor,
                                    hintText: 'name@gmail.com',
                                    hintStyle: TextStyle(
                                      color: textGreyColor,
                                    )),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: Text(
                                    'Password',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: 'InterMedium',
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom:
                                      8), // Changed from 16 to 8 for spacing
                              child: TextFormField(
                                controller: passwordController,
                                obscureText: isHide,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isHide = !isHide;
                                          });
                                        },
                                        icon: Icon(
                                          isHide
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: textGreyColor,
                                        )),
                                    contentPadding: const EdgeInsets.all(8),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          width: 0, style: BorderStyle.none),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: primaryColor, width: 2)),
                                    filled: true,
                                    fillColor: greyBtnColor,
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                      color: textGreyColor,
                                    )),
                              ),
                            ),
                            // Konfirmasi Password field
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: Text(
                                    'Konfirmasi Password',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: 'InterMedium',
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 16), // Padding bottom for this field
                              child: TextFormField(
                                controller: confirmPasswordController,
                                obscureText:
                                    isConfirmHide, // Gunakan flag visibilitas baru
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isConfirmHide =
                                                !isConfirmHide; // Toggle visibilitas konfirmasi password
                                          });
                                        },
                                        icon: Icon(
                                          isConfirmHide
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: textGreyColor,
                                        )),
                                    contentPadding: const EdgeInsets.all(8),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          width: 0, style: BorderStyle.none),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: primaryColor, width: 2)),
                                    filled: true,
                                    fillColor: greyBtnColor,
                                    hintText: 'Konfirmasi Password',
                                    hintStyle: TextStyle(
                                      color: textGreyColor,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                                // Tombol akan nonaktif saat loading
                                onPressed: _isLoading ? null : _handleRegister,
                                child: _isLoading
                                    ? SizedBox(
                                        // Tampilkan CircularProgressIndicator saat loading
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: textColor,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : Text('Daftar',
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: 16,
                                            fontFamily: 'InterSemiBold')),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah Punya Akun ? ',
                      style: TextStyle(
                        fontFamily: 'InterMedium',
                        fontSize: 16,
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const Login()));
                        },
                        child: Text(
                          'Masuk Sekarang',
                          style: TextStyle(
                            fontFamily: 'InterSemibold',
                            color: primaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
