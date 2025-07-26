import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; 

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
        await user.sendEmailVerification();
        debugPrint('Email verifikasi berhasil dikirim ke: ${user.email}');

        await user.updateDisplayName(name);
        debugPrint(
            'Nama pengguna (${name}) berhasil disimpan sebagai displayName.');

        return user.uid;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error (Sign Up): ${e.code} - ${e.message}');
      rethrow; 
    } catch (e) {
      debugPrint('General Error (Sign Up): $e');
      rethrow; 
    }
  }

  // SIGN IN dengan Email & Password
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        if (!user.emailVerified) {
          await _auth.signOut(); 
          throw FirebaseAuthException(
            code: 'email-not-verified',
            message:
                'Email Anda belum diverifikasi. Silakan cek email Anda untuk tautan verifikasi.',
          );
        } else {
          DocumentSnapshot userDoc =
              await _firestore.collection('users').doc(user.uid).get();

          if (!userDoc.exists) {
            await _firestore.collection('users').doc(user.uid).set({
              'uid': user.uid,
              'email': user.email,
              'name': user
                  .displayName, 
              'emailVerified': user.emailVerified,
              'createdAt': FieldValue.serverTimestamp(),
              'lastLogin': FieldValue.serverTimestamp(),
            });
            debugPrint(
                'Data pengguna baru disimpan ke Firestore setelah verifikasi: ${user.email}');
          } else {
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
      rethrow; 
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
