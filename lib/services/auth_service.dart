import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SIGN UP
  Future<String?> signUpWithEmail(String name, String email, String password) async {
    try {
      // Buat akun di Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Simpan data user ke Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null; // sukses
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Terjadi kesalahan saat registrasi.';
    }
  }

  // SIGN IN
  Future<String?> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // sukses
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Terjadi kesalahan saat login.';
    }
  }

  // SIGN IN WITH GOOGLE
  Future<User?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null; // user batal login

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await _auth.signInWithCredential(credential);

    // Simpan atau update data user ke Firestore
    final userDoc = _firestore.collection('users').doc(userCredential.user!.uid);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        'uid': userCredential.user!.uid,
        'name': userCredential.user!.displayName ?? '',
        'email': userCredential.user!.email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return userCredential.user;
  } catch (e) {
    debugPrint('Google Sign-In Error: $e');
    return null;
  }
}


  // LOGOUT
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  // GET CURRENT USER
  User? get currentUser => _auth.currentUser;
}
