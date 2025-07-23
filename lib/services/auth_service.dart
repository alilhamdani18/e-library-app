import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

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
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
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
      return userCredential; 
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error (Sign In): ${e.code} - ${e.message}');
      throw e;
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
