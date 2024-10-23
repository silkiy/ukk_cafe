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
  final MenuService _menuService = MenuService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Call fetchUsersByRole to get the players here
    _getMenu = MenuService().getMenu();
  }

  void _onDeleteMenu(String menuId) async {
    // Tampilkan dialog konfirmasi sebelum menghapus
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Menu'),
          content: Text('Are you sure you want to delete this menu?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // Batalkan penghapusan
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true); // Konfirmasi penghapusan
              },
            ),
          ],
        );
      },
    );

    // Jika konfirmasi penghapusan diterima
    if (confirmDelete == true) {
      try {
        await _menuService.deleteMenuById(menuId);
        print('Menu deleted successfully');

        // Tampilkan feedback setelah sukses menghapus menu
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Menu deleted successfully'),
          ),
        );

        // Tampilkan AlertDialog untuk konfirmasi sukses
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Menu deleted successfully.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Tutup dialog
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Failed to delete menu: $e');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete menu: $e'),
          ),
        );
      }
    }
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
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/update_menu', arguments: {
                          'namaMenu': namaMenu,
                          'jenis': jenisMenu,
                          'harga': hargaMenu,
                          'img': imgMenu,
                          'id': idMenu,
                          'deskripsi': deskripsiMenu,
                        });
                      },
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: GestureDetector(
                        onTap: () {
                          _onDeleteMenu(idMenu);
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.width * 0.14,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(203, 24, 28, 1),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "Delete",
                              style: GoogleFonts.poppins(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
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
