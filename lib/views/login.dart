import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_library/utils/colors.dart';
import 'package:e_library/utils/dialog.dart';
import 'package:e_library/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_library/views/register.dart';
import 'package:e_library/services/auth_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isHide = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password wajib diisi')),
      );
      return;
    }

    final emailRegex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format email tidak valid')),
      );
      return;
    }

    final result = await AuthService().signInWithEmail(email, password);

    if (!mounted) return;

    if (result == null) {
      // Tampilkan dialog berhasil login
      showAwesomeLibraryDialog(
        context,
        title: 'Login Berhasil!',
        message: 'Selamat datang kembali!',
        dialogType: DialogType.success,
        autoClose: true,
        onOk: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const MainScreen(initialIndex: 0),
            ),
          );
        },
      );
    } else {
      // Gagal login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: InkWell(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
              child: Column(
                children: [
                  Image.asset('assets/images/logo.png',
                      width: 150, height: 150),
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
                      'Masukkan email dan password untuk melanjutkan ke aplikasi',
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
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: primaryColor, width: 2)),
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
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: isHide,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                isHide = !isHide;
                                setState(() {});
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
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: primaryColor, width: 2)),
                          filled: true,
                          fillColor: greyBtnColor,
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: textGreyColor,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _handleLogin,
                      child: Text('Masuk',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontFamily: 'InterSemiBold')),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Belum Punya Akun ? ',
                    style: TextStyle(
                      fontFamily: 'InterMedium',
                      fontSize: 16,
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const Register()));
                      },
                      child: Text(
                        'Daftar Sekarang',
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
      ),
    );
  }
}
