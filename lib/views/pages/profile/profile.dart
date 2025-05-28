import 'package:e_library/utils/colors.dart';
import 'package:e_library/views/login.dart';
import 'package:e_library/views/pages/profile/about_app.dart';
import 'package:e_library/views/pages/profile/loan_book.dart';
import 'package:e_library/views/pages/profile/saved_book.dart';
import 'package:e_library/views/pages/profile/user_profile.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int myIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'InterBold',
            fontSize: 20,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              // height: 300,
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    // padding: EdgeInsets.all(35),
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: greyBtnColor,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/images/google-icon.png'),
                          fit: BoxFit.fill),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'alilhd18',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'InterSemiBold',
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: greyBtnColor,
                    ),
                    child: Text(
                      'hamdanialil782@gmail.com',
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontFamily: 'InterSemiBold',
                          fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const UserProfile()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: greyBtnColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person, color: textGreyColor),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Data Pengguna',
                                style: TextStyle(
                                    color: textGreyColor,
                                    fontFamily: 'InterSemiBold',
                                    fontSize: 16),
                              )
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: textGreyColor,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const SavedBook()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: greyBtnColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.bookmark_added, color: textGreyColor),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Buku Tersimpan',
                                style: TextStyle(
                                    color: textGreyColor,
                                    fontFamily: 'InterSemiBold',
                                    fontSize: 16),
                              )
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios_rounded,
                              color: textGreyColor)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => const LoanBook()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: greyBtnColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.menu_book_outlined,
                                  color: textGreyColor),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Buku Dipinjam',
                                style: TextStyle(
                                    color: textGreyColor,
                                    fontFamily: 'InterSemiBold',
                                    fontSize: 16),
                              )
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios_rounded,
                              color: textGreyColor)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => const AboutApp()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: greyBtnColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.error_outlined, color: textGreyColor),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Tentang Aplikasi',
                                style: TextStyle(
                                    color: textGreyColor,
                                    fontFamily: 'InterSemiBold',
                                    fontSize: 16),
                              )
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios_rounded,
                              color: textGreyColor)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 32),
              // width: double.infinity,
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(15)),
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => const Login()));
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'InterBold',
                      fontSize: 20,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
