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

  Future<void> deleteMenuById(String id) async {
    try {
      // Cek apakah menu dengan ID yang diberikan ada
      DocumentSnapshot docSnapshot =
          await _firestore.collection('menu_cafe').doc(id).get();

      if (!docSnapshot.exists) {
        print('Menu with ID: $id does not exist.');
        throw Exception('Menu not found.');
      }

      // Lakukan penghapusan dokumen jika menu ada
      await _firestore.collection('menu_cafe').doc(id).delete();
      print('Menu with ID: $id successfully deleted');
    } catch (e) {
      print('Error deleting menu: $e');

      // Memunculkan pesan kesalahan yang lebih spesifik
      if (e is FirebaseException && e.code == 'permission-denied') {
        throw Exception(
            'Permission denied. You do not have permission to delete this menu.');
      } else {
        throw Exception('Failed to delete menu. Error: $e');
      }
    }
  }

  Future<void> updateMenuById({
    required String id,
    String? imageUrl,
    String? nama,
    String? jenis,
    String? hargaMenu,
    String? deskripsi,
  }) async {
    try {
      // Cek apakah menu dengan ID yang diberikan ada
      DocumentSnapshot docSnapshot =
          await _firestore.collection('menu_cafe').doc(id).get();

      if (!docSnapshot.exists) {
        print('Menu with ID: $id does not exist.');
        throw Exception('Menu not found.');
      }

      // Membuat map untuk data yang akan diperbarui
      Map<String, dynamic> updatedData = {};

      if (imageUrl != null) updatedData['img'] = imageUrl;
      if (nama != null) updatedData['name'] = nama;
      if (jenis != null) updatedData['jenis'] = jenis;
      if (hargaMenu != null) {
        num harga = num.parse(hargaMenu); // Parsing hargaMenu ke num
        updatedData['harga'] = harga;
      }
      if (deskripsi != null) updatedData['deskripsi'] = deskripsi;

      // Melakukan pembaruan dokumen
      await _firestore.collection('menu_cafe').doc(id).update(updatedData);
      print('Menu with ID: $id successfully updated');
    } catch (e) {
      print('Error updating menu: $e');

      // Memunculkan pesan kesalahan yang lebih spesifik
      if (e is FirebaseException && e.code == 'permission-denied') {
        throw Exception(
            'Permission denied. You do not have permission to update this menu.');
      } else {
        throw Exception('Failed to update menu. Error: $e');
      }
    }
  }
}
