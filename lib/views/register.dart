import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_library/utils/colors.dart';
import 'package:e_library/utils/dialog.dart';
import 'package:flutter/material.dart';
import 'package:e_library/views/login.dart';
import 'package:e_library/services/auth_service.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isHide = true;
  bool isConfirmHide = true; // Added for confirm password visibility

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController =
      TextEditingController(); // New controller
  TextEditingController userController = TextEditingController();

  void _handleRegister() async {
    final name = userController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword =
        confirmPasswordController.text; // Get confirm password

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field wajib diisi')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password minimal 6 karakter')),
      );
      return;
    }

    // New validation: Check if passwords match
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Password dan Konfirmasi Password tidak cocok')),
      );
      return;
    }

    final String? resultUid =
        await AuthService().signUpWithEmail(name, email, password);

    if (!mounted) return;

    if (resultUid != null) {
      showAwesomeLibraryDialog(
        context,
        title: 'Register Berhasil!',
        message: 'Silahkan login dengan akun Anda.',
        dialogType: DialogType.success,
        autoClose: true,
        onOk: () {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
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
                              padding: const EdgeInsets.symmetric(vertical: 6),
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
                              padding: const EdgeInsets.symmetric(vertical: 6),
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
                              padding: const EdgeInsets.symmetric(vertical: 6),
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
                              bottom: 8), // Changed from 16 to 8 for spacing
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
                        // --- New: Konfirmasi Password field ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
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
                                isConfirmHide, // Use new visibility flag
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isConfirmHide =
                                            !isConfirmHide; // Toggle confirm password visibility
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
                        // --- End New: Konfirmasi Password field ---
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: _handleRegister,
                            child: Text('Daftar',
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
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => const Login()));
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
    );
  }
}
