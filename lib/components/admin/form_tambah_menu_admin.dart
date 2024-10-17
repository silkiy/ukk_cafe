import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ukk_cafe/components/admin/title_tambah_data.dart';

import '../general_component/input_text_form_field.dart';

class FormTambahMenuAdmin extends StatefulWidget {
  final Function(String) onNamaMenuChanged;
  final Function(String) onjenisMenuChanged;
  final Function(String) onHargaMenuChanged;
  final Function(String) onDeskripsiMenuChanged;

  FormTambahMenuAdmin({
    super.key,
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
  final TextEditingController hargaMenuController = TextEditingController();
  final TextEditingController jenisMenuController = TextEditingController();
  final TextEditingController deskripsiMenuController = TextEditingController();

  @override
  void initState() {
    super.initState();
    namaMenuController.addListener(_handleNamaMenuChanged);

    jenisMenuController.addListener(_handleJenisMenuChanged);
    hargaMenuController.addListener(_handleHargaMenuChanged);
    deskripsiMenuController.addListener(_handleDeskripsiMenuChanged);
  }

  @override
  void dispose() {
    namaMenuController.dispose();
    jenisMenuController.dispose();
    hargaMenuController.dispose();
    deskripsiMenuController.dispose();
    super.dispose();
  }

  void _handleNamaMenuChanged() {
    widget.onNamaMenuChanged(namaMenuController.text);
  }

  void _handleJenisMenuChanged() {
    widget.onjenisMenuChanged(jenisMenuController.text);
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
              leading: "Jenis",
              hintText: "jenis Menu",
              controller: jenisMenuController,
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
            )
          ],
        ),
      ),
    );
  }
}
