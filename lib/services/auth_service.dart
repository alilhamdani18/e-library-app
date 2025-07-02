import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart'; // Hapus atau biarkan terkomentar

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream untuk memantau perubahan status otentikasi pengguna
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // SIGN UP dengan Email & Password
  // Mengembalikan UID pengguna jika berhasil, atau null jika gagal.
  // Pesan error akan ditampilkan di konsol atau bisa ditangkap di UI.
  Future<String?> signUpWithEmail(
      String name, String email, String password) async {
    try {
      // 1. Buat akun pengguna di Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // 2. Simpan data pengguna ke Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          // Anda bisa menambahkan field lain yang relevan di sini
        });
        return user.uid; // Mengembalikan UID jika sukses
      }
      return null; // Jika userCredential.user null
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error (Sign Up): ${e.code} - ${e.message}');
      // Anda bisa mengembalikan pesan yang lebih spesifik berdasarkan e.code jika diperlukan
      return null; // Mengembalikan null untuk menandakan kegagalan
    } catch (e) {
      debugPrint('General Error (Sign Up): $e');
      return null; // Mengembalikan null untuk menandakan kegagalan
    }
  }

  // SIGN IN dengan Email & Password
  // Mengembalikan UID pengguna jika berhasil, atau null jika gagal.
  Future<String?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential
          .user?.uid; // Mengembalikan UID jika sukses, null jika tidak
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error (Sign In): ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      debugPrint('General Error (Sign In): $e');
      return null;
    }
  }

  // LOGOUT
  Future<void> signOut() async {
    try {
      // await GoogleSignIn().signOut(); // Hapus baris ini
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }

  // GET CURRENT USER (menggunakan properti Stream user di atas lebih disarankan untuk memantau status)
  // Namun, jika Anda hanya perlu mengambil pengguna saat ini sekali:
  User? get currentUser => _auth.currentUser;

  // Anda bisa menambahkan fungsi untuk mendapatkan detail pengguna dari Firestore jika diperlukan
  Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user details: $e');
      return null;
    }
  }
}
