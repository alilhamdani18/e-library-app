import 'package:e_library/utils/colors.dart';
import 'package:e_library/widgets/bottom_sheet.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  int myIndex = 2;
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
          'User Profile',
          style: TextStyle(
              color: Colors.white, fontFamily: 'InterSemiBold', fontSize: 20),
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
                  ElevatedButton(onPressed: () {}, child: Text('Ganti Profil'))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(24),
              width: double.infinity,
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Username',
                                style: TextStyle(
                                    fontFamily: 'InterSemiBold', fontSize: 16),
                              ),
                              Text(
                                'alilhd_18',
                                style: TextStyle(
                                    color: textGreyColor,
                                    fontFamily: 'InterSemiBold',
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25)),
                                  ),
                                  builder: (_) => BottomSheetWidget(
                                    title: 'Edit Username',
                                    hintText: 'Masukkan username baru',
                                    buttonText: 'Simpan',
                                    initialValue:
                                        'alilhd_18', // atau apapun isi defaultnya
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(50, 30),
                              ),
                              child: Text(
                                'Edit',
                                style: TextStyle(fontSize: 14),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email',
                                style: TextStyle(
                                    fontFamily: 'InterSemiBold', fontSize: 16),
                              ),
                              Text(
                                'alilhamdanialil782@gmail.com',
                                style: TextStyle(
                                    color: textGreyColor,
                                    fontFamily: 'InterSemiBold',
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25)),
                                  ),
                                  builder: (_) => BottomSheetWidget(
                                    title: 'Edit Email',
                                    hintText: 'Masukkan Email Baru',
                                    buttonText: 'Simpan',
                                    initialValue:
                                        'alilhamdani782@gmail.com', // atau apapun isi defaultnya
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(50, 30),
                              ),
                              child: Text(
                                'Edit',
                                style: TextStyle(fontSize: 14),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nama Lengkap',
                                style: TextStyle(
                                    fontFamily: 'InterSemiBold', fontSize: 16),
                              ),
                              Text(
                                'M. Alil Hamdani',
                                style: TextStyle(
                                    color: textGreyColor,
                                    fontFamily: 'InterSemiBold',
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25)),
                                  ),
                                  builder: (_) => BottomSheetWidget(
                                    title: 'Edit Nama Lengkap',
                                    hintText: 'Masukkan Nama Baru',
                                    buttonText: 'Simpan',
                                    initialValue:
                                        'M. Alil Hamdani', // atau apapun isi defaultnya
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(50, 30),
                              ),
                              child: Text(
                                'Edit',
                                style: TextStyle(fontSize: 14),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Phone',
                                style: TextStyle(
                                    fontFamily: 'InterSemiBold', fontSize: 16),
                              ),
                              Text(
                                '081945437744',
                                style: TextStyle(
                                    color: textGreyColor,
                                    fontFamily: 'InterSemiBold',
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25)),
                                  ),
                                  builder: (_) => BottomSheetWidget(
                                    title: 'Edit Nomor Telepon',
                                    hintText: 'Masukkan Nomor Baru',
                                    buttonText: 'Simpan',
                                    initialValue:
                                        '081945437744', // atau apapun isi defaultnya
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(50, 30),
                              ),
                              child: Text(
                                'Edit',
                                style: TextStyle(fontSize: 14),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Alamat',
                                style: TextStyle(
                                    fontFamily: 'InterSemiBold', fontSize: 16),
                              ),
                              Text(
                                'Dasan Baru Barat, Kalijaga Selatan',
                                style: TextStyle(
                                    color: textGreyColor,
                                    fontFamily: 'InterSemiBold',
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25)),
                                  ),
                                  builder: (_) => BottomSheetWidget(
                                    title: 'Edit Alamat',
                                    hintText: 'Masukkan Alamat Baru',
                                    buttonText: 'Simpan',
                                    initialValue:
                                        'Dasan Baru Barat, Kalijaga Selatan', // atau apapun isi defaultnya
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(50, 30),
                              ),
                              child: Text(
                                'Edit',
                                style: TextStyle(fontSize: 14),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
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
