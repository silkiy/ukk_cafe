import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isNavigating = false; // Flag untuk mencegah navigasi ganda

  Future<void> signIn(
      String email,
      String password,
      BuildContext context,
      Function(bool) onLoading, // Callback untuk mengontrol loading
      Function(String) onError // Callback untuk menangani error
      ) async {
    Timer? timer; // Timer untuk menangani timeout

    if (_isNavigating) return; // Jangan lakukan navigasi jika sudah ada proses

    try {
      _isNavigating = true;
      onLoading(true);

      // Set timer untuk menangani timeout
      timer = Timer(Duration(minutes: 1), () {
        if (context.mounted) {
          onLoading(false);
          onError('Periksa koneksi anda/gunakan koneksi yang stabil');
        }
      });

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          String role = userDoc.get('role');
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setInt(
            'loginTimestamp',
            DateTime.now().millisecondsSinceEpoch,
          );

          // Navigasi berdasarkan role
          if (role == 'admin') {
            Navigator.pushReplacementNamed(context, '/home_admin');
          } else if (role == 'kasir') {
            Navigator.pushReplacementNamed(context, '/home_kasir');
          } else if (role == 'manajer') {
            Navigator.pushReplacementNamed(context, '/home_manajer');
          } else {
            if (context.mounted) {
              onError('Role tidak dikenali');
            }
          }
        } else {
          if (context.mounted) {
            onError('Akun anda belum terdaftar, silahkan hubungi admin');
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (context.mounted) {
          onError('Akun tidak ditemukan. Silahkan hubungi admin');
        }
      } else if (e.code == 'wrong-password') {
        if (context.mounted) {
          onError('Password salah. Periksa kembali password Anda.');
        }
      } else {
        if (context.mounted) {
          onError('Terjadi kesalahan: ${e.message}');
        }
      }
    } catch (e) {
      if (context.mounted) {
        onError('Error signing in: $e');
      }
    } finally {
      timer?.cancel(); // Membatalkan timer jika proses selesai
      if (context.mounted) {
        onLoading(false);
      }
      _isNavigating =
          false; // Mengizinkan navigasi kembali setelah proses selesai
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      // Logout dari Firebase
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, '/landing_page');
    } catch (e) {
      print('Error signing out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out: $e'),
        ),
      );
    }
  }

  
}
