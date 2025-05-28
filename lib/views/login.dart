import 'package:e_library/utils/colors.dart';
import 'package:e_library/views/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:e_library/views/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isHide = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: InkWell(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
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
                    child: GestureDetector(
                      onTap: () {
                        if (emailController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const Home()));
                        } else {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const Login()));
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          'Masuk',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'InterBold',
                              fontSize: 16,
                              color: textColor),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'atau',
                          style:
                              TextStyle(color: textGreyColor, fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Divider(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                            border: Border.all(color: primaryColor),
                            color: greyBtnColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/google-icon.png',
                              width: 24,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                'Masuk dengan Google',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'InterSemiBold',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
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
