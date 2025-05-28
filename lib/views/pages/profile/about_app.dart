import 'package:e_library/utils/colors.dart';
import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        title: Text(
          'About App',
          style: TextStyle(
              color: Colors.white, fontFamily: 'InterSemiBold', fontSize: 20),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.all(24),
              // width: double.infinity,
              child: Image.asset('assets/images/logo.png'),
            ),
            Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: thirdColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.error, color: primaryColor),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Tentang Aplikasi',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontFamily: 'InterSemiBold',
                                      fontSize: 16),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SingleChildScrollView(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  'Aplikasi mobile perpustakaan digital Himpelmanawaka. Dirancang dengan teknologi modern untuk kenyamanan pengguna !!',
                                  style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 77, 77, 77),
                                      fontSize: 16),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 15,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
