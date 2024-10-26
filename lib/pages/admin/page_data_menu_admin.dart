import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/admin/informasi_menu_admin.dart';
import '../../models/menu.dart';
import '../../services/menu_service.dart';

class PageDataMenuAdmin extends StatefulWidget {
  const PageDataMenuAdmin({super.key});

  @override
  State<PageDataMenuAdmin> createState() => _PageDataMenuAdminState();
}

class _PageDataMenuAdminState extends State<PageDataMenuAdmin> {
  final MenuService _menuService = MenuService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 244, 248, 1),
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text(
          "Data Menu",
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(203, 24, 28, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(15),
              child: Text(
                "Data Menu",
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<Menu>>(
              future: _menuService.getMenu(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada menu yang ditemukan'),
                  );
                }

                final menuList = snapshot.data!;

                return Expanded(
                  child: ListView.builder(
                    itemCount: menuList.length,
                    itemBuilder: (context, index) {
                      final menu = menuList[index];
                      return InformasiMenuAdmin(
                        namaMenu: menu.name,
                        jenis: menu.jenis,
                        id: menu.id,
                        img: menu.img,
                        harga: menu.harga.toString(),
                        deskripsi: menu.deskripsi,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
