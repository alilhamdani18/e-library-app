import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_library/utils/colors.dart';
import 'package:e_library/utils/dialog.dart';
import 'package:e_library/views/main_screen.dart';
import 'package:e_library/widgets/set_password.dart';
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

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userController = TextEditingController();

  void _handleRegister() async {
    final name = userController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      final result = await AuthService().signUpWithEmail(name, email, password);

      if (!mounted) return;

      if (result == null) {
        showAwesomeLibraryDialog(
          context,
          title: 'Register Berhasil!',
          message: 'Silahkan login',
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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result)));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field wajib diisi')),
      );
    }
  }

  Future<void> _handleGoogleSignUp() async {
    final user = await AuthService().signInWithGoogle();

    if (!mounted) return;

    if (user != null) {
      final isNewUser =
          user.metadata.creationTime == user.metadata.lastSignInTime;

      if (isNewUser) {
        // Jika user baru, arahkan ke halaman buat password
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SetPasswordPage(email: user.email ?? ''),
          ),
        );
      } else {
        // Jika bukan user baru, langsung ke halaman utama
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(initialIndex: 0),
          ),
        );
      }
    } else {
      // Gagal login Google
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login dengan Google gagal')),
      );
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
                                  borderSide: BorderSide(
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
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
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
                                  borderSide: BorderSide(
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
                            onPressed: _handleRegister,
                            child: Text('Daftar',
                                style: TextStyle(
                                    color: textColor,
                                    fontSize: 16,
                                    fontFamily: 'InterSemiBold')),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'atau',
                                style: TextStyle(
                                    color: textGreyColor, fontSize: 16),
                              ),
                            ),
                            Expanded(
                              child: Divider(),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ElevatedButton.icon(
                            onPressed: _handleGoogleSignUp,
                            icon: Image.asset(
                              'assets/images/google-icon.png',
                              width: 24,
                            ),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                'Sign Up dengan Google',
                                style: TextStyle(
                                  fontFamily: 'InterSemiBold',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: greyBtnColor,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              side: BorderSide(color: primaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: const Size.fromHeight(50),
                            ),
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
