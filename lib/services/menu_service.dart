import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu.dart';

class MenuService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addMenu({
    required String id, // Menambahkan idMenu sebagai parameter
    required String? imageUrl,
    required String nama,
    required String jenis,
    required String hargaMenu,
    required String deskripsi,
  }) async {
    try {
      num harga = num.parse(hargaMenu); // Parsing hargaMenu ke num
      // Menggunakan set() dengan idMenu sebagai nama dokumen
      await _firestore.collection('menu_cafe').doc(id).set({
        'img': imageUrl,
        'name': nama,
        'jenis': jenis,
        'harga': harga,
        'deskripsi': deskripsi,
      });
      print('Menu successfully added with ID: $id');
    } catch (e) {
      print('Error adding menu: $e');
      throw Exception('Failed to add menu.');
    }
  }

  Future<List<Menu>> getMenu() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('menu_cafe').get();

      List<Menu> menuList = querySnapshot.docs.map((doc) {
        return Menu.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();

      return menuList;
    } catch (e) {
      print("Error mengambil menu: $e");
      throw Exception("Error mengambil menu");
    }
  }

  Future<List<Menu>> getMenuByJenis(String jenis) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('menu_cafe')
          .where('jenis', isEqualTo: jenis)
          .get();

      List<Menu> menuList = querySnapshot.docs.map((doc) {
        return Menu.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();

      return menuList;
    } catch (e) {
      print("Error mengambil menu: $e");
      throw Exception("Error mengambil menu");
    }
  }

  Future<int> getMenuCount() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('menu_cafe').get();
      return snapshot.size;
    } catch (e) {
      print('Error fetching player count: $e');
      throw Exception('Error fetching player count.');
    }
  }
}
