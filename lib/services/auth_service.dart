import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // Tetap diperlukan untuk debugPrint

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  Future<void> sendEmailVerification() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        debugPrint('Email verifikasi berhasil dikirim ke: ${user.email}');
      } on FirebaseAuthException catch (e) {
        debugPrint(
            'Firebase Auth Error (Send Email Verification): ${e.code} - ${e.message}');
        rethrow;
      } catch (e) {
        debugPrint('General Error (Send Email Verification): $e');
        rethrow;
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
        // Kirim email verifikasi segera setelah akun dibuat di Firebase Auth
        await user.sendEmailVerification();
        debugPrint('Email verifikasi berhasil dikirim ke: ${user.email}');

        // --- MENAMBAHKAN: Simpan nama pengguna sebagai displayName ---
        await user.updateDisplayName(name);
        debugPrint(
            'Nama pengguna (${name}) berhasil disimpan sebagai displayName.');

        return user.uid;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error (Sign Up): ${e.code} - ${e.message}');
      rethrow; // Lempar ulang exception
    } catch (e) {
      debugPrint('General Error (Sign Up): $e');
      rethrow; // Lempar ulang exception
    }
  }

  // SIGN IN dengan Email & Password
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        // PERIKSA STATUS VERIFIKASI EMAIL SAAT LOGIN
        if (!user.emailVerified) {
          // Jika email belum diverifikasi, logout pengguna dan lempar error
          await _auth.signOut(); // Logout pengguna secara otomatis
          throw FirebaseAuthException(
            code: 'email-not-verified',
            message:
                'Email Anda belum diverifikasi. Silakan cek email Anda untuk tautan verifikasi.',
          );
        } else {
          // Email sudah diverifikasi, sekarang simpan data pengguna ke Firestore jika belum ada
          DocumentSnapshot userDoc =
              await _firestore.collection('users').doc(user.uid).get();

          if (!userDoc.exists) {
            // Jika dokumen pengguna belum ada di Firestore, buatlah
            await _firestore.collection('users').doc(user.uid).set({
              'uid': user.uid,
              'email': user.email,
              'name': user
                  .displayName, // --- MENAMBAHKAN: Ambil nama dari displayName ---
              'emailVerified': user.emailVerified,
              'createdAt': FieldValue.serverTimestamp(),
              'lastLogin': FieldValue.serverTimestamp(),
            });
            debugPrint(
                'Data pengguna baru disimpan ke Firestore setelah verifikasi: ${user.email}');
          } else {
            // Jika dokumen sudah ada, Anda bisa update timestamp login terakhir
            await _firestore.collection('users').doc(user.uid).update({
              'lastLogin': FieldValue.serverTimestamp(),
            });
            debugPrint('Data pengguna di Firestore diperbarui: ${user.email}');
          }
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error (Sign In): ${e.code} - ${e.message}');
      rethrow; // Tetap lempar exception untuk ditangani di UI
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
