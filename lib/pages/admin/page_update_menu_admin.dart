import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukk_cafe/services/menu_service.dart';
import '../../components/general_component/dropdown_jenis_menu.dart';

class UpdateMenuPage extends StatefulWidget {
  const UpdateMenuPage({super.key});

  @override
  State<UpdateMenuPage> createState() => _UpdateMenuPageState();
}

class _UpdateMenuPageState extends State<UpdateMenuPage> {
  final MenuService _menuService = MenuService();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  String? _jenisMenu;
  String? _idMenu;

  bool isDataLoaded = false; // Menyimpan status pemuatan data pertama kali

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isDataLoaded) {
      // Cek jika data belum dimuat
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _idMenu = args['id'] ?? 'Unknown ID';

      // Set nilai awal satu kali saja
      _namaController.text = args['namaMenu'] ?? '';
      _jenisMenu = args['jenis'] ?? '';
      _hargaController.text = args['harga'] ?? '';
      _deskripsiController.text = args['deskripsi'] ?? '';

      isDataLoaded = true;
    }
  }

  void _onJenisMenuSelected(String jenis) {
    setState(() {
      _jenisMenu = jenis;
    });
  }

  Future<void> _updateMenu() async {
    try {
      await _menuService.updateMenuById(
        id: _idMenu!,
        nama: _namaController.text,
        jenis: _jenisMenu ?? '',
        hargaMenu: _hargaController.text,
        deskripsi: _deskripsiController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Menu updated successfully')),
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Menu has been updated successfully.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Failed to update menu: $e');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to update menu: $e'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update menu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 248, 1),
      appBar: AppBar(
        title: Text(
          'Update Menu',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Menu'),
              ),
              SizedBox(height: 16),
              DropdownJenisMenu(
                onJenisMenuSelected: _onJenisMenuSelected,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _hargaController,
                decoration: InputDecoration(labelText: 'Harga Menu'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _deskripsiController,
                decoration: InputDecoration(labelText: 'Deskripsi Menu'),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  onTap: _updateMenu,
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.14,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(203, 24, 28, 1),
                      borderRadius: BorderRadius.circular(16),
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
                        "Update Menu",
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
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
  }
}
