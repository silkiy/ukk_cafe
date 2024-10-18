import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukk_cafe/components/admin/title_tambah_data.dart';
import 'package:ukk_cafe/components/general_component/dropdown_jenis_menu.dart';

import '../general_component/input_text_form_field.dart';

class FormTambahMenuAdmin extends StatefulWidget {
  final Function(String) onIdMenuChanged;
  final Function(String) onNamaMenuChanged;
  final Function(String) onjenisMenuChanged;
  final Function(String) onHargaMenuChanged;
  final Function(String) onDeskripsiMenuChanged;

  FormTambahMenuAdmin({
    super.key,
    required this.onIdMenuChanged,
    required this.onHargaMenuChanged,
    required this.onNamaMenuChanged,
    required this.onDeskripsiMenuChanged,
    required this.onjenisMenuChanged,
  });

  @override
  State<FormTambahMenuAdmin> createState() => _FormTambahMenuAdminState();
}

class _FormTambahMenuAdminState extends State<FormTambahMenuAdmin> {
  final TextEditingController namaMenuController = TextEditingController();
  final TextEditingController idMenuController = TextEditingController();
  final TextEditingController hargaMenuController = TextEditingController();
  final TextEditingController deskripsiMenuController = TextEditingController();
  String _jenisMenus = 'Pilih jenis menu';

  @override
  void initState() {
    super.initState();
    namaMenuController.addListener(_handleNamaMenuChanged);

    hargaMenuController.addListener(_handleHargaMenuChanged);
    deskripsiMenuController.addListener(_handleDeskripsiMenuChanged);
  }

  @override
  void dispose() {
    namaMenuController.dispose();
    hargaMenuController.dispose();
    _jenisMenus.toString();
    deskripsiMenuController.dispose();
    super.dispose();
  }

  void _handleIdMenuChanged() {
    widget.onIdMenuChanged(idMenuController.text);
  }

  void _handleNamaMenuChanged() {
    widget.onNamaMenuChanged(namaMenuController.text);
  }

  void _handleJenisMenuChanged(String? jenisMenu) {
    setState(() {
      _jenisMenus = jenisMenu!;
      widget.onjenisMenuChanged(_jenisMenus);
    });
  }

  void _handleHargaMenuChanged() {
    widget.onHargaMenuChanged(hargaMenuController.text);
  }

  void _handleDeskripsiMenuChanged() {
    widget.onDeskripsiMenuChanged(deskripsiMenuController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        child: Column(
          children: [
            TitleTambahData(
              title: "Menu",
              icon: Icons.food_bank_outlined,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            InputFormField(
              leading: 'Nama',
              hintText: 'Nama Menu',
              controller: namaMenuController,
            ),
            InputFormField(
              leading: "ID",
              hintText: "Id Menu",
              controller: idMenuController,
            ),
            DropdownJenisMenu(
              onJenisMenuSelected: (jenisMenu) {
                _jenisMenus = jenisMenu;
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            InputFormField(
              leading: "Harga",
              hintText: "Harga Menu",
              controller: hargaMenuController,
            ),
            InputFormField(
              leading: "Deskripsi",
              hintText: "Deskripsi Menu",
              controller: deskripsiMenuController,
            ),
          ],
        ),
      ),
    );
  }
}
