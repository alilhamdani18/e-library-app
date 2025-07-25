import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // Fungsi untuk mengirim email verifikasi
  Future<void> sendEmailVerification() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        debugPrint('Email verifikasi berhasil dikirim ke: ${user.email}');
      } on FirebaseAuthException catch (e) {
        debugPrint('Firebase Auth Error (Send Email Verification): ${e.code} - ${e.message}');
        rethrow; // Lempar ulang error agar bisa ditangani di UI
      } catch (e) {
        debugPrint('General Error (Send Email Verification): $e');
        rethrow; // Lempar ulang error agar bisa ditangani di UI
      }
    }
  }

  Future<String?> signUpWithEmail(
      String name, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        await user.sendEmailVerification();

        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'emailVerified': user.emailVerified,
          'createdAt': FieldValue.serverTimestamp(),
        });
        return user.uid;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error (Sign Up): ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      debugPrint('General Error (Sign Up): $e');
      return null;
    }
  }

  // SIGN IN dengan Email & Password
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = userCredential.user;

      // --- START: Perubahan di sini untuk verifikasi email ---
      if (user != null && !user.emailVerified) {
        // Jika email belum diverifikasi, logout pengguna dan lempar error
        await _auth.signOut(); // Logout pengguna secara otomatis
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Email Anda belum diverifikasi. Silakan cek email Anda untuk tautan verifikasi.',
        );
      }
      // --- END: Perubahan di sini ---

      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error (Sign In): ${e.code} - ${e.message}');
      throw e; // Tetap lempar exception untuk ditangani di UI
    } catch (e) {
      debugPrint('General Error (Sign In): $e');
      throw Exception('Terjadi kesalahan tidak terduga saat login: $e');
    }
  }

  // LOGOUT
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }

  // GET CURRENT USER
  User? get currentUser => _auth.currentUser;

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