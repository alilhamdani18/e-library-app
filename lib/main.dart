import 'package:e_library/utils/colors.dart';
import 'package:e_library/views/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Atur warna status bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor:
        Color.fromARGB(255, 10, 175, 84), // Warna background status bar
    statusBarIconBrightness:
        Brightness.light, // Warna ikon status bar (light untuk ikon putih)
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Library HIMPELMANAWAKA',
      theme: ThemeData(
        // primarySwatch: Color.fromARGB(255, 10, 175, 84),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color.fromARGB(255, 10, 175, 84),
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
