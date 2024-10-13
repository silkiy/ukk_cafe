import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu.dart';

class MenuService {
  Future<List<Menu>> getMenu() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('menu_cafe').get();

      List<Menu> menuList = querySnapshot.docs.map((doc) {
        return Menu.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return menuList;
    } catch (e) {
      print("Error mengambil menu: $e");
      throw Exception("Error mengambil menu");
    }
  }
}
