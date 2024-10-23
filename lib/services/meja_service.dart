import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukk_cafe/models/meja.dart';

class MejaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Meja>> getMeja() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('meja').get();

      List<Meja> mejaList = querySnapshot.docs.map((doc) {
        return Meja.fromFirestore(doc);
      }).toList();

      return mejaList;
    } catch (e) {
      print("Error mengambil menu: $e");
      throw Exception("Error mengambil menu");
    }
  }

  Future<void> updateMejaStatus(
    String id_meja,
    bool status,
  ) async {
    try {
      await _firestore.collection('meja').doc(id_meja).update({
        'status': status,
      });
    } catch (e) {
      print("Error updating meja status: $e");
      throw Exception("Error updating meja status");
    }
  }

  static Future<void> updateStatusMeja(String idMeja, bool status) async {
    try {
      await FirebaseFirestore.instance.collection('meja').doc(idMeja).update({
        'status': status,
      });
    } catch (e) {
      throw Exception('Failed to update meja status: $e');
    }
  }

  Future<void> createMeja(Meja meja) async {
    try {
      await _firestore.collection('meja').doc(meja.idMeja).set(
            meja.toMap(),
          );
      print("Meja berhasil ditambahkan");
    } catch (e) {
      print("Error creating meja: $e");
      throw Exception("Error creating meja");
    }
  }
}
