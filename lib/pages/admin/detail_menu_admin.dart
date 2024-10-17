import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukk_cafe/components/admin/data_menu_admin_list_detail.dart';
import 'package:ukk_cafe/components/admin/data_menu_top.dart';
import 'package:ukk_cafe/components/admin/menu_detail_card.dart';
import 'package:ukk_cafe/models/menu.dart';
import 'package:ukk_cafe/services/menu_service.dart';

class DetailMenuAdmin extends StatefulWidget {
  const DetailMenuAdmin({super.key});

  @override
  State<DetailMenuAdmin> createState() => _DetailMenuAdminState();
}

class _DetailMenuAdminState extends State<DetailMenuAdmin> {
  late Future<List<Menu>> _getMenu;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Call fetchUsersByRole to get the players here
    _getMenu = MenuService().getMenu();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Extract the necessary data
    final String namaMenu = args['namaMenu'] ?? 'Unknown Menu';
    final String jenisMenu = args['jenis'] ?? 'Unknown Type';
    final String hargaMenu = args['harga'] ?? '0'; // Or handle it accordingly
    final String imgMenu = args['img'] ?? 'default_image_path'; // Placeholder
    final String idMenu = args['id'] ?? 'Unknown ID';
    final String deskripsiMenu =
        args['deskripsi'] ?? 'No description available';

    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 248, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Details menu",
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<List<Menu>>(
        future: _getMenu,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Tidak ada meu yang ditemukan'),
            );
          }

          return Container(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MenuDetailCard(
                      imagePath: imgMenu,
                      namaMenu: namaMenu,
                      jenisMenu: jenisMenu,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    DataMenuTop(
                      textLeading: 'Data menu',
                      textAction: 'Edit',
                      route: '',
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            DataMenuAdminListDetail(
                              detail: namaMenu,
                              type: "nama",
                            ),
                            SizedBox(height: 5),
                            DataMenuAdminListDetail(
                              detail: jenisMenu,
                              type: "jenis",
                            ),
                            SizedBox(height: 5),
                            DataMenuAdminListDetail(
                              detail: deskripsiMenu,
                              type: "deskripsi",
                            ),
                            SizedBox(height: 5),
                            DataMenuAdminListDetail(
                              detail: hargaMenu,
                              type: "harga",
                            ),
                            SizedBox(height: 5),
                            DataMenuAdminListDetail(
                              detail: idMenu,
                              type: "Id Menu",
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
