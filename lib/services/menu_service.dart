import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu.dart';

class MenuService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
