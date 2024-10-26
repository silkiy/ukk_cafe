import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/users.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<int> getUserCount() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      return snapshot.size;
    } catch (e) {
      print('Error fetching player count: $e');
      throw Exception('Error fetching player count.');
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>; // Casting data

        return UserModel(
          uid: data['uid'] ?? '',
          name: data['name'] ?? 'No Name',
          email: data['email'] ?? 'No Email',
          role: data['role'] ?? 'No Role',
        );
      }).toList();
    } catch (e) {
      print('Error fetching users: $e');
      throw Exception('Error fetching users.');
    }
  }

  Future<Map<String, dynamic>?> getUserByUid() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          final data = userDoc.data();
          if (data is Map<String, dynamic>) {
            String uid = data['uid'] ?? '';
            String name = data['name'] ?? 'No Name';
            String email = data['email'] ?? 'No Email';
            String role = data['role'] ?? 'No Role';

            return {
              'uid': uid,
              'name': name,
              'email': email,
              'role': role,
            };
          } else {
            print(
                'User data is not a Map<String, dynamic>'); // Debugging statement
          }
        } else {
          print('User document does not exist'); // Debugging statement
        }
      } else {
        print('No user is currently signed in'); // Debugging statement
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return null;
  }

  // Fitur untuk membuat pengguna baru
  Future<void> createUser(
    String email,
    String password,
    String name,
    String role,
  ) async {
    try {
      // Membuat pengguna baru dengan email dan password
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = result.user?.uid ?? '';

      // Menyimpan data pengguna ke Firestore
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'role': role,
      });
    } catch (e) {
      print('Error creating user: $e');
      throw Exception('Error creating user.');
    }
  }
}
