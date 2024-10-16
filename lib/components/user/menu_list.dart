import 'package:flutter/material.dart';
import '../../models/menu.dart';
import '../../pages/user/menu_detail_page.dart';
import 'menu_card.dart'; // Import MenuCard untuk menampilkan setiap item

class MenuList extends StatelessWidget {
  final List<Menu> menus;

  const MenuList({
    super.key,
    required this.menus,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
        childAspectRatio: 0.75,
      ),
      itemCount: menus.length, // Jumlah item dalam grid
      itemBuilder: (context, index) {
        final menu = menus[index];
        return GestureDetector(
          onTap: () {
            // Navigate to MenuDetailPage when the item is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MenuDetailPage(menu: menu),
              ),
            );
          },
          child: MenuCard(
            id: menu.id,
            name: menu.name,
            jenis: menu.jenis,
            harga: menu.harga.toString(),
            img: menu.img,
          ),
        );
      },
    );
  }
}
