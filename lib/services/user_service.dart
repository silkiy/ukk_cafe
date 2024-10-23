import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<Map<String, dynamic>?> getUserByUid() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        print('Current User UID: ${user.uid}'); // Debugging statement
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          print('User document exists'); // Debugging statement
          String uid = userDoc['uid'] ?? '';
          String name = userDoc['name'] ?? 'No Name';
          String email =
              userDoc['email'] ?? 'No Email'; // Changed 'No Name' to 'No Email'
          String role = userDoc['role'] ?? 'No Role';

          return {
            'uid': uid, // Ensure keys are properly set for return
            'name': name,
            'email': email,
            'role': role,
          };
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

}
