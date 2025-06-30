import 'package:e_library/utils/colors.dart';
import 'package:e_library/views/main_screen.dart';
import 'package:e_library/views/onboarding.dart'; 
import 'package:e_library/views/login.dart';   
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';   
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Atur warna status bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color.fromARGB(255, 10, 175, 84), // Warna background status bar
    statusBarIconBrightness: Brightness.light, // Warna ikon status bar (light untuk ikon putih)
  ));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _initialWidget = const Scaffold(body: Center(child: CircularProgressIndicator())); // Widget loading awal

  @override
  void initState() {
    super.initState();
    _checkInitialRoute();
  }

  Future<void> _checkInitialRoute() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (!hasSeenOnboarding) {
      setState(() {
        _initialWidget = const Onboarding();
      });
    } else {
      if (currentUser != null) {
        setState(() {
          _initialWidget = const MainScreen();
        });
      } else {
        setState(() {
          _initialWidget = const Login();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Library HIMPELMANAWAKA',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color.fromARGB(255, 10, 175, 84),
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      home: _initialWidget, 
    );
  }
}